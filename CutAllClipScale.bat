# // Script // PBJ/
cls
@echo off
echo.
echo **********************************************************
echo      This script will create clips from your specified
echo      time section from all videos in this directory.
echo **********************************************************
echo.
pause
echo.
:input
echo Choose your input file type.
echo 1. mp4
echo 2. mov
echo 3. insv
set choice=
set /p choice=Type 1,2 or 3 - 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto mp4
if '%choice%'=='2' goto mov
if '%choice%'=='3' goto insv
:nofile
echo.

CHOICE /C YN /M  "No such file type here, choose another 'Y' or exit 'N'"
IF ERRORLEVEL 2 goto exit
IF ERRORLEVEL 1 goto input
goto input
:exit
exit
:mp4
if not exist "*.mp4" (
goto nofile
) else (
SET ext=mp4)
CHOICE /C YN /M  "You have set the input file type to %ext% is this correct?"
IF ERRORLEVEL 2 goto input
IF ERRORLEVEL 1 goto encode
:mov
if not exist "*.mov" (
goto nofile
) else (
SET ext=mov)
CHOICE /C YN /M  "You have set the input file type to %ext% is this correct?"
IF ERRORLEVEL 2 goto input
IF ERRORLEVEL 1 goto encode
:insv
if not exist "*.insv" (
goto nofile
) else (
SET ext=insv)
CHOICE /C YN /M  "You have set the input file type to %ext% is this correct?"
IF ERRORLEVEL 2 goto input
IF ERRORLEVEL 1 goto encode
echo.

:encode
echo.
echo Choose your encoding type ProRes or DnxHR...
echo 1. Copy no transcode
echo 2. to Prores
echo 3. to DNxHd 8bit
echo 4. to DNxHR 10bit
set choice=
set /p choice=Type 1,2,3 or 4 - 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto copy
if '%choice%'=='2' goto prores
if '%choice%'=='3' goto dnxhr8
if '%choice%'=='4' goto dnxhr10
ECHO "%choice%" is not valid, try again

:copy
SET encode=-c copy
SET encodedisplay=copyOnly
SET extout=%ext%
CHOICE /C YN /M  "You have set the encoding type to %encodedisplay% is this correct?"
IF ERRORLEVEL 2 goto encode
IF ERRORLEVEL 1 goto inpoint
:prores
echo.
echo ------------encoding format------------
echo prores
echo.
echo Choose your ProRes profile
echo 1. Proxy
echo 2. LT
echo 3. Standard
echo 4. HQ
echo 5. 4444
set choice=
set /p choice=Type 1,2,3 or 4 - 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='0' goto :profile0
if '%choice%'=='1' goto :profile1
if '%choice%'=='2' goto :profile2
if '%choice%'=='3' goto :profile3
if '%choice%'=='4' goto :profile4
ECHO "%choice%" is not valid, try again
:profile0
SET profile=0 -pix_fmt yuv422p10le
goto proencode
:profile1
SET profile=1 -pix_fmt yuv422p10le
goto proencode
:profile2
SET profile=2 -pix_fmt yuv422p10le
goto proencode
:profile3
SET profile=3 -pix_fmt yuv422p10le
goto proencode
:profile4
SET profile=4444 -pix_fmt yuv444p10le
goto proencode
:proencode
SET encode=-c:v prores_ks -profile:v %profile%
SET encodedisplay=prores
SET extout=mov
CHOICE /C YN /M  "You have set the encoding type to %profile% is this correct?"
IF ERRORLEVEL 2 goto encode
IF ERRORLEVEL 1 goto inpoint

:dnxhr8
echo dnxhr8
SET encode=-c:v dnxhd -pix_fmt yuv422p -trellis 0 -me_range 16 -refs 3 -sc_threshold 40 -nitris_compat 1 -sn -profile:v dnxhr_hq
SET encodedisplay=DNxhd8
SET extout=mov
CHOICE /C YN /M  "You have set the encoding type to %encodedisplay% is this correct?"
IF ERRORLEVEL 2 goto encode
IF ERRORLEVEL 1 goto inpoint

