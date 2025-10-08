@echo off
setlocal

rem Parameter pertama adalah path dari file utama yang sedang berjalan
set "target=%~1"

echo 🔧 Menjalankan proses update...
timeout /t 2 >nul

rem Cek jika target file ada, lalu hapus
if exist "%target%" (
    echo 🧹 Menghapus file lama: %target%
    del /f /q "%target%"
) else (
    echo ⚠ Tidak ditemukan file untuk dihapus.
)

rem Tambahkan proses update lainnya di sini, misalnya copy file baru
echo ✅ Update selesai.

pause
exit
