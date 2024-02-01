@echo off
setlocal ENABLEDELAYEDEXPANSION
rem execute line PreBuild "${workspaceFolder}\\generate_version_txt.bat verbuild.h drv_version.h"

:InputConfiguration
set fileversion=%1
set filevermain=%2
set filefullpath=%3
set fixforwardslashes=%4

if "%fileversion%"=="" set fileversion=version.h
if "%filevermain%"=="" set filevermain=drv_version.h

set /a debugecho=1

::sleep 2



:GetBatchFilePath
set pathbatch=%~dp0

if "%fixforwardslashes%"=="true" set "pathbatch=%pathbatch:/=\%"
if "%fixforwardslashes%"=="true" set "filevermain=%filevermain:/=\%"
if "%fixforwardslashes%"=="true" set "fileversion=%fileversion:/=\%"

if NOT "%filefullpath%"=="true" set fileversion=%pathbatch%%fileversion%
if NOT "%filefullpath%"=="true" set filevermain=%pathbatch%%filevermain%


if %debugecho% EQU 0 ( goto DEBUG_END_BATCH_PATH)
echo pathbatch       : %pathbatch%
echo vermainfile     : %filevermain%
echo versionfile     : %fileversion%
:DEBUG_END_BATCH_PATH

if exist "%fileversion%" (
    goto version_file_exists
) else (
    goto version_file_not_found
)

:version_file_exists

if exist "%filevermain%" (
    goto vermain_file_exists
) else (
    goto vermain_file_not_found
)

:vermain_file_exists



:: Initialize variables
set "BUILD_NUMBER="
set "MINOR_VERSION="
set "MAJOR_VERSION="

:: Read the file and extract the values
for /f "tokens=2,3" %%a in ('findstr "#define APP_VERSION_" %fileversion%') do (
    if "%%a"=="APP_VERSION_BUILD" set "BUILD_NUMBER=%%b"
    if "%%a"=="APP_VERSION_MINOR" set "MINOR_VERSION=%%b"
)

:: Read the file and extract the values
for /f "tokens=2,3" %%a in ('findstr "#define APP_VERSION_" %filevermain%') do (
    if "%%a"=="APP_VERSION_MAJOR" set "MAJOR_VERSION=%%b"
)

:: Output the values
echo Major Version: %MAJOR_VERSION%
echo Minor Version: %MINOR_VERSION%
echo Build Number : %BUILD_NUMBER%

<nul set /p ="%MAJOR_VERSION%.%MINOR_VERSION%.%BUILD_NUMBER%" >"version.txt"

goto version_file_end

:version_file_not_found
:vermain_file_not_found

:version_file_end	





endlocal