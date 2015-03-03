////////////////////////////////////////////////////////////////////////////////
//
//  ****************************************************************************
//  * Unit Name : uWinVersion
//  * Purpose   : Класс для определения версии Windows
//  * Author    : Dmitry V. Muratov
//  * Version   : 2.1
//  * Home Page :
//  ****************************************************************************
//

unit uWinVersion;

interface

uses
  Windows, SysUtils, Classes;

type

  TOSPlatform = (
    ospWinNT,               // Windows NT platform
    ospWin9x,               // Windows 9x platform
    ospWin32s               // Win32s platform
  );

  TOSProduct = (
    osUnknownWinNT,         // Unknown Windows NT OS
    osWinNT,                // Windows NT (up to v4)
    osWin2K,                // Windows 2000
    osWinXP,                // Windows XP
    osUnknownWin9x,         // Unknown Windows 9x OS
    osWin95,                // Windows 95
    osWin98,                // Windows 98
    osWinMe,                // Windows Me
    osUnknownWin32s,        // Unknown OS running Win32s
    osWinSvr2003,           // Windows Server 2003
    osUnknown,              // Completely unknown Windows
    osWinVista,             // Windows Vista
    osWinSvr2003R2,         // Windows Server 2003 R2
    osWinSvr2008,           // Windows Server 2008
    osWinLater,             // A later version of Windows than v6.1
    osWin7,                 // Windows 7
    osWinSvr2008R2          // Windows Server 2008 R2
  );

  TProcessorArchitecture = (
    paUnknown,    // Unknown architecture
    paX64,        // X64 (AMD or Intel)
    paIA64,       // Intel Itanium processor family (IPF)
    paX86         // Intel 32 bit
  );

  ESysInfo = class(Exception);

  TOSInfo = class(TObject)
  private
    class function EditionFromProductInfo: string;
    class function CheckSuite(const Suite: Integer): Boolean;
    class function EditionFromReg: string;
    class function IsNT4SP6a: Boolean;
    class function ProductTypeFromReg: string;
  public
    class function IsWin9x: Boolean;
    class function IsWinNT: Boolean;
    class function IsWin32s: Boolean;
    class function IsWow64: Boolean;
    class function IsServer: Boolean;
    class function IsMediaCenter: Boolean;
    class function IsTabletPC: Boolean;
    class function IsRemoteSession: Boolean;
    class function IsWinVista: Boolean;
    class function IsWinServer2008: Boolean;
    class function IsWinServer2008R2: Boolean;
    class function IsWin7: Boolean;
    class function HasPenExtensions: Boolean;
    class function Platform: TOSPlatform;
    class function Product: TOSProduct;
    class function ProductName: string;
    class function MajorVersion: Integer;
    class function MinorVersion: Integer;
    class function BuildNumber: Integer;
    class function ServicePackString: string;
    class function ServicePackMajor: Integer;
    class function ServicePackMinor: Integer;
    class function EditionString: string;
    class function Description: string;
    class function ProductID: string;
    class function GetTrueWindowsVersion: TOSProduct;
  end;

var
  Win32HaveExInfo: Boolean = False;
  Win32ServicePackMajor: Integer = 0;
  Win32ServicePackMinor: Integer = 0;
  Win32SuiteMask: Integer = 0;
  Win32ProductType: Integer = 0;
  Win32HaveProductInfo: Boolean = False;
  Win32ProductInfo: LongWord = 0;

implementation

uses
  Registry;

resourcestring

  sUnknownPlatform  = 'Unrecognized operating system platform';
  sUnknownProduct   = 'Unrecognised operating system product';
  sBadRegType       =  'Unsupported registry type';
  sBadProcHandle    = 'Bad process handle';

