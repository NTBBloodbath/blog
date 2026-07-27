#!/usr/bin/env bash

# Script para duplicar un archivo hasta N copias totales (original + duplicados)
# Uso: ./duplicar_archivo.sh -n <N> [-s <archivo_origen>] [-d]
#   -n N : número total de archivos deseado (original + duplicados)
#   -s   : archivo origen (por defecto: content/journal/norg-on-the-web.norg)
#   -d   : eliminar todos los duplicados (deja solo el original)
#   -h   : mostrar ayuda

# Configuración por defecto
ARCHIVO_ORIGEN="content/journal/norg-on-the-web.norg"
TOTAL=0
MODO_BORRAR=false

# Función para mostrar ayuda
mostrar_ayuda() {
    cat << EOF
Uso: $0 -n N [-s archivo] [-d]

Opciones:
  -n N    Número total de archivos deseado (original + duplicados). N debe ser >= 1.
  -s      Archivo origen (por defecto: $ARCHIVO_ORIGEN)
  -d      Eliminar todos los duplicados, dejando solo el original
  -h      Mostrar esta ayuda

Ejemplos:
  # Crear un total de 5 archivos (original + 4 duplicados)
  $0 -n 5

  # Usar otro archivo origen
  $0 -n 10 -s "otro/archivo.txt"

  # Eliminar todos los duplicados del archivo por defecto
  $0 -d

  # Eliminar duplicados de un archivo específico
  $0 -d -s "otro/archivo.txt"
EOF
    exit 0
}

# Procesar argumentos
while getopts "n:s:dh" opt; do
    case $opt in
        n) TOTAL="$OPTARG" ;;
        s) ARCHIVO_ORIGEN="$OPTARG" ;;
        d) MODO_BORRAR=true ;;
        h) mostrar_ayuda ;;
        *) mostrar_ayuda ;;
    esac
done

# Validar modo borrar
if $MODO_BORRAR; then
    if [ ! -f "$ARCHIVO_ORIGEN" ]; then
        echo "Error: El archivo original '$ARCHIVO_ORIGEN' no existe."
        exit 1
    fi

    # Obtener directorio, nombre base y extensión
    DIR=$(dirname "$ARCHIVO_ORIGEN")
    BASENAME=$(basename "$ARCHIVO_ORIGEN")
    NOMBRE="${BASENAME%.*}"
    EXTENSION="${BASENAME##*.}"
    if [ "$EXTENSION" = "$BASENAME" ]; then
        EXTENSION=""
    else
        EXTENSION=".$EXTENSION"
    fi

    # Patrón de duplicados: nombre_copyN.ext
    PATRON="${NOMBRE}_copy[0-9]*${EXTENSION}"
    echo "Eliminando duplicados en '$DIR' que coincidan con: $PATRON"
    find "$DIR" -maxdepth 1 -type f -name "$PATRON" -exec rm -v {} \;
    echo "Duplicados eliminados. Solo queda el original: $ARCHIVO_ORIGEN"
    exit 0
fi

# Validar que se haya proporcionado N
if [ -z "$TOTAL" ] || [ "$TOTAL" -lt 1 ]; then
    echo "Error: Debes especificar -n N con N >= 1"
    mostrar_ayuda
fi

# Validar que el archivo origen existe
if [ ! -f "$ARCHIVO_ORIGEN" ]; then
    echo "Error: El archivo original '$ARCHIVO_ORIGEN' no existe."
    exit 1
fi

# Directorio, nombre base y extensión
DIR=$(dirname "$ARCHIVO_ORIGEN")
BASENAME=$(basename "$ARCHIVO_ORIGEN")
NOMBRE="${BASENAME%.*}"
EXTENSION="${BASENAME##*.}"
if [ "$EXTENSION" = "$BASENAME" ]; then
    EXTENSION=""
else
    EXTENSION=".$EXTENSION"
fi

# Contar cuántos duplicados existen actualmente (formato nombre_copyN.ext)
PATRON="${NOMBRE}_copy[0-9]*${EXTENSION}"
EXISTENTES=$(find "$DIR" -maxdepth 1 -type f -name "$PATRON" | wc -l)

# Número total de archivos actual (original + duplicados)
TOTAL_ACTUAL=$((EXISTENTES + 1))
echo "Archivos actuales (original + duplicados): $TOTAL_ACTUAL"
echo "Se desea alcanzar: $TOTAL"

if [ $TOTAL_ACTUAL -eq $TOTAL ]; then
    echo "Ya existe el número deseado de archivos. No se realiza ninguna acción."
    exit 0
elif [ $TOTAL_ACTUAL -gt $TOTAL ]; then
    echo "Hay más archivos de los deseados. Para reducir, usa la opción -d y luego vuelve a ejecutar."
    exit 1
fi

# Cuántos nuevos duplicados crear
NUEVOS=$((TOTAL - TOTAL_ACTUAL))
echo "Creando $NUEVOS nuevo(s) duplicado(s)..."

# Encontrar el siguiente número disponible
# Listar números existentes en los duplicados
mapfile -t NUMEROS < <(find "$DIR" -maxdepth 1 -type f -name "$PATRON" | sed -E "s/.*_copy([0-9]+)${EXTENSION//./\\.}/\1/")
SIGUIENTE=1
while [[ " ${NUMEROS[*]} " =~ " $SIGUIENTE " ]]; do
    SIGUIENTE=$((SIGUIENTE + 1))
done

# Crear los duplicados
for ((i=0; i<NUEVOS; i++)); do
    NUEVO_NOMBRE="${NOMBRE}_copy${SIGUIENTE}${EXTENSION}"
    NUEVA_RUTA="${DIR}/${NUEVO_NOMBRE}"
    cp "$ARCHIVO_ORIGEN" "$NUEVA_RUTA"
    echo "Creado: $NUEVA_RUTA"
    SIGUIENTE=$((SIGUIENTE + 1))
done

echo "Proceso completado. Total de archivos: $(find "$DIR" -maxdepth 1 -type f \( -name "$BASENAME" -o -name "$PATRON" \) | wc -l)"
