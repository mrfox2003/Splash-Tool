
:: Created By Mr Fox (Contact me @ https://t.me/mrfox2003 )
:: WARNING: DO NOT MODIFY THIS SCRIPT UNLESS YOU KNOW WHAT YOU'RE DOING!

:: This is for Redmi Note 10 Pro (sweet) only, please do not try on other devices..
:: For other devices: http://forum.xda-developers.com/android/software-hacking/guide-how-to-create-custom-boot-logo-t3470473

@echo off
echo.
echo #--------------------------------------------------#
echo #   Redmi Note 10 Pro (sweet) Splash  Logo  Maker  #
echo #                                                  #
echo #           By ********Mr Fox*********             #
echo #--------------------------------------------------#
echo.
echo.
echo Initializing  Tool........
echo.
echo.
echo.

:: Define output file names and paths
set output_file=logo.img
set output_file_path=output\%output_file%

set output_zip=flashable_logo.zip
set output_zip_path=output\%output_zip%

setlocal
echo Creating directories if they don't exist...
:: Create "output" and "temp" directories if they don't exist
if not exist "output\" mkdir "output\"
if not exist "temp\" ( mkdir "temp\"& attrib /S /D +h "temp" )

echo Cleaning up temporary files...
:: Delete any existing files in the "temp" and "output" directories
del /Q temp\* 2>NUL
del /Q %output_file_path% 2>NUL
del /Q %output_zip_path% 2>NUL

:: Define the resolution of the images
set resolution=1080x2400

:VERIFY_FILES
echo Verifying required image files...
:: Check for logo image file in the "pics" folder
set logo_path="not_found"
if exist "pics\logo.jpg" set logo_path="pics\logo.jpg"
if exist "pics\logo.jpeg" set logo_path="pics\logo.jpeg"
if exist "pics\logo.png" set logo_path="pics\logo.png"
if exist "pics\logo.gif" set logo_path="pics\logo.gif"
if exist "pics\logo.bmp" set logo_path="pics\logo.bmp"
if %logo_path%=="not_found" echo.logo picture not found in 'pics' folder.. EXITING&echo.&echo.&pause&exit

:: Check for fastboot image file in the "pics" folder
set fastboot_path="not_found"
if exist "pics\fastboot.jpg" set fastboot_path="pics\fastboot.jpg"
if exist "pics\fastboot.jpeg" set fastboot_path="pics\fastboot.jpeg"
if exist "pics\fastboot.png" set fastboot_path="pics\fastboot.png"
if exist "pics\fastboot.gif" set fastboot_path="pics\fastboot.gif"
if exist "pics\fastboot.bmp" set fastboot_path="pics\fastboot.bmp"
if %fastboot_path%=="not_found" echo.fastboot picture not found in 'pics' folder.. EXITING&echo.&echo.&pause&exit

:: Check for system_corrupt image file in the "pics" folder
set system_corrupt_path="not_found"
if exist "pics\system_corrupt.jpg" set system_corrupt_path="pics\system_corrupt.jpg"
if exist "pics\system_corrupt.jpeg" set system_corrupt_path="pics\system_corrupt.jpeg"
if exist "pics\system_corrupt.png" set system_corrupt_path="pics\system_corrupt.png"
if exist "pics\system_corrupt.gif" set system_corrupt_path="pics\system_corrupt.gif"
if exist "pics\system_corrupt.bmp" set system_corrupt_path="pics\system_corrupt.bmp"
if %system_corrupt_path%=="not_found" echo.system_corrupt picture not found in 'pics' folder.. EXITING&echo.&echo.&pause&exit

echo Converting images to BMP format...
:: Convert images to BMP format using ffmpeg
bin\ffmpeg.exe -hide_banner -loglevel quiet -i %logo_path% -pix_fmt rgb24 -s %resolution% -y "temp\logo_1.bmp" > NUL
bin\ffmpeg.exe -hide_banner -loglevel quiet -i %fastboot_path% -pix_fmt rgb24 -s %resolution% -y "temp\logo_2.bmp" > NUL
bin\ffmpeg.exe -hide_banner -loglevel quiet -i %logo_path% -pix_fmt rgb24 -s %resolution% -y "temp\logo_3.bmp" > NUL
bin\ffmpeg.exe -hide_banner -loglevel quiet -i %system_corrupt_path% -pix_fmt rgb24 -s %resolution% -y "temp\logo_4.bmp" > NUL

echo Creating the full logo.img...
:: Create the full logo.img by concatenating header, BMP files, and footer
copy /b "bin\header.bin"+"temp\logo_1.bmp"+"bin\footer.bin"+"temp\logo_2.bmp"+"bin\footer.bin"+"temp\logo_3.bmp"+"bin\footer.bin"+"temp\logo_4.bmp"+"bin\footer.bin" %output_file_path% >NUL

:: Check if the logo.img file was created successfully
if exist %output_file_path% (
    echo SUCCESS!
    echo %output_file% created in "output" folder
) else (
    echo PROCESS FAILED.. Try Again
    echo.
    echo.
    pause
    exit
)

:: Ask the user if they want to create a flashable zip
echo.
echo.
set /P INPUT=Do you want to create a flashable zip? [yes/no]

:: Check the user's input
If /I "%INPUT%"=="y" goto :CREATE_ZIP
If /I "%INPUT%"=="yes" goto :CREATE_ZIP

echo.
echo.
echo Flashable ZIP not created..
echo.
echo.
pause
exit

:CREATE_ZIP
echo Creating flashable zip...
:: Copy the New_Logo.zip to the output folder
copy /Y bin\New_Logo.zip %output_zip_path% >NUL

:: Change the current directory to the output folder
cd output

:: Add the logo.img to the zip file using 7za
..\bin\7za a %output_zip% %output_file% >NUL

:: Change back to the original directory
cd..

:: Check if the flashable zip file was created successfully
if exist %output_zip_path% (
    echo.
    echo.
    echo SUCCESS!
    echo Flashable zip file created in "output" folder
    echo You can flash the '%output_zip%' from any custom recovery like TWRP Recovery/ Orangefox Recovery/ AOSP Recovery
) else (
    echo.
    echo.
    echo Flashable ZIP not created..
)

echo.
echo.
pause
exit

