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
echo "║             DESINSTALADOR LINUX (Ubuntu/Debian)                ║"
echo "║           Descargador de Videos desde YouTube                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

INSTALL_DIR="$HOME/.descargar_videos"

echo -e "\n${BLUE}[1/3] Eliminando acceso rápido del sistema...${NC}"

# Remove symbolic link
if [ -L /usr/local/bin/descargar ]; then
    sudo rm /usr/local/bin/descargar
    echo -e "${GREEN}[✓] Comando 'descargar' eliminado${NC}"
fi

echo -e "\n${BLUE}[2/3] Eliminando archivos de instalación...${NC}"

# Remove installation directory
if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo -e "${GREEN}[✓] Directorio de instalación eliminado: $INSTALL_DIR${NC}"
fi

# Remove downloads directory
if [ -d "$HOME/Descargas/yt_videos" ]; then
    read -p "¿Eliminar carpeta de descargas en ~/Descargas/yt_videos? (s/n): " REMOVE_VIDEOS
    if [[ "$REMOVE_VIDEOS" == "s" || "$REMOVE_VIDEOS" == "S" ]]; then
        rm -rf "$HOME/Descargas/yt_videos"
        echo -e "${GREEN}[✓] Carpeta de descargas eliminada${NC}"
    else
        echo -e "${YELLOW}[!] Carpeta de descargas mantenida${NC}"
    fi
fi

echo -e "\n${BLUE}[3/3] Desinstalando paquetes Python (opcional)...${NC}"
echo ""
read -p "¿Desinstalar yt-dlp y pycryptodome? (s/n): " UNINSTALL_PYTHON

if [[ "$UNINSTALL_PYTHON" == "s" || "$UNINSTALL_PYTHON" == "S" ]]; then
    pip3 uninstall -y yt-dlp pycryptodome &>/dev/null
    echo -e "${GREEN}[✓] Paquetes Python desinstalados${NC}"
else
    echo -e "${YELLOW}[!] Paquetes Python mantenidos${NC}"
fi

echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                 DESINSTALACIÓN COMPLETADA                      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${YELLOW}Nota:${NC}"
echo "Los siguientes programas se mantienen instalados:"
echo "- Python 3"
echo "- Node.js"
echo "- FFmpeg"
echo ""
echo "Para desinstalarlos, usa:"
echo "  ${YELLOW}sudo apt-get autoremove${NC}"
echo ""
