@echo off
setlocal enabledelayedexpansion

:: Define paths and image URL
set "ImageUrl=https://raw.githubusercontent.com/Suppy-spec/Image-hosting-/main/tung.jpeg"
set "SavePath=%userprofile%\Desktop\tung.jpg"

echo Downloading image...
powershell -NoProfile -Command ^
  "try { Invoke-WebRequest -Uri '%ImageUrl%' -OutFile '%SavePath%' -UseBasicParsing } catch { exit 1 }"

if errorlevel 1 (
    echo Failed to download the image. Check the URL or your internet connection.
    pause
    exit /b 1
)

echo Setting wallpaper...

:: Set wallpaper style in registry
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d 2 /f >nul
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /d 0 /f >nul

:: Set the wallpaper using PowerShell COM object (more reliable)
powershell -NoProfile -Command ^
  "$code = '[DllImport(\"user32.dll\", SetLastError=true)] public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);';" ^
  "Add-Type -MemberDefinition $code -Name NativeMethods -Namespace Win32;" ^
  "[Win32.NativeMethods]::SystemParametersInfo(20, 0, '%SavePath%', 3);"

echo Wallpaper has been set to: %SavePath%
timeout /t 1 >nul
echo Tunging complete.
endlocal

for /L %%i in (1,1,75) do (
    start "" powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Youve been tunged by sahur! %%i Still, this isnt actually malicious lol', 'Sahurs child number %%i')"
    timeout /nobreak /t 0.25 >nul
)



exit /b 0
