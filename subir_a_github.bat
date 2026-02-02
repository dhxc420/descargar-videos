@echo off
REM Script automático para subir a GitHub

setlocal enabledelayedexpansion
chcp 65001 >nul

color 0B
title Subir a GitHub - Descargador de Videos

cls
echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║              SCRIPT DE SUBIDA A GITHUB                         ║
echo ║           Descargador de Videos desde YouTube                  ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

REM Verificar si Git está instalado
"C:\Program Files\Git\cmd\git.exe" --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Git no está instalado
    echo Instala desde: https://git-scm.com/download/win
    pause
    exit /b 1
)

echo [1/4] Verificando configuración de Git...

"C:\Program Files\Git\cmd\git.exe" config user.email >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Email de Git no configurado
    set /p EMAIL="Ingresa tu email: "
    "C:\Program Files\Git\cmd\git.exe" config --global user.email "!EMAIL!"
)

"C:\Program Files\Git\cmd\git.exe" config user.name >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Nombre de usuario de Git no configurado
    set /p NOMBRE="Ingresa tu nombre: "
    "C:\Program Files\Git\cmd\git.exe" config --global user.name "!NOMBRE!"
)

echo [✓] Git configurado

echo.
echo [2/4] Ingresando datos de GitHub...
echo.
set /p USUARIO="Tu usuario de GitHub: "
set /p NOMBRE_REPO="Nombre del repositorio (por defecto 'descargar-videos'): "

if "!NOMBRE_REPO!"=="" (
    set NOMBRE_REPO=descargar-videos
)

set URL=https://github.com/!USUARIO!/!NOMBRE_REPO!.git

echo.
echo [!] Asegúrate de haber creado el repositorio en GitHub:
echo    !URL!
echo.
pause

echo.
echo [3/4] Configurando origen remoto...

cd "C:\Users\DZC\Documents\descargar videos"

"C:\Program Files\Git\cmd\git.exe" remote remove origin 2>nul

"C:\Program Files\Git\cmd\git.exe" remote add origin !URL!
if %errorLevel% neq 0 (
    echo [ERROR] No se pudo agregar el origen remoto
    pause
    exit /b 1
)

echo [✓] Origen remoto configurado

echo.
echo [4/4] Cambiando a rama main y subiendo...

"C:\Program Files\Git\cmd\git.exe" branch -M main
"C:\Program Files\Git\cmd\git.exe" push -u origin main

if %errorLevel% neq 0 (
    echo.
    echo [ERROR] No se pudo subir a GitHub
    echo Posibles causas:
    echo - Token personal incorrecto o expirado
    echo - Usuario o contraseña incorrectos
    echo - El repositorio no existe en GitHub
    echo.
    pause
    exit /b 1
)

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                   ✓ SUBIDA COMPLETADA                          ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.
echo Tu proyecto está disponible en:
echo !URL!
echo.
echo Puedes compartir este link con otros para que lo clonen
echo.
pause
