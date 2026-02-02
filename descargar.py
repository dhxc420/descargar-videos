from yt_dlp import YoutubeDL
import os
import shutil
import tempfile
import urllib.request
import zipfile
import ssl
import subprocess

# Desabilitar verificación SSL (solo para desarrollo - NO USAR EN PRODUCCIÓN)
ssl._create_default_https_context = ssl._create_unverified_context

url = "https://www.youtube.com/watch?v=DPrH1yZa6Tw"

def progress_hook(d):
    """Hook para mostrar progreso de descarga"""
    if d['status'] == 'downloading':
        percent = d.get('_percent_str', 'N/A').strip()
        speed = d.get('_speed_str', 'N/A').strip()
        eta = d.get('_eta_str', 'N/A').strip()
        print(f"Descargando... {percent} @ {speed} (ETA: {eta})", end='\r')
    elif d['status'] == 'finished':
        print("\nDescarga completada, procesando...")

# Limpiar archivos parciales
for file in os.listdir("."):
    if file.endswith(".part") or file.endswith(".f248"):
        try:
            os.remove(file)
            print(f"Limpiado: {file}")
        except:
            pass


configured_ffmpeg_dir = r"C:\ruta\a\ffmpeg\bin"



ffmpeg_path = None
if configured_ffmpeg_dir:
    candidate = os.path.join(configured_ffmpeg_dir, "ffmpeg.exe")
    if os.path.isfile(candidate):
        ffmpeg_path = configured_ffmpeg_dir  

if not ffmpeg_path:
    which = shutil.which("ffmpeg")
    if which:
        ffmpeg_path = os.path.dirname(which)


if not ffmpeg_path:
    try:
        print("ffmpeg no encontrado — descargando build portable (puede tardar)...")
        tmp = tempfile.mkdtemp()
        zip_url = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"
        zip_path = os.path.join(tmp, "ffmpeg.zip")
        urllib.request.urlretrieve(zip_url, zip_path)
        with zipfile.ZipFile(zip_path, "r") as z:
            z.extractall(tmp)
        # Buscar ffmpeg.exe dentro del zip extraído
        for root, _, files in os.walk(tmp):
            if "ffmpeg.exe" in files:
                ffmpeg_path = root
                break
        if ffmpeg_path:
            print(f"ffmpeg descargado y encontrado en: {ffmpeg_path}")
        else:
            print("No se pudo localizar ffmpeg.exe en el ZIP descargado; continuaré sin ffmpeg.")
    except Exception as e:
        print("Error descargando ffmpeg:", e)
        ffmpeg_path = None

if ffmpeg_path:
    opciones = {
        "format": "137+140/136+140/135+140/18/best",  # Intenta varias combinaciones
        "merge_output_format": "mp4",
        "ffmpeg_location": ffmpeg_path,
        "postprocessor_args": ["-c:a", "aac", "-b:a", "192k"],
        "keepvideo": False,  # No guardar archivos intermedios
        "outtmpl": "%(title)s.%(ext)s",
        "socket_timeout": 120,
        "retries": 20,
        "fragment_retries": 20,
        "continuedl": True,
        "concurrent_fragment_downloads": 1,
        "http_chunk_size": 1048576,
        "noplaylist": True,
        "quiet": False,
        "no_warnings": False,
        "http_headers": {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        },
        "extractor_args": {"youtube": {"player_client": ["android"], "caption_languages": ["es", "en"]}},
        "progress_hooks": [progress_hook],
    }
else:
    print("Aviso: ffmpeg no disponible. Se hará fallback a descarga de un solo stream (sin merge).")
    print("Recomiendo instalar ffmpeg (winget / choco) para evitar problemas de timestamps.")
    opciones = {
        "format": "18/best",  # Formato que contiene audio y vídeo
        "keepvideo": False,
        "outtmpl": "%(title)s.%(ext)s",
        "socket_timeout": 120,
        "retries": 20,
        "fragment_retries": 20,
        "continuedl": True,
        "concurrent_fragment_downloads": 1,
        "http_chunk_size": 1048576,
        "noplaylist": True,
        "quiet": False,
        "no_warnings": False,
        "http_headers": {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        },
        "extractor_args": {"youtube": {"player_client": ["android"], "caption_languages": ["es", "en"]}},
        "progress_hooks": [progress_hook],
    }

try:
    print(f"Iniciando descarga de: {url}")
    with YoutubeDL(opciones) as ydl:
        ydl.download([url])
    print("✓ Descarga completada exitosamente")
except Exception as e:
    print(f"✗ Error durante la descarga: {e}")
    print("\nIntentando actualizar yt-dlp...")
    try:
        subprocess.run([
            "C:\\Users\\DZC\\AppData\\Local\\Microsoft\\WindowsApps\\python3.13.exe",
            "-m", "pip", "install", "--upgrade", "yt-dlp"
        ], check=True)
        print("yt-dlp actualizado. Por favor, intenta nuevamente.")
    except:
        pass
    import traceback
    traceback.print_exc()
