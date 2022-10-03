; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "RText"
!define PRODUCT_VERSION "6.0.0"
!define PRODUCT_WEB_SITE "https://fifesoft.com/rtext/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\RText.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "src\main\dist\License.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\RText.exe"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\Readme.txt"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "rtext_${PRODUCT_VERSION}_win32_setup.exe"
InstallDir "$PROGRAMFILES\RText"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SEC01
  WriteRegStr HKLM "Software\RText" "Location" "$INSTDIR"
  CreateDirectory "$SMPROGRAMS\RText"
  CreateShortCut "$SMPROGRAMS\RText\RText.lnk" "$INSTDIR\RText.exe"
  CreateShortCut "$DESKTOP\RText.lnk" "$INSTDIR\RText.exe"
  SetOutPath "$INSTDIR"
  SetOverwrite on
  File /r "build\install\rtext\*"
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\RText\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\RText\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\RText.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\RText.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  ; Don't just Delete /r $INSTDIR, preserve files they added themselves
  ; Also guards against someone accidentally installing directly into
  ; C:\Program Files, we don't want to wipe that entire folder...
  SetOutPath "$INSTDIR"

  ; That said, we are going to be unforgiving and use wildcards
  ; to remove jar files, and blindly remove our subdirectories.
  RMDir /r "$INSTDIR\doc"
  RMDir /r "$INSTDIR\exampleMacros"
  RMDir /r "$INSTDIR\icongroups"   ; From prior installs
  RMDir /r "$INSTDIR\jre-11.0.1"   ; From prior installs
  RMDir /r "$INSTDIR\jre-14.0.1"
  RMDir /r "$INSTDIR\lnfs"
  RMDir /r "$INSTDIR\plugins"
  Delete /REBOOTOK "$INSTDIR\RText.*"
  Delete /REBOOTOK "$INSTDIR\*FileIOExtras.dll"
  Delete /REBOOTOK "$INSTDIR\english_dic.zip"
  Delete /REBOOTOK "$INSTDIR\*.jar"
  Delete /REBOOTOK "$INSTDIR\License.txt"
  Delete /REBOOTOK "$INSTDIR\Readme.txt"
  Delete /REBOOTOK "$INSTDIR\readme.unix"
  Delete /REBOOTOK "$INSTDIR\ExtraFileChooserFilters.xml"
  Delete /REBOOTOK "$INSTDIR\localizations.xml"
  Delete /REBOOTOK "$INSTDIR\uninst.exe"

  Delete "$SMPROGRAMS\RText\Uninstall.lnk"
  Delete "$SMPROGRAMS\RText\Website.lnk"
  Delete "$DESKTOP\RText.lnk"
  Delete "$SMPROGRAMS\RText\RText.lnk"

  ; Folders will be removed if they are completely empty (user didn't add anything)
  RMDir "$SMPROGRAMS\RText"
  SetOutPath "$TEMP" ; So we can remove the root dir if it's empty
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