type

  _OSVERSIONINFOEXA = packed record
    dwOSVersionInfoSize: DWORD;               // size of structure
    dwMajorVersion: DWORD;                    // major OS version number
    dwMinorVersion: DWORD;                    // minor OS version number
    dwBuildNumber: DWORD;                     // OS build number
    dwPlatformId: DWORD;                      // OS platform identifier
    szCSDVersion: array[0..127] of AnsiChar;  // service pack or extra info
    wServicePackMajor: WORD;                  // service pack major version no.
    wServicePackMinor: WORD;                  // service pack minor version no.
    wSuiteMask: WORD;                         // bitmask that stores OS suite(s)
    wProductType: Byte;                       // additional info about system
    wReserved: Byte;                          // reserved for future use
  end;
  OSVERSIONINFOEXA = _OSVERSIONINFOEXA;
  TOSVersionInfoExA = _OSVERSIONINFOEXA;
  POSVersionInfoExA = ^TOSVersionInfoExA;

  _OSVERSIONINFOEXW = packed record
    dwOSVersionInfoSize: DWORD;               // size of structure
    dwMajorVersion: DWORD;                    // major OS version number
    dwMinorVersion: DWORD;                    // minor OS version number
    dwBuildNumber: DWORD;                     // OS build number
    dwPlatformId: DWORD;                      // OS platform identifier
    szCSDVersion: array[0..127] of WideChar;  // service pack or extra info
    wServicePackMajor: WORD;                  // service pack major version no.
    wServicePackMinor: WORD;                  // service pack minor version no.
    wSuiteMask: WORD;                         // bitmask that stores OS suite(s)
    wProductType: Byte;                       // additional info about system
    wReserved: Byte;                          // reserved for future use
  end;
  OSVERSIONINFOEXW = _OSVERSIONINFOEXW;
  TOSVersionInfoExW = _OSVERSIONINFOEXW;
  POSVersionInfoExW = ^TOSVersionInfoExW;

  {$IFDEF UNICODE}
  _OSVERSIONINFOEX = _OSVERSIONINFOEXW;
  OSVERSIONINFOEX = OSVERSIONINFOEXW;
  TOSVersionInfoEx = TOSVersionInfoExW;
  POSVersionInfoEx = POSVersionInfoExW;
  {$ELSE}
  _OSVERSIONINFOEX = _OSVERSIONINFOEXA;
  OSVERSIONINFOEX = OSVERSIONINFOEXA;
  TOSVersionInfoEx = TOSVersionInfoExA;
  POSVersionInfoEx = POSVersionInfoExA;
  {$ENDIF}

const

  VER_NT_WORKSTATION                        = 1;
  VER_NT_DOMAIN_CONTROLLER                  = 2;
  VER_NT_SERVER                             = 3;

  VER_SUITE_SMALLBUSINESS                   = $00000001;
  VER_SUITE_ENTERPRISE                      = $00000002;
  VER_SUITE_BACKOFFICE                      = $00000004;
  VER_SUITE_COMMUNICATIONS                  = $00000008;
  VER_SUITE_TERMINAL                        = $00000010;
  VER_SUITE_SMALLBUSINESS_RESTRICTED        = $00000020;
  VER_SUITE_EMBEDDEDNT                      = $00000040;
  VER_SUITE_DATACENTER                      = $00000080;
  VER_SUITE_SINGLEUSERTS                    = $00000100;
  VER_SUITE_PERSONAL                        = $00000200;
  VER_SUITE_SERVERAPPLIANCE                 = $00000400;
  VER_SUITE_BLADE                           = VER_SUITE_SERVERAPPLIANCE;
  VER_SUITE_EMBEDDED_RESTRICTED             = $00000800;
  VER_SUITE_SECURITY_APPLIANCE              = $00001000;
  VER_SUITE_STORAGE_SERVER                  = $00002000;
  VER_SUITE_COMPUTE_SERVER                  = $00004000;
  VER_SUITE_WH_SERVER                       = $00008000;

  PRODUCT_BUSINESS                          = $00000006;
  PRODUCT_BUSINESS_N                        = $00000010;
  PRODUCT_CLUSTER_SERVER                    = $00000012;
  PRODUCT_DATACENTER_SERVER                 = $00000008;
  PRODUCT_DATACENTER_SERVER_CORE            = $0000000C;
  PRODUCT_DATACENTER_SERVER_CORE_V          = $00000027;
  PRODUCT_DATACENTER_SERVER_V               = $00000025;
  PRODUCT_ENTERPRISE                        = $00000004;
  PRODUCT_ENTERPRISE_E                      = $00000046;  
  PRODUCT_ENTERPRISE_N                      = $0000001B;
  PRODUCT_ENTERPRISE_SERVER                 = $0000000A;
  PRODUCT_ENTERPRISE_SERVER_CORE            = $0000000E;
  PRODUCT_ENTERPRISE_SERVER_CORE_V          = $00000029;
  PRODUCT_ENTERPRISE_SERVER_IA64            = $0000000F;
  PRODUCT_ENTERPRISE_SERVER_V               = $00000026;
  PRODUCT_HOME_BASIC                        = $00000002;
  PRODUCT_HOME_BASIC_E                      = $00000043;
  PRODUCT_HOME_BASIC_N                      = $00000005;
  PRODUCT_HOME_PREMIUM                      = $00000003;
  PRODUCT_HOME_PREMIUM_E                    = $00000044;
  PRODUCT_HOME_PREMIUM_N                    = $0000001A;
  PRODUCT_HOME_SERVER                       = $00000013;
  PRODUCT_HYPERV                            = $0000002A;
  PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT  = $0000001E;
  PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING   = $00000020;
  PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY    = $0000001F;
  PRODUCT_PROFESSIONAL                      = $00000030;
  PRODUCT_PROFESSIONAL_E                    = $00000045;
  PRODUCT_PROFESSIONAL_N                    = $00000031;
  PRODUCT_SERVER_FOR_SMALLBUSINESS          = $00000018;
  PRODUCT_SERVER_FOR_SMALLBUSINESS_V        = $00000023;
  PRODUCT_SERVER_FOUNDATION                 = $00000021;
  PRODUCT_SMALLBUSINESS_SERVER              = $00000009;
  PRODUCT_SMALLBUSINESS_SERVER_PREMIUM      = $00000019;
  PRODUCT_STANDARD_SERVER                   = $00000007;
  PRODUCT_STANDARD_SERVER_CORE              = $0000000D;
  PRODUCT_STANDARD_SERVER_CORE_V            = $00000028;
  PRODUCT_STANDARD_SERVER_V                 = $00000024;
  PRODUCT_STARTER                           = $0000000B;
  PRODUCT_STARTER_E                         = $00000042;
  PRODUCT_STARTER_N                         = $0000002F;
  PRODUCT_STORAGE_ENTERPRISE_SERVER         = $00000017;
  PRODUCT_STORAGE_EXPRESS_SERVER            = $00000014;
  PRODUCT_STORAGE_STANDARD_SERVER           = $00000015;
  PRODUCT_STORAGE_WORKGROUP_SERVER          = $00000016;
  PRODUCT_UNDEFINED                         = $00000000;
  PRODUCT_ULTIMATE                          = $00000001;
  PRODUCT_ULTIMATE_E                        = $00000047;
  PRODUCT_ULTIMATE_N                        = $0000001C;
  PRODUCT_WEB_SERVER                        = $00000011;
  PRODUCT_WEB_SERVER_CORE                   = $0000001D;
  PRODUCT_UNLICENSED                        = $ABCDABCD;
  
  SM_TABLETPC     = 86;   // Windows XP Tablet Edition
  SM_MEDIACENTER  = 87;   // Windows XP Media Center Edition
  SM_STARTER      = 88;   // Windows XP Starter Edition or Windows Vista Starter Edition
  SM_SERVERR2     = 89;   // Windows Server 2003 R2
  SM_REMOTESESSION  = $1000;  // Detects a remote terminal server session

  PROCESSOR_ARCHITECTURE_INTEL          = 0; // x86 *
  PROCESSOR_ARCHITECTURE_IA64           = 6; // Intel Itanium Processor Family *
  PROCESSOR_ARCHITECTURE_AMD64          = 9; // x64 (AMD or Intel) *
    
