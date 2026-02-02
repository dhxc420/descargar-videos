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
echo "║                  INSTALADOR LINUX (Ubuntu/Debian)              ║"
echo "║           Descargador de Videos desde YouTube                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if running as root for some operations
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}[!] Algunos pasos requieren sudo. Se te pedirá contraseña.${NC}"
fi

# Step 1: Update system
echo -e "\n${BLUE}[1/6] Actualizando repositorios del sistema...${NC}"
sudo apt-get update -qq
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[✓] Repositorios actualizados${NC}"
else
    echo -e "${RED}[ERROR] No se pudieron actualizar repositorios${NC}"
    exit 1
fi

# Step 2: Install Python
echo -e "\n${BLUE}[2/6] Verificando Python 3...${NC}"
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo -e "${GREEN}[✓] $PYTHON_VERSION encontrado${NC}"
else
    echo -e "${YELLOW}[!] Python no encontrado. Instalando...${NC}"
    sudo apt-get install -y python3 python3-pip python3-venv
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓] Python 3 instalado${NC}"
    else
        echo -e "${RED}[ERROR] No se pudo instalar Python${NC}"
        exit 1
    fi
fi

# Step 3: Install Python dependencies
echo -e "\n${BLUE}[3/6] Instalando dependencias Python...${NC}"
echo "Instalando yt-dlp..."
pip3 install --upgrade yt-dlp &>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[✓] yt-dlp instalado${NC}"
else
    echo -e "${YELLOW}[!] Advertencia: yt-dlp puede no estar actualizado${NC}"
fi

echo "Instalando pycryptodome..."
pip3 install pycryptodome &>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[✓] pycryptodome instalado${NC}"
fi

# Step 4: Install Node.js
echo -e "\n${BLUE}[4/6] Verificando Node.js...${NC}"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}[✓] Node.js $NODE_VERSION encontrado${NC}"
else
    echo -e "${YELLOW}[!] Node.js no encontrado. Instalando...${NC}"
    sudo apt-get install -y nodejs npm
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓] Node.js instalado${NC}"
    else
        echo -e "${YELLOW}[!] No se pudo instalar Node.js automáticamente${NC}"
        echo "Instala manualmente: sudo apt-get install nodejs npm"
    fi
fi

# Step 5: Install FFmpeg
echo -e "\n${BLUE}[5/6] Verificando FFmpeg...${NC}"
if command -v ffmpeg &> /dev/null; then
    echo -e "${GREEN}[✓] FFmpeg encontrado${NC}"
else
    echo -e "${YELLOW}[!] FFmpeg no encontrado. Instalando...${NC}"
    sudo apt-get install -y ffmpeg
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✓] FFmpeg instalado${NC}"
    else
        echo -e "${YELLOW}[!] No se pudo instalar FFmpeg automáticamente${NC}"
        echo "Instala manualmente: sudo apt-get install ffmpeg"
    fi
fi

# Step 6: Setup configuration
echo -e "\n${BLUE}[6/6] Configurando archivos...${NC}"

# Create installation directory
INSTALL_DIR="$HOME/.descargar_videos"
mkdir -p "$INSTALL_DIR"
echo -e "${GREEN}[✓] Directorio de instalación: $INSTALL_DIR${NC}"

# Copy scripts
if [ -f "descargar.py" ]; then
    cp descargar.py "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/descargar.py"
    echo -e "${GREEN}[✓] descargar.py copiado${NC}"
fi

if [ -f "listar_formatos.py" ]; then
    cp listar_formatos.py "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/listar_formatos.py"
    echo -e "${GREEN}[✓] listar_formatos.py copiado${NC}"
fi

# Create launcher script
cat > "$INSTALL_DIR/descargar" << 'EOF'
#!/bin/bash
python3 "$HOME/.descargar_videos/descargar.py" "$@"
EOF
chmod +x "$INSTALL_DIR/descargar"

# Create symbolic link for easy access
sudo ln -sf "$INSTALL_DIR/descargar" /usr/local/bin/descargar 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[✓] Comando 'descargar' disponible en terminal${NC}"
fi

# Completion message
echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                   INSTALACIÓN COMPLETADA                       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${GREEN}Pasos siguientes:${NC}"
echo "1. Edita la URL en descargar.py según necesites"
echo "2. Ejecuta desde cualquier carpeta: ${YELLOW}descargar${NC}"
echo "   O: ${YELLOW}python3 $INSTALL_DIR/descargar.py${NC}"
echo ""
echo -e "${GREEN}Utilidades:${NC}"
echo "- Listar formatos: ${YELLOW}python3 $INSTALL_DIR/listar_formatos.py${NC}"
echo "- Carpeta de instalación: ${YELLOW}$INSTALL_DIR${NC}"
echo "- Los videos se guardan en: tu directorio actual"
echo ""

# Make installation directory
mkdir -p "$HOME/Descargas/yt_videos"
echo -e "${GREEN}[✓] Carpeta para videos creada: $HOME/Descargas/yt_videos${NC}"
echo ""
