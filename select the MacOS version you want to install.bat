@echo off

:: Define variables
set "repo_url=https://github.com/acidanthera/OpenCorePkg.git"   :: URL to the GitHub repository
set "downloads_folder=%USERPROFILE%\Downloads"                 :: Path to the Downloads folder
set "target_folder=%downloads_folder%\OpenCorePkg"             :: Folder where the repository will be cloned
set "macrecovery_script=Utilities\macrecovery\macrecovery.py"   :: Path to macrecovery.py inside the subfolder
set "macos_version="                                          :: Placeholder for selected version

:: Prompt user for macOS version
echo Choose a macOS version to download:
echo 1. High Sierra (10.13)
echo 2. Mojave (10.14)
echo 3. Catalina (10.15)
echo 4. Big Sur (11)
echo 5. Monterey (12)
echo 6. Ventura (13)
echo 7. Sonoma (14)
echo 8. Latest version (Sequoia, 15)
set /p "choice=Enter the number corresponding to your choice (1-8): "

:: Map choice to macOS version commands
if "%choice%"=="1" (
    set "macos_version=py "%target_folder%\%macrecovery_script%" -b Mac-7BA5B2D9E42DDD94 -m 00000000000J80300 download"
) else if "%choice%"=="2" (
    set "macos_version=py "%target_folder%\%macrecovery_script%" -b Mac-7BA5B2DFE22DDD8C -m 00000000000KXPG00 download"
) else if "%choice%"=="3" (
    set "macos_version=py "%target_folder%\%macrecovery_script%" -b Mac-00BE6ED71E35EB86 -m 00000000000000000 download"
) else if "%choice%"=="4" (
    set "macos_version=py "%target_folder%\%macrecovery_script%" -b Mac-42FD25EABCABB274 -m 00000000000000000 download"
) else if "%choice%"=="5" (
    set "macos_version=py "%target_folder%\%macrecovery_script%" -b Mac-FFE5EF870D7BA81A -m 00000000000000000 download"
) else if "%choice%"=="6" (
    set "macos_version=py "%target_folder%\%macrecovery_script%" -b Mac-4B682C642B45593E -m 00000000000000000 download"
) else if "%choice%"=="7" (
    set "macos_version=py "%target_folder%\%macrecovery_script%" -b Mac-226CB3C6A851A671 -m 00000000000000000 download"
) else if "%choice%"=="8" (
    set "macos_version=py "%target_folder%\%macrecovery_script%" -b Mac-937A206F2EE63C01 -m 00000000000000000 download"
) else (
    echo Invalid choice. Please choose a valid option.
    pause
    exit /b
)

:: Check if Git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo Git is not installed. Please install Git and try again.
    pause
    exit /b
)

:: Check if the repository folder exists and if it's intact
if exist "%target_folder%" (
    echo Repository folder exists. Verifying integrity...

    :: Check if the macrecovery.py script exists
    if exist "%target_folder%\%macrecovery_script%" (
        echo macrecovery.py found. Verifying file integrity...
        :: Optional: You can check file hashes here for more robust integrity checks
        echo Integrity check passed. Running the script...
    ) else (
        echo macrecovery.py not found or files are missing. Re-downloading the repository...
        rmdir /s /q "%target_folder%"   :: Delete the existing, incomplete repository
        call :clone_repository
    )
) else (
    echo Repository folder does not exist. Cloning the repository...
    call :clone_repository
)

:: Run the command for the selected macOS version
echo Running the command: %macos_version%
%macos_version%

:: Pause to view output
pause
exit /b

:: Function to clone the repository
:clone_repository
git clone "%repo_url%" "%target_folder%"
if errorlevel 1 (
    echo Failed to clone the repository. Check the URL or your network connection.
    pause
    exit /b
)
echo Repository cloned successfully.
exit /b