const

  cProductMap: array[1..52] of record
    Id: Cardinal; // product ID
    Name: string; // product name
  end = (
    (Id: PRODUCT_BUSINESS;
      Name: 'Business Edition';),
    (Id: PRODUCT_BUSINESS_N;
      Name: 'Business N Edition';),
    (Id: PRODUCT_CLUSTER_SERVER;
      Name: 'Cluster Server Edition';),
    (Id: PRODUCT_DATACENTER_SERVER;
      Name: 'Server Datacenter Edition (full installation)';),
    (Id: PRODUCT_DATACENTER_SERVER_CORE;
      Name: 'Server Datacenter Edition (core installation)';),
    (Id: PRODUCT_DATACENTER_SERVER_CORE_V;
      Name: 'Server Datacenter Edition without Hyper-V (core installation)';),
    (Id: PRODUCT_DATACENTER_SERVER_V;
      Name: 'Server Datacenter Edition without Hyper-V (full installation)';),
    (Id: PRODUCT_ENTERPRISE;
      Name: 'Enterprise Edition';),
    (Id: PRODUCT_ENTERPRISE_E;
      Name: 'Enterprise E Edition';),
    (Id: PRODUCT_ENTERPRISE_N;
      Name: 'Enterprise N Edition';),
    (Id: PRODUCT_ENTERPRISE_SERVER;
      Name: 'Server Enterprise Edition (full installation)';),
    (Id: PRODUCT_ENTERPRISE_SERVER_CORE;
      Name: 'Server Enterprise Edition (core installation)';),
    (Id: PRODUCT_ENTERPRISE_SERVER_CORE_V;
      Name: 'Server Enterprise Edition without Hyper-V (core installation)';),
    (Id: PRODUCT_ENTERPRISE_SERVER_IA64;
      Name: 'Server Enterprise Edition for Itanium-based Systems';),
    (Id: PRODUCT_ENTERPRISE_SERVER_V;
      Name: 'Server Enterprise Edition without Hyper-V (full installation)';),
    (Id: PRODUCT_HOME_BASIC;
      Name: 'Home Basic Edition';),
    (Id: PRODUCT_HOME_BASIC_E;
      Name: 'Home Basic E Edition';),
    (Id: PRODUCT_HOME_BASIC_N;
      Name: 'Home Basic N Edition';),
    (Id: PRODUCT_HOME_PREMIUM;
      Name: 'Home Premium Edition';),
    (Id: PRODUCT_HOME_PREMIUM_E;
      Name: 'Home Premium E Edition';),
    (Id: PRODUCT_HOME_PREMIUM_N;
      Name: 'Home Premium N Edition';),
    (Id: PRODUCT_HOME_SERVER;
      Name: 'Home Server Edition';),
    (Id: PRODUCT_HYPERV;
      Name: 'Microsoft Hyper-V Server'),
    (Id: PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT;
      Name: 'Windows Essential Business Server Management Server';),
    (Id: PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING;
      Name: 'Windows Essential Business Server Messaging Server';),
    (Id: PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY;
      Name: 'Windows Essential Business Server Security Server';),
    (Id: PRODUCT_PROFESSIONAL;
      Name: 'Professional Edition';),
    (Id: PRODUCT_PROFESSIONAL_E;
      Name: 'Professional E Edition';),
    (Id: PRODUCT_PROFESSIONAL_N;
      Name: 'Professional N Edition';),
    (Id: PRODUCT_SERVER_FOR_SMALLBUSINESS;
      Name: 'Server for Small Business Edition';),
    (Id: PRODUCT_SERVER_FOR_SMALLBUSINESS_V;
      Name: 'Windows Server 2008 without Hyper-V for Windows Essential Server '
        + 'Solutions';),
    (Id: PRODUCT_SERVER_FOUNDATION;
      Name: 'Server Foundation';),
    (Id: PRODUCT_SMALLBUSINESS_SERVER;
      Name: 'Small Business Server';),
    (Id: PRODUCT_SMALLBUSINESS_SERVER_PREMIUM;
      Name: 'Small Business Server Premium Edition';),
    (Id: PRODUCT_STANDARD_SERVER;
      Name: 'Server Standard Edition (full installation)';),
    (Id: PRODUCT_STANDARD_SERVER_CORE;
      Name: 'Server Standard Edition (core installation)';),
    (Id: PRODUCT_STANDARD_SERVER_CORE_V;
      Name: 'Server Standard Edition without Hyper-V (core installation)';),
    (Id: PRODUCT_STANDARD_SERVER_V;
      Name: 'Server Standard Edition without Hyper-V (full installation)';),
    (Id: PRODUCT_STARTER;
      Name: 'Starter Edition';),
    (Id: PRODUCT_STARTER_E;
      Name: 'Starter E Edition';),
    (Id: PRODUCT_STARTER_N;
      Name: 'Starter N Edition';),
    (Id: PRODUCT_STORAGE_ENTERPRISE_SERVER;
      Name: 'Storage Server Enterprise Edition';),
    (Id: PRODUCT_STORAGE_EXPRESS_SERVER;
      Name: 'Storage Server Express Edition';),
    (Id: PRODUCT_STORAGE_STANDARD_SERVER;
      Name: 'Storage Server Standard Edition';),
    (Id: PRODUCT_STORAGE_WORKGROUP_SERVER;
      Name: 'Storage Server Workgroup Edition';),
    (Id: PRODUCT_UNDEFINED;
      Name: 'An unknown product';),
    (Id: PRODUCT_ULTIMATE;
      Name: 'Ultimate Edition';),
    (Id: PRODUCT_ULTIMATE_E;
      Name: 'Ultimate E Edition';),
    (Id: PRODUCT_ULTIMATE_N;
      Name: 'Ultimate N Edition';),
    (Id: PRODUCT_WEB_SERVER;
      Name: 'Web Server Edition';),
    (Id: PRODUCT_WEB_SERVER_CORE;
      Name: 'Web Server Edition (core installation)';),
    (Id: Cardinal(PRODUCT_UNLICENSED);
      Name: 'Unlicensed product';)
  );

