{ The contents of this file are subject to the Mozilla Public License  }
{ Version 1.1 (the "License"); you may not use this file except in     }
{ compliance with the License. You may obtain a copy of the License at }
{ http://www.mozilla.org/MPL/                                          }
{                                                                      }
{ Software distributed under the License is distributed on an "AS IS"  }
{ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See  }
{ the License for the specific language governing rights and           }
{ limitations under the License.                                       }
{                                                                      }
{ The Original Code is BhoShell.pas.                                   }
{                                                                      }
{ The Initial Developer of the Original Code is Ashley Godfrey, all    }
{ Portions created by these individuals are Copyright (C) of Ashley    }
{ Godfrey.                                                             }
{                                                                      }
{**********************************************************************}
{                                                                      }
{ This unit contains a complete stub library for implementing your own }
{ browser helper objects (BHO's) in Delphi. This unit includes the     }
{ custom BHO class, class factory and global application class.        } 
{                                                                      }
{ Unit owner: Ashley Godfrey.                                          }
{ Last modified: April 23, 2004.                                       }
{ Updates available from http://www.evocorp.com                        }
{                                                                      }
{**********************************************************************}

unit BhoShell;
interface
uses
  // ShDocVwEvents can be found on EvoCorp's web site,
  // http://www.evocorp.com
  SysUtils, Windows, Classes, ActiveX, ComObj, ShDocVw, ShDocVwEvents;

const
  // IID_IBrowserHelper is defined to enable recognition of a
  // TBrowserHelperObject object as an IBrowserHelper interface.
  // This is used internally to broadcast events to all browser
  // helper objects.
  SIID_IBrowserHelper = '{559F5066-EA89-40B2-95BE-8E51573C6F20}';
  IID_IBrowserHelper: TIID = SIID_IBrowserHelper;

type
  TBrowserHelperObject = class;
  TBrowserHelperApplication = class;

  // The BrowserHelperEvents interface is used to provide global
  // event feedback to each individual browser helper object.
  IBrowserHelper = interface
  [SIID_IBrowserHelper]
    // The OnBhoCreated event is generated whenever a browser
    // helper object is created. This occurrs before the object
    // is actually installed within the Internet Explorer
    // framework.
    procedure OnBhoCreated(const Bho: TBrowserHelperObject);
    // The OnBhoCreated event is generated whenever a browser
    // helper object is destroyed. This is called after the
    // object has been removed (or uninstalled) from the
    // Internet Explorer framework.
    procedure OnBhoDestroyed(const Bho: TBrowserHelperObject);
    // The OnBhoCreated event is generated whenever a browser
    // helper object is installed into the Internet Explorer
    // framework via its IObjectWithSite interface.
    procedure OnBhoInstalled(const Bho: TBrowserHelperObject);
    // The OnBhoCreated event is generated whenever a browser
    // helper object is removed (or uninstalled) from the
    // Internet Explorer framework via its IObjectWithSite interface.
    procedure OnBhoUninstalled(const Bho: TBrowserHelperObject);
  end;

  // TBrowserHelperObject is the base class from which you would
  // derive your own individual browser helper objects. For example:
  //
  // type
  //   TMyBhoObject = class(TBrowserHelperObject)
  //     ...
  //   end;
  TBrowserHelperObject = class(TComObject, IDispatch, IObjectWithSite,
    IBrowserHelper)
  private
    FEvents: TWebBrowserEvents;
    FObjectSite: IInterface;
    FWebBrowser: IWebBrowser2;
  protected
    // IDispatch
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
    // IObjectWithSite
    function SetSite(const pUnkSite: IUnknown): HResult; virtual; stdcall;
    function GetSite(const riid: TIID; out site: IUnknown): HResult; virtual; stdcall;
    // IBrowserHelper
    procedure OnBhoCreated(const Bho: TBrowserHelperObject); virtual;
    procedure OnBhoDestroyed(const Bho: TBrowserHelperObject); virtual;
    procedure OnBhoInstalled(const Bho: TBrowserHelperObject); virtual;
    procedure OnBhoUninstalled(const Bho: TBrowserHelperObject); virtual;
    // TBrowserHelperObject
    procedure DoEventsConnected; virtual;    // You put your code in here that
                                             // specifies which events to capture.
    procedure DoEventsDisconnected; virtual;
    procedure InstallSite(const pUnkSite: IInterface); virtual;
    procedure OnBrowserQuit(Sender: TObject); virtual;
    procedure UninstallSite; virtual;
  public
    destructor Destroy; override;
    procedure Initialize; override;

    property Events: TWebBrowserEvents read FEvents;
    property ObjectSite: IInterface read FObjectSite;
    property WebBrowser: IWebBrowser2 read FWebBrowser;
  end;

  // TBrowserHelperList is used to maintain the list of
  // TBrowserHelperObject objects instantiated throughout the lifespan
  // of the application. You should never have to instantiate this
  // class yourself.
  TBrowserHelperList = class
  private
    FItems: TList;

    function GetCount: Integer;
    function GetItem(Index: Integer): TBrowserHelperObject;
  public
    procedure Add(const BrowserHelperObject: TBrowserHelperObject);
    procedure Clear;
    constructor Create;
    procedure Delete(Index: Integer);
    destructor Destroy; override;
    function IndexOf(const BrowserHelperObject: TBrowserHelperObject): Integer;
    procedure Remove(const BrowserHelperObject: TBrowserHelperObject;
      const ReleaseBho: Boolean = True);

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TBrowserHelperObject read GetItem; default;
  end;

  // TBrowserHelperApplication is a single-instance-per-process
  // object that enables various instances of Browser Helper Objects
  // created within the current process to communicate.
  TBrowserHelperApplication = class
  private
    FBhoList: TBrowserHelperList;

    procedure BroadcastBhoCreated(const Bho: TBrowserHelperObject);
    procedure BroadcastBhoDestroyed(const Bho: TBrowserHelperObject);
    procedure BroadcastBhoInstalled(const Bho: TBrowserHelperObject);
    procedure BroadcastBhoUninstalled(const Bho: TBrowserHelperObject);
    function GetLibraryFileName: string;
  public
    constructor Create;
    destructor Destroy; override;

    property BhoList: TBrowserHelperList read FBhoList;
    property LibraryFileName: string read GetLibraryFileName;
  end;

  // TBrowserHelperFactory provides the mechanics required to
  // register your COM object as a browser helper object. When
  // creating your BHO object, you need to use this class (or
  // a child thereof) for registration of your objects. For
  // example:
  //
  //   TBrowserHelperFactory.Create(ComServer, TMyBhoObject,
  //     Class_MyBhoObject, '', '', ciMultiInstance, tmApartment);
  TBrowserHelperFactory = class(TComObjectFactory)
  private
    procedure InstallRegistryKey;
    procedure RemoveRegistryKey;
  public
    procedure UpdateRegistry(Register: Boolean); override;
  end;

function Application: TBrowserHelperApplication;

implementation
uses
  ComServ, Registry,
  // BhoShellHost can be found on EvoCorp's web site,
  // http://www.evocorp.com
  BhoShellHost;

var
  _Application: TBrowserHelperApplication = nil;

function Application: TBrowserHelperApplication;
begin
  Result := _Application;
end;

{ TBrowserHelperList }

procedure TBrowserHelperList.Add(
  const BrowserHelperObject: TBrowserHelperObject);
begin
  if FItems.IndexOf(BrowserHelperObject) = -1 then
    FItems.Add(BrowserHelperObject);
end;

procedure TBrowserHelperList.Clear;
var i: Integer;
begin
  if FItems.Count > 0 then
    for i := FItems.Count - 1 downto 0 do
      Delete(i);
end;

constructor TBrowserHelperList.Create;
begin
  FItems := TList.Create;
end;

procedure TBrowserHelperList.Delete(Index: Integer);
var Item: TBrowserHelperObject;
begin
  Item := TBrowserHelperObject(FItems[Index]);
  FItems.Delete(Index);
  Item.Free;
end;

destructor TBrowserHelperList.Destroy;
begin
  if Assigned(FItems) then
  try
    Clear;
  finally
    FreeAndNil(FItems);
  end;
  inherited;
end;

function TBrowserHelperList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TBrowserHelperList.GetItem(Index: Integer): TBrowserHelperObject;
begin
  Result := TBrowserHelperObject(FItems[Index]);
end;

function TBrowserHelperList.IndexOf(
  const BrowserHelperObject: TBrowserHelperObject): Integer;
begin
  Result := FItems.IndexOf(BrowserHelperObject);
end;

procedure TBrowserHelperList.Remove(
  const BrowserHelperObject: TBrowserHelperObject;
  const ReleaseBho: Boolean = True);
var Index: Integer;
begin
  Index := IndexOf(BrowserHelperObject);
  if Index <> -1 then
    if ReleaseBho then
      Delete(Index)
    else FItems.Delete(Index);
end;

{ TBrowserHelperObject }

destructor TBrowserHelperObject.Destroy;
begin
  // Broadcast our disappearance.
  if _Application <> nil then
  begin
    _Application.BroadcastBhoDestroyed(Self);
    _Application.BhoList.Remove(Self, False);
  end;

  // And finalize our objects
  if Assigned(FEvents) then
    FreeAndNil(FEvents);

  inherited;
end;

procedure TBrowserHelperObject.DoEventsConnected;
begin
  // Stub
  // This method is called after the events handler has been
  // connected to the web browser. Inherited classes (e.g.,
  // any classes you create from this class) would use this
  // method to hook in to any required web browser events.
end;

procedure TBrowserHelperObject.DoEventsDisconnected;
begin
  // Stub
end;

function TBrowserHelperObject.GetIDsOfNames(const IID: TGUID;
  Names: Pointer; NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TBrowserHelperObject.GetSite(
  const riid: TIID; out site: IInterface): HResult;
begin
  // By default, we don't support a site.
  pointer(site) := nil;
  Result := E_FAIL;
end;

function TBrowserHelperObject.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
  // By default our browser helper objects do not support
  // type information...
  Result := E_NOTIMPL;
  pointer(TypeInfo) := nil;
end;

function TBrowserHelperObject.GetTypeInfoCount(
  out Count: Integer): HResult;
begin
  // ...and because we don't support type information (see
  // "GetTypeInfo", above) we can't return a count for type
  // information.
  Result := E_NOTIMPL;
  Count := 0;
end;

procedure TBrowserHelperObject.Initialize;
begin
  inherited;
  if _Application <> nil then
  begin
    // Created any local objects
    FEvents := TWebBrowserEvents.Create;
    FEvents.OnQuit := OnBrowserQuit;

    // Broadcast our arrival
    _Application.BhoList.Add(Self);
    _Application.BroadcastBhoCreated(Self);
  end;
end;

procedure TBrowserHelperObject.InstallSite(const pUnkSite: IInterface);
begin
  // InstallSite is called whenever the browser helper object has
  // detected that it's been installed into an instance of Internet
  // Explorer. This is where we find out about the associated
  // web browser object and connect our event handler.
  if pUnkSite <> nil then
  begin
    // Store information regarding the object site
    FObjectSite := pUnkSite;
    // Find the web browser...
    FWebBrowser := pUnkSite as IWebBrowser2;
    // ...and connect our event handler to it.
    FEvents.Connect(FWebBrowser);
    DoEventsConnected;

    // Broadcase our connection to the rest of the application
    if _Application <> nil then
      _Application.BroadcastBhoInstalled(Self);
  end;
end;

function TBrowserHelperObject.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
begin
  // Um, let's just assume that it worked. After all, assumptions
  // are never wrong... Are they?
  Result := S_OK;
end;

procedure TBrowserHelperObject.OnBhoCreated(
  const Bho: TBrowserHelperObject);
begin
  // Stub
  // If you need to do anything when another Bho has been
  // created somewhere in the application then this is the
  // place to do it.
end;

procedure TBrowserHelperObject.OnBhoDestroyed(
  const Bho: TBrowserHelperObject);
begin
  // Stub
  // If you need to do anything when another Bho has been
  // destroyed then this is the place to do it.
end;

procedure TBrowserHelperObject.OnBhoInstalled(
  const Bho: TBrowserHelperObject);
begin
  // Stub
  // If you need to do anything when another Bho has been
  // installed within another web browser then this is the
  // place to do it.
end;

procedure TBrowserHelperObject.OnBhoUninstalled(
  const Bho: TBrowserHelperObject);
begin
  // Stub
  // If you need to do anything when another Bho has been
  // removed from within another web browser then this is the
  // place to do it.
end;

procedure TBrowserHelperObject.OnBrowserQuit(Sender: TObject);
begin
  UninstallSite;
end;

function TBrowserHelperObject.SetSite(const pUnkSite: IInterface): HResult;
begin
  // We use the SetSite method to determine whether or not
  // we're being installed into, or removed from the associated
  // web browser. Note that we're not going to install ourselves
  // if this is not Internet Explorer.
  try
    if ShellType = stInternetExplorer then
      if pUnkSite <> nil then
        InstallSite(pUnkSite)
      else UninstallSite;
    Result := S_OK
  except
    Result := E_FAIL;  // If something generates an unhandled exception
                       // (unhandled as we've had to catch it here), then
                       // we'll return a general failure result. The other
                       // option is to return E_UNEXPECTED.
  end;
end;

procedure TBrowserHelperObject.UninstallSite;
begin
  // Broadcast our shutdown to the rest of the application
  if _Application <> nil then
    _Application.BroadcastBhoUninstalled(Self);

  // Disconnect and forget anything we previously knew about the
  // site we were connected to, as it is now entirely irrelevant.
  DoEventsDisconnected;
  FEvents.Disconnect;   // Disconnect the events mechanism
  FWebBrowser := nil;   // Forget about our web browser
  FObjectSite := nil;   // and the site we were installed into.
end;

{ TBrowserHelperApplication }

procedure TBrowserHelperApplication.BroadcastBhoCreated(
  const Bho: TBrowserHelperObject);
var i: Integer;
    BhoEventObj: IBrowserHelper;
begin
  // Broadcast the "Bho Created" event to all registered Bho's
  if FBhoList.Count > 0 then
    for i := 0 to FBhoList.Count - 1 do
      if Supports(FBhoList[i], IBrowserHelper, BhoEventObj) then
      try
        BhoEventObj.OnBhoCreated(Bho);
      finally
        BhoEventObj := nil;
      end;
end;

procedure TBrowserHelperApplication.BroadcastBhoDestroyed(
  const Bho: TBrowserHelperObject);
var i: Integer;
    BhoEventObj: IBrowserHelper;
begin
  // Broadcast the "Bho Destroyed" event to all registered Bho's
  if FBhoList.Count > 0 then
    for i := 0 to FBhoList.Count - 1 do
      if Supports(FBhoList[i], IBrowserHelper, BhoEventObj) then
      try
        BhoEventObj.OnBhoDestroyed(Bho);
      finally
        // Don't dereference the interface - BroadcastBhoDestroyed
        // is called from the browser helper objects Destroy method,
        // so dereferencing an interface whose object is already on
        // a zero reference count is not a good thing.
        pointer(BhoEventObj) := nil;
      end;
end;

procedure TBrowserHelperApplication.BroadcastBhoInstalled(
  const Bho: TBrowserHelperObject);
var i: Integer;
    BhoEventObj: IBrowserHelper;
begin
  // Broadcast the "Bho Installed" event to all registered Bho's
  if FBhoList.Count > 0 then
    for i := 0 to FBhoList.Count - 1 do
      if Supports(FBhoList[i], IBrowserHelper, BhoEventObj) then
      try
        BhoEventObj.OnBhoInstalled(Bho);
      finally
        BhoEventObj := nil;
      end;
end;

procedure TBrowserHelperApplication.BroadcastBhoUninstalled(
  const Bho: TBrowserHelperObject);
var i: Integer;
    BhoEventObj: IBrowserHelper;
begin
  // Broadcast the "Bho Uninstalled" event to all registered Bho's
  if FBhoList.Count > 0 then
    for i := 0 to FBhoList.Count - 1 do
      if Supports(FBhoList[i], IBrowserHelper, BhoEventObj) then
      try
        BhoEventObj.OnBhoUninstalled(Bho);
      finally
        BhoEventObj := nil;
      end;
end;

constructor TBrowserHelperApplication.Create;
begin
  FBhoList := TBrowserHelperList.Create;
end;

destructor TBrowserHelperApplication.Destroy;
begin
  if Assigned(FBhoList) then
    FreeAndNil(FBhoList);
  inherited;
end;

function TBrowserHelperApplication.GetLibraryFileName: string;
var FileName: array [0..MAX_PATH + 1] of char;
begin
  // GetLibraryFileName returns the fully qualified path for
  // the current module (i.e., the name of this DLL, including
  // the folder in which it is installed). This is useful for
  // locating other files associated with your BHO.
  FillChar(FileName, SizeOf(FileName), 0);
  GetModuleFileName(hInstance, @FileName, MAX_PATH);
  Result := FileName;
end;

{ TBrowserHelperFactory }

procedure TBrowserHelperFactory.InstallRegistryKey;
var RegKey: string;
    Reg : TRegistry;
begin
  with TRegistry.Create do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    // BHO's are identified by creating a key whose name represents
    // the physical class identifier of the COM class your BHO is
    // represented by.
    RegKey := '\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\' +
              'Browser Helper Objects\' + GuidToString(ClassID);
    if OpenKey(RegKey, True) then
      CloseKey;

    // чтобы библиотека не искользовалась Windows Explorer
    Reg := TRegistry.Create;
    try
        //Reg.Access := KEY_WOW64_32KEY or KEY_READ;
        Reg.RootKey := HKEY_LOCAL_MACHINE;
        if Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\' +
              'Browser Helper Objects\' + GuidToString(ClassID), True) then
        begin
            Reg.WriteInteger('NoExplorer',1);
            Reg.CloseKey;
        end;
    finally
        Reg.Free;
    end;
  finally
    Free;
  end;
end;

procedure TBrowserHelperFactory.RemoveRegistryKey;
var RegKey: string;
begin
  with TRegistry.Create do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    RegKey := '\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\' +
              'Browser Helper Objects\' + GuidToString(ClassID);
    if KeyExists(RegKey) then
      DeleteKey(RegKey);
  finally
    Free;
  end;
end;

procedure TBrowserHelperFactory.UpdateRegistry(Register: Boolean);
begin
  // The inherited code (un)registers the physical COM class
  inherited;
  // Our code (un)registers our class with the Windows BHO list.
  if Register then
    InstallRegistryKey
  else RemoveRegistryKey;
end;

initialization
  // Both Windows Explorer and Internet Explorer load browser helper
  // objects. By default we only maintain interest in Internet Explorer,
  // so if this isn't Internet Explorer then don't instantiate the
  // application.
  if ShellType = stInternetExplorer then
    _Application := TBrowserHelperApplication.Create;

finalization
  if Assigned(_Application) then
    FreeAndNil(_Application);

end.
