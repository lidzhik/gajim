; File encoding 'UTF-8 with BOM'

Unicode true
ManifestDPIAware true
!include "MUI2.nsh"
!include "LogicLib.nsh"

Name "Gajim"
OutFile "Gajim.exe"
SetCompressor /final /solid lzma
SetCompressorDictSize 32

!define myAppName "Gajim"

InstallDir "$PROGRAMFILES\Gajim"
InstallDirRegKey HKCU "Software\Gajim" ""
RequestExecutionLevel admin
BrandingText "Gajim Setup"

Var StartMenuFolder

!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\nsis3-install-alt.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\nsis3-uninstall.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "..\misc\nsis_header.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\misc\nsis_wizard.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "..\misc\nsis_wizard.bmp"
!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\Gajim"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;Show all languages, despite user's codepage
!define MUI_LANGDLL_ALLLANGUAGES

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_RESERVEFILE_LANGDLL

; English
LangString NAME_SecDesktopIcon ${LANG_ENGLISH} "Create icon on desktop"
LangString NAME_SecAutostart ${LANG_ENGLISH} "Start Gajim when Windows starts"
LangString NAME_SecURI ${LANG_ENGLISH} "Open xmpp links with Gajim"
LangString DESC_SecGajim ${LANG_ENGLISH} "Installs the main Gajim files."
LangString DESC_SecDesktopIcon ${LANG_ENGLISH} "Creates a shortcut for Gajim on your desktop."
LangString DESC_SecAutostart ${LANG_ENGLISH} "Starts Gajim automatically when starting Windows."
LangString DESC_SecURI ${LANG_ENGLISH} "Enables Gajim to open xmpp links (e.g. a group chat linked on a website)."

; Russian
LangString NAME_SecDesktopIcon ${LANG_RUSSIAN} "Создать ярлык на рабочем столе"
LangString NAME_SecAutostart ${LANG_RUSSIAN} "Запускать Gajim при загрузке Windows"
LangString NAME_SecURI ${LANG_RUSSIAN} "Открывать xmpp-ссылки в Gajim"
LangString DESC_SecGajim ${LANG_RUSSIAN} "Установка основных файлов Gajim."
LangString DESC_SecDesktopIcon ${LANG_RUSSIAN} "Если отмечено, на рабочем столе будет создан ярлык Gajim."
LangString DESC_SecAutostart ${LANG_RUSSIAN} "Если отмечено, Gajim будет автоматически запускаться при загрузке Windows."
LangString DESC_SecURI ${LANG_RUSSIAN} "Позволяет Gajim открывать xmpp-ссылки, например, адреса конференций на веб-странице."

Section "Gajim" SecGajim
	SectionIn RO

    Var /GLOBAL arch_name
    StrCpy $arch_name "(64-Bit)"
    StrCmp ${ARCH} "x86_64" continue
    StrCpy $arch_name "(32-Bit)"
    continue:

    ReadRegStr $R3 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Gajim" "UninstallString"
    ${If} ${FileExists} $R3
        ; If Gajim was installed before, run uninstaller (in silent mode)
        ExecWait '"$R3" /S _?=$INSTDIR'
    ${EndIf}

    SetOutPath "$INSTDIR"
    File /r "${PREFIX}\*.*"

    WriteRegStr HKCU "Software\Gajim" "" $INSTDIR
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Gajim" "DisplayName" "Gajim ${VERSION} $arch_name"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Gajim" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Gajim" "DisplayIcon" "$INSTDIR\bin\Gajim.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Gajim" "DisplayVersion" "${VERSION}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Gajim" "URLInfoAbout" "https://www.gajim.org/"
    WriteUninstaller "$INSTDIR\Uninstall.exe"

    SetOutPath "$INSTDIR\bin"
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        SetShellVarContext current
        CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Messenger.lnk" "$INSTDIR\bin\Gajim.exe"
        SetShellVarContext all
        CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Messenger.lnk" "$INSTDIR\bin\Gajim.exe"
    !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section $(NAME_SecDesktopIcon) SecDesktopIcon
    SetShellVarContext current
    SetOutPath "$INSTDIR\bin"
    CreateShortCut "$DESKTOP\Messenger.lnk" "$INSTDIR\bin\Gajim.exe"
SectionEnd

Section $(NAME_SecAutostart) SecAutostart
    SetShellVarContext current
    SetOutPath "$INSTDIR\bin"
    CreateShortCut "$SMSTARTUP\Messenger.lnk" "$INSTDIR\bin\Gajim.exe"
SectionEnd

Section $(NAME_SecURI) SecURI
    WriteRegStr HKCU "Software\Classes\xmpp" "" "URL:xmpp-uri"
    WriteRegStr HKCU "Software\Classes\xmpp" "URL Protocol" ""
    WriteRegStr HKCU "Software\Classes\xmpp\DefaultIcon" "" "$INSTDIR\bin\Gajim.exe,1"
    WriteRegStr HKCU "Software\Classes\xmpp\shell" "" "open"
    WriteRegStr HKCU "Software\Classes\xmpp\shell\open\" "FriendlyAppName" "${myAppName}"
    WriteRegStr HKCU "Software\Classes\xmpp\shell\open\command" "" '"$INSTDIR\bin\Gajim.exe" "%1"'
SectionEnd

Section "Uninstall"
    ; Hint: Gajim setup should not be named gajim.exe, else it will be killed here
    ExecWait "TaskKill /IM gdbus.exe /F"
    ExecWait "TaskKill /IM gajim.exe /F"
    ExecWait "TaskKill /IM gajim-debug.exe /F"

    RMDir /r "$INSTDIR"

    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder

    SetShellVarContext current
    Delete "$SMPROGRAMS\$StartMenuFolder\Messenger.lnk"
    RMDir "$SMPROGRAMS\$StartMenuFolder"
    Delete "$DESKTOP\Gajim.lnk"
    Delete "$SMSTARTUP\Gajim.lnk"
    SetShellVarContext all
    Delete "$SMPROGRAMS\$StartMenuFolder\Messenger.lnk"
    RMDir "$SMPROGRAMS\$StartMenuFolder"

    DeleteRegKey /ifempty HKCU "Software\Gajim"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Gajim"
SectionEnd

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecGajim} $(DESC_SecGajim)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktopIcon} $(DESC_SecDesktopIcon)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecAutostart} $(DESC_SecAutostart)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecURI} $(DESC_SecURI)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function .onInit
    BringToFront
    ; Check if already running
    ; If so don't open another but bring to front
    System::Call "kernel32::CreateMutexA(i 0, i 0, t '$(^Name)') i .r0 ?e"
    Pop $0
    StrCmp $0 0 StartInstall
    StrLen $0 "$(^Name)"
    IntOp $0 $0 + 1
    FindWindow $1 '#32770' '' 0 $1
    IntCmp $1 0 +3
    System::Call "user32::ShowWindow(i r1,i 9) i."         ; If minimized then maximize
    System::Call "user32::SetForegroundWindow(i r1) i."    ; Bring to front
    Abort

StartInstall:
    !insertmacro MUI_LANGDLL_DISPLAY  ; Open the language selection window
FunctionEnd
