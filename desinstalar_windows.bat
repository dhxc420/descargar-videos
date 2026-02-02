# Script de Desinstalación - Windows 11

@echo off
chcp 65001 >nul
title Desinstalador - Descargador de Videos YouTube

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║              DESINSTALADOR WINDOWS 11                          ║
echo ║           Descargador de Videos desde YouTube                  ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

echo [1/2] Limpiando archivos de instalación...

REM Delete shortcut
if exist "%USERPROFILE%\Desktop\Descargar Video.lnk" (
    del "%USERPROFILE%\Desktop\Descargar Video.lnk"
    echo [✓] Acceso directo eliminado
)

REM Delete installation directory
if exist "%APPDATA%\DescargarVideos" (
    rmdir /s /q "%APPDATA%\DescargarVideos"
    echo [✓] Carpeta de instalación eliminada
)

echo.
echo [2/2] Desinstalando paquetes Python (opcional)...
echo.
echo ¿Deseas desinstalar los paquetes Python de yt-dlp y pycryptodome?
echo (Si los usas en otros proyectos, te recomendamos mantenerlos)
echo.
set /p UNINSTALL_PYTHON="¿Desinstalar? (s/n): "

if /i "%UNINSTALL_PYTHON%"=="s" (
    python -m pip uninstall -y yt-dlp pycryptodome >nul 2>&1
    echo [✓] Paquetes Python desinstalados
)

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                 DESINSTALACIÓN COMPLETADA                      ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.
echo Los siguientes programas se mantienen instalados (opcionales):
echo - Python 3
echo - Node.js
echo - FFmpeg
echo.
echo Si deseas desinstalar estos programas, ve a:
echo Configuración > Aplicaciones > Aplicaciones instaladas
echo.
pause