var
  pvtProcessorArchitecture: Word = 0;

//------------------------------------------------------------------------------

function LoadKernelFunc(const FuncName: string): Pointer;
const
  cKernel = 'kernel32.dll';
begin
  Result := GetProcAddress(GetModuleHandle(cKernel), PChar(FuncName));
end;

//------------------------------------------------------------------------------

procedure InitPlatformIdEx;
type
  TGetProductInfo = function(OSMajor, OSMinor, SPMajor, SPMinor: DWORD;
                             out ProductType: DWORD): BOOL; stdcall;
  TGetSystemInfo = procedure(var lpSystemInfo: TSystemInfo); stdcall;
var
  OSVI: TOSVersionInfoEx;
  POSVI: POSVersionInfo;
  GetProductInfo: TGetProductInfo;
  GetSystemInfoFn: TGetSystemInfo;
  SI: TSystemInfo;                  
begin
  FillChar(OSVI, SizeOf(OSVI), 0);
  POSVI := @OSVI;
  OSVI.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
  Win32HaveExInfo := GetVersionEx(POSVI^);
  if Win32HaveExInfo then
  begin
    Win32ServicePackMajor := OSVI.wServicePackMajor;
    Win32ServicePackMinor := OSVI.wServicePackMinor;
    Win32SuiteMask := OSVI.wSuiteMask;
    Win32ProductType := OSVI.wProductType;
    GetProductInfo := LoadKernelFunc('GetProductInfo');
    Win32HaveProductInfo := Assigned(GetProductInfo);
    if Win32HaveProductInfo then
    begin
      if not GetProductInfo(Win32MajorVersion, Win32MinorVersion,
                            Win32ServicePackMajor, Win32ServicePackMinor,
                            Win32ProductInfo) then
        Win32ProductInfo := PRODUCT_UNDEFINED;
    end;
  end;
  GetSystemInfoFn := LoadKernelFunc('GetNativeSystemInfo');
  if not Assigned(GetSystemInfoFn) then
    GetSystemInfoFn := Windows.GetSystemInfo;
  GetSystemInfoFn(SI);
  pvtProcessorArchitecture := SI.wProcessorArchitecture;
