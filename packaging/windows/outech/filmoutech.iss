; FilmOutech installer for Windows x64 (Inno Setup 6). Per-user install, no administrator rights.
;   ISCC /DAppVersion=0.7.2 /DBinDir=..\..\..\target\release filmoutech.iss
; Output: dist\release\filmoutech-<version>-windows-x64-setup.exe

#ifndef AppVersion
  #define AppVersion "0.7.2"
#endif
#ifndef BinDir
  #define BinDir "..\..\..\target\release"
#endif
#define Root "..\..\.."

[Setup]
AppId={{2F84E1C6-EF5E-4BF9-811B-E55ECF0E3A37}
AppName=FilmOutech
AppVersion={#AppVersion}
AppPublisher=Outech
DefaultDirName={autopf}\FilmOutech
DefaultGroupName=FilmOutech
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
LicenseFile={#Root}\LICENSE-MIT
SetupIconFile={#Root}\assets\app-icon\filmcraft.ico
UninstallDisplayIcon={app}\filmoutech.exe
OutputDir={#Root}\dist\release
OutputBaseFilename=filmoutech-{#AppVersion}-windows-x64-setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern

[Tasks]
Name: "desktopicon"; Description: "Create a desktop shortcut"
Name: "claude"; Description: "Link FilmOutech with Claude (adds its MCP connector to the Claude desktop app)"

[Files]
Source: "{#BinDir}\filmoutech.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BinDir}\filmoutech-cli.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "link-claude.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#Root}\assets\app-icon\filmcraft.ico"; DestDir: "{app}"; DestName: "filmoutech.ico"; Flags: ignoreversion
Source: "{#Root}\LICENSE-MIT"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#Root}\LICENSE-APACHE"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#Root}\NOTICE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\FilmOutech"; Filename: "{app}\filmoutech.exe"; IconFilename: "{app}\filmoutech.ico"
; Opens the control port the "filmoutech-live" connector talks to, so Claude works in this window.
Name: "{group}\FilmOutech (Claude live)"; Filename: "{app}\filmoutech.exe"; Parameters: "--control 9876"; IconFilename: "{app}\filmoutech.ico"
Name: "{group}\Link FilmOutech with Claude"; Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -NoExit -File ""{app}\link-claude.ps1"""; IconFilename: "{app}\filmoutech.ico"
Name: "{autodesktop}\FilmOutech"; Filename: "{app}\filmoutech.exe"; IconFilename: "{app}\filmoutech.ico"; Tasks: desktopicon

[Run]
Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\link-claude.ps1"" -Quiet"; Flags: runhidden; Tasks: claude
Filename: "{app}\filmoutech.exe"; Description: "Launch FilmOutech"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "powershell.exe"; Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\link-claude.ps1"" -Unlink -Quiet"; Flags: runhidden; RunOnceId: "UnlinkClaude"
