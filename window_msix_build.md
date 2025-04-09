# Building Distributable Windows Installer for Motto Auction

This guide provides multiple approaches to build an installable Windows package that can be easily shared with users.

## Option 1: MSIX Package

MSIX is Microsoft's modern packaging format for Windows applications. We've already configured it in the project.

### Prerequisites

1. **Windows 10/11 Development Environment**
2. **Digital Certificate** - For signing the MSIX package (can be self-signed for development)

### Steps to Create a Self-Signed Certificate on Windows

Run PowerShell as Administrator and execute:

```powershell
# Generate a certificate
New-SelfSignedCertificate -Type Custom -Subject "CN=Innorithm, O=Innorithm Co., C=TH" `
  -KeyUsage DigitalSignature -FriendlyName "Motto Auction Certificate" `
  -CertStoreLocation "Cert:\CurrentUser\My" `
  -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")

# Get the thumbprint (copy this for the next command)
Get-ChildItem Cert:\CurrentUser\My | Where-Object {$_.FriendlyName -eq "Motto Auction Certificate"}

# Export certificate (replace THUMBPRINT with your actual thumbprint)
$password = ConvertTo-SecureString -String "YourPassword" -Force -AsPlainText
Export-PfxCertificate -cert "Cert:\CurrentUser\My\THUMBPRINT" -FilePath C:\path\to\certificate.pfx -Password $password
```

### Update pubspec.yaml

Modify the certificate information in pubspec.yaml:

```yaml
msix_config:
  certificate_path: C:\path\to\certificate.pfx
  certificate_password: YourPassword
```

### Build the MSIX Package

```bash
# Build the Windows app
flutter build windows

# Create the MSIX package
flutter pub run msix:create
```

The MSIX file will be created in `build\windows\runner\Release\` directory. This file can be distributed to users for installation.

### Installation Notes for Users

- Windows 10/11 users can double-click the .msix file to install
- The app will appear in the Start menu after installation
- Users will receive a warning about the certificate if it's self-signed

## Option 2: InnoSetup (Wider Compatibility)

InnoSetup creates traditional Windows installers (.exe) that work on Windows 7 and later.

### Prerequisites

1. **Download and install [InnoSetup](https://jrsoftware.org/isinfo.php)**
2. **Build your Flutter Windows app**: `flutter build windows`

### Create an InnoSetup Script

Create a file named `innosetup.iss` in your project root:

```
#define MyAppName "Motto Auction"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Innorithm"
#define MyAppURL "https://innorithm.co"
#define MyAppExeName "motto_auction.exe"

[Setup]
AppId={{8BC6B43F-9F5D-4081-A67B-C7335F4669A0}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=MottoAuction_Setup
SetupIconFile=windows\runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Add Visual C++ Redistributables
Source: "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Redist\MSVC\14.36.32532\vc_redist.x64.exe"; DestDir: {tmp}; Flags: deleteafterinstall
; Add your application files
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; Install VC++ Redistributables first
Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installing VC++ Redistributables..."
; Launch the application after install
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
```

### Important Notes about InnoSetup Script

1. **Visual C++ Redistributable**: The script above includes the VC++ Redistributable, which should solve "missing DLL" issues. You'll need to adjust the path to match your Visual Studio installation, or download the redistributable from Microsoft directly.

2. **AppID**: Generate a unique GUID for your application using an online GUID generator or replace `{8BC6B43F-9F5D-4081-A67B-C7335F4669A0}` with your own.

3. **Icon**: The script uses your app's icon for the installer.

### Build the InnoSetup Installer

1. Open InnoSetup Compiler
2. Open your `innosetup.iss` script
3. Click Build > Compile
4. The installer will be created in the `Output` folder (typically in the same directory as your script)

## Option 3: Including Required DLLs Manually

If you prefer to distribute the app without an installer, you can ensure all dependencies are included:

1. Build your Flutter Windows app: `flutter build windows`

2. Identify any missing DLLs by running the app on a clean Windows VM. Note any error messages about missing DLLs.

3. Install the [Visual C++ Redistributable for Visual Studio 2019/2022](https://docs.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist) on the target machine, or:

4. Copy the necessary DLLs from the Visual C++ Redistributable package to your application's directory. The most commonly missing DLLs are:
   - VCRUNTIME140.dll
   - VCRUNTIME140_1.dll
   - MSVCP140.dll

5. Create a ZIP file containing your application directory and instruct users to:
   - Extract the ZIP file
   - Run the .exe file
   - Create a shortcut to the desktop if desired

## Recommendations

1. **For most users**: The MSIX approach (Option 1) provides the best experience on Windows 10/11 with proper integration with the operating system.

2. **For maximum compatibility**: The InnoSetup approach (Option 2) ensures your app works on Windows 7 and later, and handles the installation of dependencies.

3. **For testing and development**: Option 3 is suitable for quickly sharing with testers.

## Troubleshooting

### Common Issues with Windows Distributables

1. **Missing DLL errors**:
   - Ensure Visual C++ Redistributable is installed or included
   - Check for any other third-party dependencies

2. **SmartScreen warnings**:
   - Sign your application with a trusted certificate
   - Use EV Code Signing certificates for automatic trust

3. **Permissions issues**:
   - Make sure the installer requests appropriate permissions
   - For MSIX, ensure capabilities are properly declared in the manifest

4. **Installation fails silently**:
   - Check Windows Event Viewer for more detailed error information
   - Try running the installer as Administrator

### Testing Your Installation

Always test your installer on a clean virtual machine to ensure all dependencies are properly handled.
