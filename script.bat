@echo off
setlocal enabledelayedexpansion

set versi_lokal=V.1.1.2
set url_versi=https://raw.githubusercontent.com/simonarif86/bat/refs/heads/main/version.txt
set url_bat=https://raw.githubusercontent.com/username/repo/main/script.bat
set "nama_bat="

REM Coba ambil versi dari GitHub, simpan ke file sementara
set tmp_file=%temp%\github_version.txt
powershell -Command "try { (Invoke-WebRequest -UseBasicParsing %url_versi%).Content | Out-File -Encoding ascii '%tmp_file%' } catch { exit 1 }"
if errorlevel 1 (
    echo Gagal terhubung ke GitHub untuk mengambil versi.
    echo Periksa koneksi internet atau URL sumber.
    pause
    exit /b
)

REM Baca versi dari file sementara
set /p versi_github=<%tmp_file%
del %tmp_file%

echo Versi lokal: %versi_lokal%
echo Versi GitHub yang didapat: [%versi_github%]
echo OK BARU
pause

if "%versi_github%"=="" (
    echo Gagal mendapatkan versi dari GitHub. File versi kosong.
    pause
    exit /b
)

REM Cari file .bat yang mengandung kata FINAL
for %%f in ("%~dp0*.bat") do (
    echo Memeriksa file: %%~nxf
    echo %%~nxf | findstr /i "FINAL" >nul
    if !errorlevel! == 0 (
        set "nama_bat=%%~nxf"
        goto :found
    )
)


echo File .bat dengan kata FINAL tidak ditemukan!
pause
exit /b

:found
echo File .bat yang ditemukan: %nama_bat%

if "%versi_lokal%"=="%versi_github%" (
    echo Versi sama, lanjutkan...
    REM letakkan script utama kamu di sini
) else (
    echo Versi beda, update script...
    set /p jawab=Download versi terbaru dari GitHub? (Y/N): 
    if /i "%jawab%"=="Y" (
        REM Buat delme.bat untuk hapus dan download ulang
        >delme.bat (
            echo @echo off
            echo timeout /t 2 /nobreak >nul
            echo del "%~dp0%nama_bat%"
            echo powershell -Command "Invoke-WebRequest -Uri '%url_bat%' -OutFile '%~dp0%nama_bat%'"
            echo start "" "%~dp0%nama_bat%"
            echo exit
        )
        start "" delme.bat
        exit
    ) else (
        echo Tidak jadi update, keluar...
        exit
    )
)

pause
