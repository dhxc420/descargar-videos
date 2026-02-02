# Guía para Subir a GitHub

## Paso 1: Crear Repositorio en GitHub

1. Ve a https://github.com/new
2. **Nombre del repositorio:** `descargar-videos` (o el que prefieras)
3. **Descripción:** "Herramienta para descargar videos de YouTube con soporte para Windows y Linux"
4. Selecciona **Private** o **Public** según prefieras
5. **NO** marques "Add a README" (ya tenemos uno)
6. Haz clic en **Create repository**

## Paso 2: Vincularse al Repositorio Remoto

Después de crear el repositorio, GitHub te mostrará instrucciones. En PowerShell:

```powershell
cd "C:\Users\DZC\Documents\descargar videos"

# Agregar el repositorio remoto
& "C:\Program Files\Git\cmd\git.exe" remote add origin https://github.com/TU_USUARIO/descargar-videos.git

# Cambiar la rama a main (si GitHub lo exige)
& "C:\Program Files\Git\cmd\git.exe" branch -M main

# Subir los cambios
& "C:\Program Files\Git\cmd\git.exe" push -u origin main
```

**Reemplaza `TU_USUARIO` por tu usuario de GitHub**

## Paso 3: Autenticación (Primera vez)

GitHub te pedirá autenticarse. Tienes 2 opciones:

### Opción A: Token Personal (Recomendado)

1. Ve a https://github.com/settings/tokens
2. Haz clic en **Generate new token** → **Generate new token (classic)**
3. Dale un nombre: `Git Local`
4. Marca estos permisos:
   - ✅ repo (acceso completo)
   - ✅ workflow
5. Haz clic en **Generate token**
6. **Copia el token** (se muestra solo una vez)
7. Cuando Git te pida contraseña, pega el token

### Opción B: Usar Git Credential Manager

Git debería pedir que inicies sesión en GitHub automáticamente.

## Paso 4: Verificar que Se Subió

Ve a tu repositorio en GitHub: `https://github.com/TU_USUARIO/descargar-videos`

Deberías ver todos tus archivos.

## Pasos Futuros: Actualizar el Repositorio

Cuando hagas cambios y quieras subirlos:

```powershell
cd "C:\Users\DZC\Documents\descargar videos"

# Ver cambios
& "C:\Program Files\Git\cmd\git.exe" status

# Agregar cambios
& "C:\Program Files\Git\cmd\git.exe" add .

# Hacer commit
& "C:\Program Files\Git\cmd\git.exe" commit -m "Descripción de los cambios"

# Subir
& "C:\Program Files\Git\cmd\git.exe" push origin main
```

## Script Automático (Opcional)

Crea un archivo `subir.ps1`:

```powershell
param([string]$mensaje = "Actualización")

cd "C:\Users\DZC\Documents\descargar videos"
& "C:\Program Files\Git\cmd\git.exe" add .
& "C:\Program Files\Git\cmd\git.exe" commit -m $mensaje
& "C:\Program Files\Git\cmd\git.exe" push origin main

Write-Host "✓ Cambios subidos a GitHub" -ForegroundColor Green
```

Luego usa: `.\subir.ps1 "Tu mensaje"`

## Solución de Problemas

### Error: "fatal: 'origin' does not appear to be a 'git' repository"

```powershell
# Verifica que estés en la carpeta correcta
cd "C:\Users\DZC\Documents\descargar videos"

# Intenta de nuevo
& "C:\Program Files\Git\cmd\git.exe" push -u origin main
```

### Error: "Authentication failed"

1. Asegúrate de usar un token válido (no tu contraseña)
2. El token debe tener permisos de `repo`
3. Si el token expiró, genera uno nuevo

### Error: "branch does not exist"

```powershell
# Si GitHub usa "main" por defecto
& "C:\Program Files\Git\cmd\git.exe" branch -M main
& "C:\Program Files\Git\cmd\git.exe" push -u origin main
```

## ¿Qué Viene Después?

1. **Comparte el link:** Puedes enviar `https://github.com/TU_USUARIO/descargar-videos`
2. **Agrega más funciones:** Modifica el código y sigue actualizando
3. **Pide Pull Requests:** Si quieres colaboración
4. **Issues:** Usa GitHub Issues para reportar bugs

## Archivos Útiles para GitHub

Ya incluimos:
- ✅ README.md - Descripción y documentación
- ✅ .gitignore - Archivos ignorados
- ✅ LICENSE - Información legal
- ✅ INSTALACION.txt - Guía paso a paso

Puedes agregar más adelante:
- `CONTRIBUTING.md` - Guía para contribuir
- `.github/workflows/` - Automatización CI/CD
- `CHANGELOG.md` - Historial de cambios

---

**Versión:** 1.0  
**Última actualización:** 2026-02-02
