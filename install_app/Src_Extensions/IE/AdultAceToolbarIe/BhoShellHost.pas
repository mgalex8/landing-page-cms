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
{ The Original Code is BhoShellHost.pas.                               }
{                                                                      }
{ The Initial Developer of the Original Code is Ashley Godfrey, all    }
{ Portions created by these individuals are Copyright (C) of Ashley    }
{ Godfrey.                                                             }
{                                                                      }
{**********************************************************************}
{                                                                      }
{ This unit contains code to identify whether the application hosting  }
{ a browser helper object (BHO) is Internet Explorer or Windows        }
{ Explorer.                                                            }
{                                                                      }
{ Unit owner: Ashley Godfrey.                                          }
{ Last modified: April 6, 2004.                                        }
{ Updates available from http://www.evocorp.com                        }
{                                                                      }
{**********************************************************************}

unit BhoShellHost;

interface

type
  TShellType = (stInternetExplorer, stUnknown, stWindowsExplorer);

const
  // We treat ShellType as a constant as it's only ever initialized
  // once and never written to again. However to initialize ShellType
  // (as a constant) we need to have "Assignable Typed Constants"
  // turned on.
  {$WRITEABLECONST ON}
  ShellType: TShellType = stUnknown;

implementation
uses
  SysUtils, Windows;

procedure InitialiseShellType;
var ModuleName: array [0..MAX_PATH] of char;
    FileName: string;
begin
  FillChar(ModuleName, MAX_PATH, 0);
  GetModuleFileName(0, pChar(@ModuleName), MAX_PATH);
  FileName := ExtractFileName(pChar(@ModuleName));

  if CompareText(FileName, 'iexplore.exe') = 0 then
    ShellType := stInternetExplorer
  else if CompareText(FileName, 'explorer.exe') = 0 then
    ShellType := stWindowsExplorer;
end;

initialization
  InitialiseShellType;

end.