end;

//------------------------------------------------------------------------------

function GetRegistryString(const RootKey: HKEY; const SubKey, Name: string): string;
var
  Reg: TRegistry;
  ValueInfo: TRegDataInfo; 
begin
  Result := '';
  Reg := TRegistry.Create;
  try
    Reg.RootKey := RootKey;
    if Reg.OpenKey(SubKey, false) and Reg.ValueExists(Name) then
      begin
        Reg.GetDataInfo(Name, ValueInfo);
        case ValueInfo.RegData of
          rdString, rdExpandString:
            Result := Reg.ReadString(Name);
          rdInteger:
            Result := IntToStr(Reg.ReadInteger(Name));
          else
            raise ESysInfo.Create(sBadRegType);
        end;
      end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

//------------------------------------------------------------------------------

function GetCurrentVersionRegStr(ValName: string): string;
const
  cWdwCurrentVer = '\Software\Microsoft\Windows\CurrentVersion';
begin
  Result := GetRegistryString(
    Windows.HKEY_LOCAL_MACHINE, cWdwCurrentVer, ValName
  );
end;

//------------------------------------------------------------------------------

class function TOSInfo.BuildNumber: Integer;
begin
  Result := Win32BuildNumber;
end;

//------------------------------------------------------------------------------

class function TOSInfo.CheckSuite(const Suite: Integer): Boolean;
begin
  Result := Win32SuiteMask and Suite <> 0;
end;

//------------------------------------------------------------------------------

class function TOSInfo.Description: string;

  procedure AppendToResult(const Str: string);
  begin
    if Str <> '' then
      Result := Result + ' ' + Str;
  end;

begin
  Result := ProductName;
  case Platform of
    ospWinNT:
    begin
      if Product = osWinNT then
      begin
        AppendToResult(Format('%d.%d', [MajorVersion, MinorVersion]));
        AppendToResult(EditionString);
        AppendToResult(ServicePackString);
        AppendToResult(Format('(Build %d)', [BuildNumber]));
      end
      else
      begin
        AppendToResult(EditionString);
        AppendToResult(ServicePackString);
        AppendToResult(Format('(Build %d)', [BuildNumber]));
      end;
    end;
    ospWin9x:
      AppendToResult(ServicePackString);
  end;
end;

//------------------------------------------------------------------------------

