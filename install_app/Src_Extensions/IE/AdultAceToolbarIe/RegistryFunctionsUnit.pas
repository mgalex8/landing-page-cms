unit RegistryFunctionsUnit;

interface

uses
   Windows, Classes, Registry, StdCtrls, SysUtils;

   function StrToHKEY(const KEY: string): HKEY;
   function WriteVariable(NameKey: String; NameVarible: String; ValueVarible: String): Boolean;
   function WriteVariableDword(NameKey: String; NameVarible: String; ValueVarible: Integer): Boolean;
   function ReadVariable(NameKey: String; NameVarible: String; Var ValueVarible: String): Boolean;
   function ReadVariableDword(NameKey: String; NameVarible: String; Var ValueVarible: Integer): Boolean;
   function DeleteKeyVariable(NameKey: String): Boolean;
   function DeleteVariable(NameKey: String; NameVarible: String): Boolean;
   Function RegKeyGetValueNames(nameKey: String; List: TStringList): Boolean;
implementation

const
   HKEYNames: array[0..6] of string = ('HKEY_CLASSES_ROOT', 'HKEY_CURRENT_USER', 'HKEY_LOCAL_MACHINE', 'HKEY_USERS', 'HKEY_PERFORMANCE_DATA', 'HKEY_CURRENT_CONFIG', 'HKEY_DYN_DATA');
   RootRegKey = 'HKEY_LOCAL_MACHINE';
Function RegKeyGetValueNames(nameKey: String; List: TStringList): Boolean;
var
   Reg: TRegistry;
   countItems: Word;
   begin
   Reg := TRegistry.Create;
   Reg.RootKey := HKEY_LOCAL_MACHINE;
   RegKeyGetValueNames := False;
   List.Clear;
   try
      Reg.OpenKey(nameKey, False);
      Reg.GetValueNames(List);
      if List.Count > 0 then
         RegKeyGetValueNames := True;
  finally
     //
  end;
  Reg.CloseKey;
  Reg.Destroy;
end;

function StrToHKEY(const KEY: string): HKEY;
var
   i: Byte;
begin
   Result := $0;
   for i := Low(HKEYNames) to High(HKEYNames) do
      begin
         if SameText(HKEYNames[i], KEY) then
            Result := HKEY_CLASSES_ROOT + i;
      end;
end;

function WriteVariableDword(NameKey: String; NameVarible: String; ValueVarible: Integer): Boolean;
var
   Reg: TRegistry;
begin
   Reg := TRegistry.Create;
   Reg.RootKey := StrToHKEY(RootRegKey);
   WriteVariableDword := False;
   try
      Reg.OpenKey(NameKey, True);
      Reg.WriteInteger(NameVarible, ValueVarible);
      WriteVariableDword := True;
   except
      WriteVariableDword := False;
   end;
   Reg.CloseKey;
   Reg.Destroy;
end;

function WriteVariable(NameKey: String; NameVarible: String; ValueVarible: String): Boolean;
var
   Reg: TRegistry;
begin
   Reg := TRegistry.Create;
   Reg.RootKey := StrToHKEY(rootRegKey);
   WriteVariable := False;
   try
      Reg.OpenKey(NameKey, True);
      Reg.WriteString(NameVarible, ValueVarible);
      WriteVariable := True;
   except
      WriteVariable := False;
   end;
   Reg.CloseKey;
   Reg.Destroy;
end;

function ReadVariable(NameKey: String; NameVarible: String; Var ValueVarible: String): Boolean;
var
   Reg: TRegistry;
begin
   ValueVarible := '';
   Reg := TRegistry.Create;
   Reg.RootKey := StrToHKEY(rootRegKey);
   ReadVariable := False;
   try
      Reg.OpenKey(NameKey, False);
      ValueVarible := Reg.ReadString(NameVarible);
      ReadVariable := True;
   except
      ReadVariable := False;
   end;
   if ('' = ValueVarible) then
      ReadVariable := False;
   Reg.CloseKey;
   Reg.Destroy;
end;

function ReadVariableDword(NameKey: String; NameVarible: String; Var ValueVarible: Integer): Boolean;
var
   Reg: TRegistry;
begin
   ValueVarible := 0;
   Reg := TRegistry.Create;
   Reg.RootKey := StrToHKEY(rootRegKey);
   ReadVariableDword := False;
   try
      Reg.OpenKey(NameKey, False);
      ValueVarible := Reg.ReadInteger(NameVarible);
      ReadVariableDword := True;
   except
      ReadVariableDword := False;
   end;
   if (0 = ValueVarible) then
      ReadVariableDword := False;
   Reg.CloseKey;
   Reg.Destroy;
end;

function DeleteKeyVariable(NameKey: String): Boolean;
var
   Reg: TRegistry;
begin
   Reg := TRegistry.Create;
   Reg.RootKey := StrToHKEY(rootRegKey);
   DeleteKeyVariable := False;
   try
      Reg.DeleteKey(NameKey);
      DeleteKeyVariable := True;
   except
      DeleteKeyVariable := False;
   end;
   Reg.CloseKey;
   Reg.Destroy;
end;

function DeleteVariable(NameKey: String; NameVarible: String): Boolean;
var
   Reg: TRegistry;
begin
   Reg := TRegistry.Create;
   Reg.RootKey := StrToHKEY(rootRegKey);
   DeleteVariable := False;
   try
      Reg.OpenKey(NameKey, False);
      Reg.DeleteValue(NameVarible);
      DeleteVariable := True;
   except
      DeleteVariable := False;
   end;
   Reg.CloseKey;
   Reg.Destroy;
end;

end.
 