:dnxhr10
echo dnxhr10
SET encode=-c:v dnxhd -pix_fmt yuv422p10 -trellis 0 -me_range 16 -refs 3 -sc_threshold 40 -nitris_compat 1 -sn -profile:v dnxhr_hqx
SET encodedisplay=DNxhr10
CHOICE /C YN /M  "You have set the encoding type to %encodedisplay% is this correct?"
IF ERRORLEVEL 2 goto encode
IF ERRORLEVEL 1 goto inpoint

:inpoint
echo.
echo Set your in-point
SET /p inpoint="format (h m s) ie (zero hours:1 minute:10 seconds) would be 00:01:10: "
echo.
echo.
echo Now set the time duration in seconds. ie 10 seconds long would be 10: "
SET /p time="enter the duration: "
:scale
CHOICE /C YN /M  "do you need to re-scale?"
IF ERRORLEVEL 2 goto outdir
IF ERRORLEVEL 1 goto scalechoice
:scalechoice
SET /p w="enter the width in pixels: "
SET /p h="enter the height in pixels: "
CHOICE /C YN /M  "new size will be %w%x%h%, is this correct?"
IF ERRORLEVEL 2 goto scale
IF ERRORLEVEL 1 goto outdir2
echo.
:outdir
echo Create your output directory
SET /p outputdir="Name: "
if not exist "%outputdir%" (mkdir "%outputdir%"
goto run
) else (goto start)
:outdir2
echo Create your output directory
SET /p outputdir="Name: "
if not exist "%outputdir%" (mkdir "%outputdir%"
goto run2
) else (goto start)
:menu
echo Nothing Done, make a new choice.
pause
cls
:start
echo.
echo *********************************************************
echo Directory "%outputdir%" already exists, choose an option
echo *********************************************************
echo.
echo 1. Try again with a different name.
echo 2. Delete directory "%outputdir%" and files.
echo 3. Overwrite files in "%outputdir%".
echo 4. Rename "%outputdir%" to "%outputdir%_OLD".
echo 5. Exit.
set choice=
set /p choice=Type 1,2,3,4 or 5 - 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto outdir
if '%choice%'=='2' goto delete
if '%choice%'=='3' goto overwrite
if '%choice%'=='4' goto bak
if '%choice%'=='5' exit
ECHO "%choice%" is not valid, try again
:Delete
echo. 
echo *************************************
echo Deleting: %outputdir%
CHOICE /C YN /M "Are you sure?"
echo *************************************
IF ERRORLEVEL 2 goto menu
IF ERRORLEVEL 1 rmdir /s /q "%outputdir%"
mkdir %outputdir%
goto run
:overwrite
echo. 
echo *************************************
echo Overwriting: %outputdir%\
CHOICE /C YN /M "Are you sure?"
echo *************************************
IF ERRORLEVEL 2 goto menu
IF ERRORLEVEL 1 goto run
:bak
ren %outputdir% %outputdir%_OLD
echo.
echo %outputdir% renamed to %outputdir%_OLD
mkdir %outputdir%
echo.
:run
echo script running
for %%a in ("*.%ext%") do ffmpeg -ss %inpoint% -i "%%a" -t %time% %encode% %outputdir%\%%~na-CLIP-%encodedisplay%-%time%sec.%extout%
:run2
echo script running
for %%a in ("*.%ext%") do ffmpeg -ss %inpoint% -i "%%a" -t %time% %encode% -vf scale=%w%:%h% %outputdir%\%%~na-CLIP-%encodedisplay%-%time%sec.%extout%
echo.
echo DONE
echo Your movie clips are in the directory %outputdir%
echo.
echo.
CHOICE /C YN /M "Would you like to cut another clip now?"
IF ERRORLEVEL 2 exit
IF ERRORLEVEL 1 goto input
echo.
pause