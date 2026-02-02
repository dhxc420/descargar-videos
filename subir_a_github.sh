#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Display header
echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║              SCRIPT DE SUBIDA A GITHUB - LINUX                 ║"
echo "║           Descargador de Videos desde YouTube                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}[ERROR] Git no está instalado${NC}"
    echo "Instala con: sudo apt-get install git"
    exit 1
fi

# Step 1: Configure Git
echo -e "\n${BLUE}[1/4] Verificando configuración de Git...${NC}"

if [ -z "$(git config user.email)" ]; then
    read -p "Ingresa tu email de GitHub: " EMAIL
    git config --global user.email "$EMAIL"
fi

if [ -z "$(git config user.name)" ]; then
    read -p "Ingresa tu nombre completo: " NOMBRE
    git config --global user.name "$NOMBRE"
fi

echo -e "${GREEN}[✓] Git configurado${NC}"

# Step 2: Get GitHub credentials
echo -e "\n${BLUE}[2/4] Ingresando datos de GitHub...${NC}"
read -p "Tu usuario de GitHub: " USUARIO
read -p "Nombre del repositorio (por defecto 'descargar-videos'): " NOMBRE_REPO

if [ -z "$NOMBRE_REPO" ]; then
    NOMBRE_REPO="descargar-videos"
fi

URL="https://github.com/$USUARIO/$NOMBRE_REPO.git"

echo ""
echo -e "${YELLOW}[!] Asegúrate de haber creado el repositorio en GitHub:${NC}"
echo "    $URL"
echo ""
read -p "¿Ya creaste el repositorio? (s/n): " CONFIRMA

if [[ ! "$CONFIRMA" =~ ^[sS]$ ]]; then
    echo "Crea el repositorio en: https://github.com/new"
    exit 0
fi

# Step 3: Configure remote origin
echo -e "\n${BLUE}[3/4] Configurando origen remoto...${NC}"

# Get the current directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$SCRIPT_DIR"

git remote remove origin 2>/dev/null

git remote add origin "$URL"
if [ $? -ne 0 ]; then
    echo -e "${RED}[ERROR] No se pudo agregar el origen remoto${NC}"
    exit 1
fi

echo -e "${GREEN}[✓] Origen remoto configurado${NC}"

# Step 4: Push to GitHub
echo -e "\n${BLUE}[4/4] Cambiando a rama main y subiendo...${NC}"

git branch -M main

# Prompt for authentication
echo -e "\n${YELLOW}Ingresa tu token personal de GitHub (no tu contraseña)${NC}"
echo "Obtén uno aquí: https://github.com/settings/tokens"
read -sp "Token: " TOKEN
echo ""

# Try to push with token
echo "$TOKEN" | git credential approve &>/dev/null
git push -u origin main 2>&1

if [ $? -eq 0 ]; then
    echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                   ✓ SUBIDA COMPLETADA                          ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}Tu proyecto está disponible en:${NC}"
    echo "$URL"
    echo ""
    echo "Puedes compartir este link con otros para que lo clonen"
else
    echo -e "\n${RED}[ERROR] No se pudo subir a GitHub${NC}"
    echo "Posibles causas:"
    echo "- Token personal incorrecto o expirado"
    echo "- Usuario o contraseña incorrectos"
    echo "- El repositorio no existe en GitHub"
    exit 1
fi
