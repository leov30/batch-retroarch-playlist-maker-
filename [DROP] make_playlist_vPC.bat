@echo off
title Auto RetroArch Playlist Maker

REM //default core path and core name
set "_core_name=DETECT"
set "_core_path=DETECT"

set "_folder=%~n1"
set "_home=%~dp0"

if "%~x1"==".dat" goto :make_dat
if "%~x1"==".xml" goto :make_dat

if "%_folder%"=="" echo DRAG AND DROP THE ROMs FOLDER TO THIS .BAT SCRIPT&pause&exit
if not exist "%_folder%\" echo not a valid folder&pause&exit

set _arcade=0
if exist "%_home%\arcade.txt" set _arcade=1

(echo {
 echo   "version": "1.0",
 echo   "items": [) >"%_folder%.lpl"

for /r "%_folder%" %%g in (*) do (
	echo %%~ng
	call :get_path "%%g"	

) 

(echo   ]
 echo }) >>"%_folder%.lpl"


REM //vbs script
(
echo Option Explicit
echo Dim objFso, objOtF, cd,  content
echo Set objFso = CreateObject^("Scripting.FileSystemObject"^)
echo cd = "%_folder%.lpl"
echo Set objOtF = objFso.OpenTextFile^(cd, 1^)
echo content = objOtF.ReadAll
echo objOtF.Close
echo Set objOtF = objFso.OpenTextFile^(cd, 2^)
echo objOtF.Write Replace^(content, chr^(013^), ""^)
echo objOtF.Close
echo wscript.echo "Complete."
) >"%temp%\temp.vbs"

cscript /nologo "%temp%\temp.vbs"

move /y "%_folder%.lpl" "%_home%"

title FINISHED
pause & exit

:get_path

set "_path=%~1"
set "_path=%_path:\=\\%"


(echo     {
echo       "path": "%_path%",)>>"%_folder%.lpl"

set _flag=0
if %_arcade% equ 1 (
	for /f "tokens=2 delims=|" %%h in ('findstr /lbc:"%~n1|" "%_home%\arcade.txt"') do (
		(echo       "label": "%%h",)>>"%_folder%.lpl"
		set _flag=1
	)
)

rem //in case game its not found in arcade.txt
if %_flag% equ 0 (echo       "label": "%~n1",)>>"%_folder%.lpl"
		

(echo       "core_path": "%_core_path%",
echo       "core_name": "%_core_name%",
echo       "crc32": "DETECT",
echo       "db_name": "%_folder%.lpl"
echo     },) >>"%_folder%.lpl"


exit /b


:make_dat
rem //only for arcade games

title may take a while...
cls&echo Making arcade.txt...

cd /d "%~dp0"
set "_tag=game"
set "_skip="

>nul findstr /l "<header>" "%~1"&&set "_skip=skip=1 "
>nul findstr /l "<machine" "%~1"&&set "_tag=machine"

del arcade.txt
for /f "%_skip%tokens=2,3 delims=><" %%g in ('findstr /l "<%_tag% <description>" "%~1"') do (
	for /f tokens^=1^,2^ delims^=^" %%i in ("%%g") do (
		if "%%i"=="%_tag% name=" (
			call :save_var "%%j" "game"
		)else (
			call :save_var "%%h" "description"
		)
	)
)
pause&exit

:save_var

if "%~1"=="" set "_game=BIOS"&exit /b
if "%~2"=="game" set "_game=%~1"&exit /b
for %%g in ("%~1") do (echo %_game%^|%%~g)>>arcade.txt
exit /b