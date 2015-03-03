unit WinSystemFunctionsUnit;

interface

uses
   Windows, Classes, SysUtils,
   Dialogs, ShellApi, IdGlobal, Tlhelp32;

   function SystemDirectory: string;
   function GetTempDir: string;
   function KillTask(ExeFileName: String): integer;
   function ReadUsersHdSystem(): string;
   procedure OpenBrowserUrl( surl : string );
   function GetFileSize(FileName: string): Longint;
   function isnumber(str_:string):boolean;
   procedure ExecAndWait(path: String; w:boolean);



implementation

const
   HKEYNames: array[0..6] of string = ('HKEY_CLASSES_ROOT', 'HKEY_CURRENT_USER', 'HKEY_LOCAL_MACHINE', 'HKEY_USERS', 'HKEY_PERFORMANCE_DATA', 'HKEY_CURRENT_CONFIG', 'HKEY_DYN_DATA');

procedure ExecAndWait(path: String; w:boolean);
var
   si: TStartupInfo;
   p: TProcessInformation;
begin
   FillChar(Si, SizeOf(Si), #0);
   with Si do
      begin
         cb := SizeOf(Si);
         dwFlags := startf_UseShowWindow;
         wShowWindow := SW_HIDE;
      end;
   CreateProcess(nil, PChar(path), nil, nil, false, create_default_error_mode, nil, nil, si, p);
   if w then
      Waitforsingleobject(p.hProcess, infinite);
end;
function isnumber(str_:string):boolean;
begin
result:=true;
try
StrToInt(str_);
except
result:=false;
exit;
end;
end;


function GetFileSize(FileName: string): Longint;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(FileName, faAnyFile, SearchRec) = 0 then
    Result:=SearchRec.Size
  else
    Result:=-1;
end;


function SystemDirectory: string;
var
   SysDir: PChar;
begin
   SysDir := StrAlloc(MAX_PATH);
   GetSystemDirectory(SysDir, MAX_PATH);
   Result := string(SysDir);
   if Result[Length(Result)] <> '\' then
      Result := Result + '\';
   StrDispose(SysDir);
end;

procedure OpenBrowserUrl( surl : string );
begin
  ShellExecute(0, 'open', PChar(surl), nil, nil, SW_SHOWNORMAL);
end;

function GetTempDir: string;
var
   Buffer: array[0..MAX_PATH] of Char;
begin
   GetTempPath(SizeOf(Buffer) - 1, Buffer);
   Result := StrPas(Buffer);
end;

function ReadUsersHdSystem(): string;
var
   lpRootPathName : PChar;
   lpVolumeNameBuffer : PChar;
   nVolumeNameSize : DWORD;
   lpVolumeSerialNumber : DWORD;
   lpMaximumComponentLength : DWORD;
   lpFileSystemFlags : DWORD;
   lpFileSystemNameBuffer : PChar;
   nFileSystemNameSize : DWORD;
begin
   lpVolumeNameBuffer := '';
   lpVolumeSerialNumber := 0;
   lpMaximumComponentLength:= 0;
   lpFileSystemFlags := 0;
   lpFileSystemNameBuffer := '';
   Result := '';
   try
      GetMem(lpVolumeNameBuffer, MAX_PATH + 1);
      GetMem(lpFileSystemNameBuffer, MAX_PATH + 1);
      nVolumeNameSize := MAX_PATH + 1;
      nFileSystemNameSize := MAX_PATH + 1;
      lpRootPathName := PChar('C:\');
      if GetVolumeInformation( lpRootPathName,
                               lpVolumeNameBuffer,
                               nVolumeNameSize,
                               @lpVolumeSerialNumber,
                               lpMaximumComponentLength,
                               lpFileSystemFlags,
                               lpFileSystemNameBuffer,
                               nFileSystemNameSize )
      then
         Result := IntToHex(HIWord(lpVolumeSerialNumber), 4) + '-' + IntToHex(LOWord(lpVolumeSerialNumber), 4);
      finally
         FreeMem(lpVolumeNameBuffer);
         FreeMem(lpFileSystemNameBuffer);
      end;
end;

function KillTask(ExeFileName: String): integer;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  While integer(ContinueLoop) <> 0 do
  Begin
    if (
        (UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName)) OR 
        (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))
        ) Then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0));
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  End;
  CloseHandle(FSnapshotHandle);
end;

end.
 