class function TOSInfo.EditionString: string;
begin
  Result := '';
  case Product of
    osWinVista, osWinSvr2008, osWin7, osWinSvr2008R2:
      begin
        Result := EditionFromProductInfo;
        if pvtProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64 then
          Result := Result + ' (64-bit)';
      end;
    osWinSvr2003, osWinSvr2003R2:
      begin
        if pvtProcessorArchitecture = PROCESSOR_ARCHITECTURE_IA64 then
          begin
            if CheckSuite(VER_SUITE_DATACENTER) then
              Result := 'Datacenter Edition for Itanium-based Systems'
            else if CheckSuite(VER_SUITE_ENTERPRISE) then
              Result := 'Enterprise Edition for Itanium-based Systems';
          end
        else if (pvtProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) then
          begin
            if CheckSuite(VER_SUITE_DATACENTER) then
              Result := 'Datacenter x64 Edition'
            else if CheckSuite(VER_SUITE_ENTERPRISE) then
              Result := 'Enterprise x64 Edition'
            else
              Result := 'Standard x64 Edition';
          end
        else
          begin
            if CheckSuite(VER_SUITE_COMPUTE_SERVER) then
              Result := 'Compute Cluster Edition'
            else if CheckSuite(VER_SUITE_DATACENTER) then
              Result := 'Datacenter Edition'
            else if CheckSuite(VER_SUITE_BLADE) then
              Result := 'Web Edition'
            else if CheckSuite(VER_SUITE_STORAGE_SERVER) then
              Result := 'Storage Server'
            else if CheckSuite(VER_SUITE_ENTERPRISE) then
              Result := 'Enterprise Edition'
            else if CheckSuite(VER_SUITE_SMALLBUSINESS) and
              CheckSuite(VER_SUITE_SMALLBUSINESS_RESTRICTED) then
              Result := 'Small Business Edition'
            else
              Result := 'Standard Edition';
          end;
      end;
    osWinXP:
      begin
        if GetSystemMetrics(SM_STARTER) <> 0 then
          Result := 'Starter Edition'
        else if GetSystemMetrics(SM_TABLETPC) <> 0 then
          Result := 'Tablet PC Edition'
        else if CheckSuite(VER_SUITE_EMBEDDEDNT) then
          Result := 'Embedded'
        else if (Win32MajorVersion = 5) and (Win32MinorVersion = 2) and
             not IsServer and
          (pvtProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) then
          Result := 'Professional x64 Edition'
        else if CheckSuite(VER_SUITE_PERSONAL) then
          Result := 'Home Edition'
        else
          Result := 'Professional';
      end;
    osWin2K:
      begin
        if IsServer then
          begin
            if CheckSuite(VER_SUITE_DATACENTER) then
              Result := 'Datacenter Server'
            else if CheckSuite(VER_SUITE_ENTERPRISE) then
              Result := 'Advanced Server'
            else
              Result := 'Server';
          end
        else
          Result := 'Professional';
      end;
    osWinNT:
      begin
        if Win32HaveExInfo then
          begin
            if IsServer then
              begin
                if CheckSuite(VER_SUITE_ENTERPRISE) then
                  Result := 'Enterprise Edition'
                else
                  Result := 'Server';
              end
            else
              Result := 'Workstation'
          end
        else
          Result := EditionFromReg;
      end;
  end;
end;

//------------------------------------------------------------------------------

class function TOSInfo.EditionFromProductInfo: string;
var
  Idx: Integer;
begin
  Result := '';
  for Idx := Low(cProductMap) to High(cProductMap) do
  begin
    if cProductMap[Idx].Id = Win32ProductInfo then
      begin
        Result := cProductMap[Idx].Name;
        Break;
      end;
  end;
end;

//------------------------------------------------------------------------------

class function TOSInfo.EditionFromReg: string;
var
  EditionCode: string;  
begin
  EditionCode := ProductTypeFromReg;
  if CompareText(EditionCode, 'WINNT') = 0 then
    Result := 'WorkStation'
  else if CompareText(EditionCode, 'LANMANNT') = 0 then
    Result := 'Server'
  else if CompareText(EditionCode, 'SERVERNT') = 0 then
    Result := 'Advanced Server';
  Result := Result + Format(
    ' %d.%d', [Win32MajorVersion, Win32MinorVersion]
  );
end;

//------------------------------------------------------------------------------

class function TOSInfo.HasPenExtensions: Boolean;
begin
  Result := GetSystemMetrics(SM_PENWINDOWS) <> 0;
end;

//------------------------------------------------------------------------------

class function TOSInfo.IsMediaCenter: Boolean;
begin
  Result := GetSystemMetrics(SM_MEDIACENTER) <> 0;
end;

//------------------------------------------------------------------------------


class function TOSInfo.IsRemoteSession: Boolean;
begin
  Result := GetSystemMetrics(SM_REMOTESESSION) <> 0;
