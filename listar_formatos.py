from yt_dlp import YoutubeDL

url = "https://www.youtube.com/watch?v=DPrH1yZa6Tw"

opciones = {
    "quiet": False,
    "no_warnings": False,
}

try:
    with YoutubeDL(opciones) as ydl:
        info = ydl.extract_info(url, download=False)
        print(f"\nTítulo: {info.get('title', 'N/A')}")
        print(f"Duración: {info.get('duration', 'N/A')} segundos")
        print(f"\nFormatos disponibles:")
        
        if 'formats' in info:
            for fmt in info['formats']:
                print(f"  ID: {fmt.get('format_id', 'N/A')}, "
                      f"Formato: {fmt.get('format', 'N/A')}, "
                      f"Codec: {fmt.get('vcodec', 'N/A')}/{fmt.get('acodec', 'N/A')}")
        else:
            print("  No hay formatos disponibles")
except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
