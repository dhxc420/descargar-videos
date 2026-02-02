# Descargador de Videos - Guía de Instalación

Este paquete contiene un descargador automático de videos desde YouTube.

## 📋 Contenido

- `descargar.py` - Script principal de descarga
- `listar_formatos.py` - Utilidad para listar formatos disponibles
- `instalar_windows.bat` - Instalador automático para Windows 11
- `instalar_linux.sh` - Instalador automático para Linux (Ubuntu/Debian)
- `README.md` - Este archivo

## 🪟 Instalación en Windows 11

### Opción 1: Instalación Automática (Recomendado)

1. Descarga y extrae el paquete
2. Haz clic derecho en `instalar_windows.bat`
3. Selecciona "Ejecutar como administrador"
4. Sigue las instrucciones en pantalla
5. Se creará un acceso directo en el Desktop

### Opción 2: Instalación Manual

1. Instala Python 3.13+ desde https://www.python.org/
2. Instala las dependencias:
   ```bash
   python -m pip install yt-dlp pycryptodome
   ```
3. Instala Node.js desde https://nodejs.org/
4. Instala FFmpeg desde https://ffmpeg.org/download.html (opcional pero recomendado)

### Usar después de instalar

```bash
python descargar.py
```

## 🐧 Instalación en Linux (Ubuntu/Debian)

### Opción 1: Instalación Automática (Recomendado)

1. Abre terminal en la carpeta del paquete
2. Ejecuta:
   ```bash
   chmod +x instalar_linux.sh
   ./instalar_linux.sh
   ```
3. Sigue las instrucciones

### Opción 2: Instalación Manual

```bash
# Actualizar repositorios
sudo apt-get update

# Instalar Python y pip
sudo apt-get install python3 python3-pip

# Instalar dependencias
pip3 install yt-dlp pycryptodome

# Instalar Node.js
sudo apt-get install nodejs npm

# Instalar FFmpeg
sudo apt-get install ffmpeg
```

### Usar después de instalar

```bash
# Desde cualquier carpeta (si se instaló correctamente)
descargar

# O desde la carpeta de instalación
python3 descargar.py
```

## ⚙️ Configuración

### Cambiar la URL de descarga

Edita `descargar.py` y busca esta línea:

```python
url = "https://www.youtube.com/watch?v=DPrH1yZa6Tw"
```

Reemplaza con la URL que desees descargar.

### Cambiar el directorio de salida

Busca en `descargar.py`:

```python
"outtmpl": "%(title)s.%(ext)s",
```

Puedes personalizar el formato del nombre del archivo.

## 📝 Utilidades

### Listar formatos disponibles

Para ver todos los formatos disponibles de un video:

**Windows:**
```bash
python listar_formatos.py
```

**Linux:**
```bash
python3 listar_formatos.py
```

Esto mostrará algo como:
```
ID: 18 - 640x360 (360p) - Video + Audio
ID: 137+140 - 1920x1080 (1080p) - Video + Audio
```

## 🚀 Opciones de formato

El script descarga automáticamente el mejor formato disponible, pero puedes personalizar en `descargar.py`:

```python
"format": "137+140/18/best"  # Intenta 1080p, luego 360p, luego el mejor disponible
"format": "best[height<=480]"  # Solo hasta 480p
"format": "worst"  # Menor calidad/tamaño
```

## 🛠️ Solución de Problemas

### Error: "HTTP Error 403: Forbidden"

YouTube está bloqueando la descarga. Intenta:
1. Asegúrate de tener Node.js instalado
2. Actualiza yt-dlp:
   ```bash
   pip install --upgrade yt-dlp
   ```

### Error: "No se encontró ffmpeg"

FFmpeg no está instalado. El script funcionará sin él, pero sin capacidad de mezclar video y audio.

**Windows:**
```bash
winget install Gyan.FFmpeg
```

**Linux:**
```bash
sudo apt-get install ffmpeg
```

### El video descarga muy lentamente

Algunos videos tienen limitaciones de descarga. Intenta:
1. Cambiar el cliente de YouTube: modifica `"player_client": ["web"]` a `["android"]`
2. Reducir `concurrent_fragment_downloads` a 1

### "JavaScript runtime could not be found"

Necesitas Node.js. Instálalo según tu SO.

## 📊 Características

✅ Descarga videos de YouTube  
✅ Soporte para múltiples resoluciones (144p hasta 1080p)  
✅ Merging automático de video + audio (con FFmpeg)  
✅ Reintentos automáticos en caso de fallos  
✅ Continuación de descargas interrumpidas  
✅ Progreso visible de descarga  
✅ Manejo de caracteres especiales en nombres de archivos  

## 📄 Licencia

Este script utiliza yt-dlp (Software libre bajo licencia Unlicense).

## 💡 Notas

- Los videos se guardan en tu **directorio actual** con el nombre del video
- Los videos descargados son para **uso personal** respetando los derechos de autor
- No use este script para descargar contenido protegido
- Algunos videos pueden tener restricciones de descarga

## 🔗 Enlaces útiles

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [FFmpeg](https://ffmpeg.org/)
- [Node.js](https://nodejs.org/)
- [Python](https://www.python.org/)

---

**Versión:** 1.0  
**Última actualización:** 2026-02-02