end;

//------------------------------------------------------------------------------

class function TOSInfo.IsNT4SP6a: Boolean;
var
  Reg: TRegistry;
begin
  if (Product = osWinNT)  and (Win32MajorVersion = 4) and
     (CompareText(Win32CSDVersion, 'Service Pack 6') = 0) then
  begin
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Result := Reg.KeyExists('SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\Q246009');
    finally
      Reg.Free;
    end;
  end
  else
    Result := False;
end;

//------------------------------------------------------------------------------

class function TOSInfo.IsServer: Boolean;
begin
  if Win32HaveExInfo then
    Result := Win32ProductType <> VER_NT_WORKSTATION
  else
    Result := CompareText(ProductTypeFromReg, 'WINNT') <> 0;;
end;

//------------------------------------------------------------------------------

class function TOSInfo.IsTabletPC: Boolean;
begin
  Result := GetSystemMetrics(SM_TABLETPC) <> 0;
end;

//------------------------------------------------------------------------------

class function TOSInfo.IsWin32s: Boolean;
begin
  Result := Platform = ospWin32s;
end;

//------------------------------------------------------------------------------

class function TOSInfo.IsWin9x: Boolean;
begin
  Result := Platform = ospWin9x;
end;

//------------------------------------------------------------------------------

class function TOSInfo.IsWinNT: Boolean;
begin
  Result := Platform = ospWinNT;
end;

//------------------------------------------------------------------------------

class function TOSInfo.IsWinVista: Boolean;
begin
  Result := Product = osWinVista;
end;

//------------------------------------------------------------------------------

class function TOSInfo.IsWinServer2008: Boolean;
begin
  Result := Product = osWinSvr2008;
end;

//------------------------------------------------------------------------------

class function TOSInfo.IsWinServer2008R2: Boolean;
begin
  Result := Product = osWinSvr2008R2;
end;

//------------------------------------------------------------------------------

class function TOSInfo.IsWin7: Boolean;
begin
  Result := Product = osWin7;
end;

//------------------------------------------------------------------------------

class function TOSInfo.IsWow64: Boolean;
type
  TIsWow64Process = function(Handle: THandle; var Res: BOOL): BOOL; stdcall;
var
  IsWow64Result: BOOL;
  IsWow64Process: TIsWow64Process;
begin
  IsWow64Process := LoadKernelFunc('IsWow64Process');
  if Assigned(IsWow64Process) then
  begin
    if not IsWow64Process(GetCurrentProcess, IsWow64Result) then
      raise Exception.Create(sBadProcHandle);
    Result := IsWow64Result;
  end
  else
    Result := False;
end;

//------------------------------------------------------------------------------

class function TOSInfo.MajorVersion: Integer;
begin
  Result := Win32MajorVersion;
end;

//------------------------------------------------------------------------------

class function TOSInfo.MinorVersion: Integer;
begin
  Result := Win32MinorVersion;
end;

//------------------------------------------------------------------------------

class function TOSInfo.Platform: TOSPlatform;
begin
  case Win32Platform of
    VER_PLATFORM_WIN32_NT: Result := ospWinNT;
    VER_PLATFORM_WIN32_WINDOWS: Result := ospWin9x;
    VER_PLATFORM_WIN32s: Result := ospWin32s;
    else raise ESysInfo.Create(sUnknownPlatform);
  end;
end;

//------------------------------------------------------------------------------

class function TOSInfo.Product: TOSProduct;
begin
  Result := osUnknown;
  case Platform of
    ospWin9x:
    begin
      // Win 9x platform: only major version is 4
      Result := osUnknownWin9x;
      case Win32MajorVersion of
        4:
        begin
          case Win32MinorVersion of
            0: Result := osWin95;
            10: Result := osWin98;
            90: Result := osWinMe;
          end;
        end;
      end;
    end;
    ospWinNT:
    begin
      // NT platform OS
      Result := osUnknownWinNT;
      case Win32MajorVersion of
        3, 4:
        begin
          // NT 3 or 4
          case Win32MinorVersion of
            0: Result := osWinNT;
          end;
        end;
        5:
        begin
          // Windows 2000 or XP
          case Win32MinorVersion of
            0:
              Result := osWin2K;
            1:
              Result := osWinXP;
            2:
            begin
              if GetSystemMetrics(SM_SERVERR2) <> 0 then
                Result := osWinSvr2003R2
              else
              begin
                if not IsServer and
                  (pvtProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) then
                  Result := osWinXP // XP Pro X64
                else
                  Result := osWinSvr2003
              end
            end;
          end;
        end;
        6:
        begin
          case Win32MinorVersion of
            0:
              if not IsServer then
                Result := osWinVista
              else
                Result := osWinSvr2008;
            1:
              if not IsServer then
                Result := osWin7
              else
                Result := osWinSvr2008R2;
            else
              // Higher minor version: must be an unknown later OS
              Result := osWinLater
          end;
        end;
        else
          // Higher major version: must be an unknown later OS
          Result := osWinLater;
      end;
    end;
    ospWin32s:
      // Windows 32s: probably won't ever get this
      Result := osUnknownWin32s;
  end;
