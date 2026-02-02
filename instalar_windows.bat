@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

color 0A
title Instalador - Descargador de Videos YouTube

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                  INSTALADOR WINDOWS 11                         ║
echo ║           Descargador de Videos desde YouTube                  ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

REM Verificar si se ejecuta como administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Este script requiere permisos de administrador
    echo Reiniciando con permisos elevados...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

echo [1/5] Verificando Python...
python --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Python no encontrado. Instalando...
    powershell -Command "winget install Python.Python.3.13 -e"
    if %errorLevel% neq 0 (
        echo [ERROR] No se pudo instalar Python. Por favor, instala manualmente desde https://www.python.org/
        pause
        exit /b 1
    )
) else (
    for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
    echo [✓] !PYTHON_VERSION! encontrado
)

echo.
echo [2/5] Instalando dependencias Python...
echo Instalando yt-dlp...
python -m pip install --upgrade yt-dlp >nul 2>&1
echo [✓] yt-dlp instalado

echo Instalando pycryptodome...
python -m pip install pycryptodome >nul 2>&1
echo [✓] pycryptodome instalado

echo.
echo [3/5] Verificando Node.js...
node --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Node.js no encontrado. Instalando...
    powershell -Command "winget install OpenJS.NodeJS"
    if %errorLevel% neq 0 (
        echo [ADVERTENCIA] No se pudo instalar Node.js automáticamente
        echo Instala manualmente desde: https://nodejs.org/
    )
) else (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo [✓] Node.js !NODE_VERSION! encontrado
)

echo.
echo [4/5] Verificando FFmpeg...
ffmpeg -version >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] FFmpeg no encontrado. Instalando...
    powershell -Command "winget install Gyan.FFmpeg"
    if %errorLevel% neq 0 (
        echo [ADVERTENCIA] No se pudo instalar FFmpeg automáticamente
        echo Instala manualmente desde: https://ffmpeg.org/download.html
        echo El descargador funcionará sin FFmpeg, pero con limitaciones
    )
) else (
    echo [✓] FFmpeg encontrado
)

echo.
echo [5/5] Creando accesos directos y configuración...

REM Crear carpeta de datos si no existe
if not exist "%APPDATA%\DescargarVideos" mkdir "%APPDATA%\DescargarVideos"

REM Copiar script principal
copy "descargar.py" "%APPDATA%\DescargarVideos\" >nul 2>&1
if exist "listar_formatos.py" copy "listar_formatos.py" "%APPDATA%\DescargarVideos\" >nul 2>&1

REM Crear acceso directo en Escritorio
set DESKTOP=%USERPROFILE%\Desktop
set SHORTCUT=%DESKTOP%\Descargar Video.lnk

powershell -Command ^
  "$WshShell = New-Object -ComObject WScript.Shell; " ^
  "$Shortcut = $WshShell.CreateShortcut('%SHORTCUT%'); " ^
  "$Shortcut.TargetPath = '%APPDATA%\DescargarVideos\descargar.py'; " ^
  "$Shortcut.Arguments = ''; " ^
  "$Shortcut.IconLocation = 'C:\Windows\System32\shell32.dll,13'; " ^
  "$Shortcut.Save()" >nul 2>&1

echo [✓] Acceso directo creado en Desktop

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                   INSTALACIÓN COMPLETADA                       ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.
echo Pasos siguientes:
echo 1. Edita la URL en descargar.py según necesites
echo 2. Ejecuta: python "%APPDATA%\DescargarVideos\descargar.py"
echo 3. O usa el acceso directo "Descargar Video" en el Desktop
echo.
echo Útil:
echo - Para listar formatos: python "%APPDATA%\DescargarVideos\listar_formatos.py"
echo - Los videos se guardan en: tu directorio actual
echo.
pause