end;

//------------------------------------------------------------------------------

class function TOSInfo.ProductID: string;
const
  cRegKey: array[Boolean] of string = (
    'Software\Microsoft\Windows\CurrentVersion',
    'Software\Microsoft\Windows NT\CurrentVersion'
  );
begin
  Result := GetRegistryString(
    HKEY_LOCAL_MACHINE, cRegKey[IsWinNT], 'ProductID'
  );
end;

//------------------------------------------------------------------------------

class function TOSInfo.ProductName: string;
begin
  case Product of
    osUnknownWinNT, osUnknownWin9x, osUnknownWin32s: Result := '';
    osWinNT: Result := 'Windows NT';
    osWin2K: Result := 'Windows 2000';
    osWinXP: Result := 'Windows XP';
    osWinVista: Result := 'Windows Vista';
    osWinSvr2008: Result := 'Windows Server 2008';
    osWin95: Result := 'Windows 95';
    osWin98: Result := 'Windows 98';
    osWinMe: Result := 'Windows Me';
    osWinSvr2003: Result := 'Windows Server 2003';
    osWinSvr2003R2: Result := 'Windows Server 2003 R2';
    osWinLater: Result := Format(
      'Windows Version %d.%d', [Win32MajorVersion, Win32MinorVersion]
    );
    osWin7: Result := 'Windows 7';
    osWinSvr2008R2: Result := 'Windows Server 2008 R2';
    else
      raise ESysInfo.Create(sUnknownProduct);
  end;
end;

//------------------------------------------------------------------------------

class function TOSInfo.ProductTypeFromReg: string;
begin
  Result := GetRegistryString(
    HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\ProductOptions',
    'ProductType'
  );
end;

//------------------------------------------------------------------------------

class function TOSInfo.ServicePackString: string;
begin
  Result := '';
  case Platform of
    ospWin9x:
      if Win32CSDVersion <> '' then
      begin
        case Product of
          osWin95:
            {$IFDEF UNICODE}
            if CharInSet(Win32CSDVersion[1], ['B', 'b', 'C', 'c']) then
            {$ELSE}
            if Win32CSDVersion[1] in ['B', 'b', 'C', 'c'] then
            {$ENDIF}
              Result := 'OSR2';
          osWin98:
            {$IFDEF UNICODE}
            if CharInSet(Win32CSDVersion[1], ['A', 'a']) then
            {$ELSE}
            if Win32CSDVersion[1] in ['A', 'a'] then
            {$ENDIF}
              Result := 'SE';
        end;
      end;
    ospWinNT:
      if IsNT4SP6a then
        Result := 'Service Pack 6a' 
      else
        Result := Win32CSDVersion;
  end;
end;

//------------------------------------------------------------------------------

class function TOSInfo.ServicePackMajor: Integer;
begin
  Result := Win32ServicePackMajor;
end;

//------------------------------------------------------------------------------

class function TOSInfo.ServicePackMinor: Integer;
begin
  Result := Win32ServicePackMinor;
end;

//------------------------------------------------------------------------------

class function TOSInfo.GetTrueWindowsVersion: TOSProduct;

  function ExportsAPI(const apiName: string): boolean;
  begin
    Result := LoadKernelFunc(apiName) <> nil;
  end;
  
begin
  if ExportsAPI('GetLocaleInfoEx') then
    Result := osWinVista
  else if ExportsAPI('GetLargePageMinimum') then
    Result := osWinSvr2003
  else if ExportsAPI('GetNativeSystemInfo') then
    Result := osWinXP
  else if ExportsAPI('ReplaceFile') then
    Result := osWin2K
  else if ExportsAPI('OpenThread') then
    Result := osWinMe
  else if ExportsAPI('GetThreadPriorityBoost') then
    Result := osWinNT
  else if ExportsAPI('IsDebuggerPresent') then
    Result := osWin98
  else if ExportsAPI('Beep') then
    Result := osWin95
  else
    Result := OsUnknown;
end;

//------------------------------------------------------------------------------

initialization

  InitPlatformIdEx;

end.
