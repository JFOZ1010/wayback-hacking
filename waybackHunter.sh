#!/bin/bash
# Author: jf0x0r - 2025
# Description: Script para buscar archivos sensibles en Wayback Machine
# Version: 1.0

# ================== BANNER ==================
ascii_banner() {
cat << "EOF"
                                                )                                    
                        )                )   ( /(                )                   
 (  (       )  (     ( /(     )       ( /(   )\())    )       ( /( (          (  (   
 )\))(   ( /(  )\ )  )\()) ( /(   (   )\()) ((_)\  ( /(   (   )\()))\   (     )\))(  
((_)()\  )(_))(()/( ((_)\  )(_))  )\ ((_)\   _((_) )(_))  )\ ((_)\((_)  )\ ) ((_))\  
_(()((_)((_)_  )(_))| |(_)((_)_  ((_)| |(_) | || |((_)_  ((_)| |(_)(_) _(_/(  (()(_) 
\ V  V // _` || || || '_ \/ _` |/ _| | / /  | __ |/ _` |/ _| | / / | || ' \))/ _` |  
 \_/\_/ \__,_| \_, ||_.__/\__,_|\__| |_\_\  |_||_|\__,_|\__| |_\_\ |_||_||_| \__, |  
               |__/                                                          |___/   

                                    By @jf0x0r 🔥
EOF
echo
}

# ================== PARÁMETROS ==================
while getopts ":d:" opt; do
  case $opt in
    d) DOMAIN="$OPTARG"
    ;;
    \?) echo "❌ Opción inválida: -$OPTARG" >&2; exit 1 ;;
    :) echo "❌ La opción -$OPTARG requiere un argumento." >&2; exit 1 ;;
  esac
done

# ================== VALIDACIÓN ==================
if [ -z "$DOMAIN" ]; then
  echo "Uso: $0 -d dominio.com"
  exit 1
fi

ascii_banner

# ================== FUNCIONES ==================
fetch_wayback_urls() {
  local TARGET=$1
  local OUTPUT=$2

  echo "📥 Obteniendo Wayback URLs para: $TARGET"

  # Lanzamos curl en background
  curl -s -L "https://web.archive.org/cdx/search/cdx?url=*.$TARGET/*&output=text&fl=original&collapse=urlkey&filter=statuscode:200" > "$OUTPUT" &
  local pid=$!

  # Spinner mientras descarga
  local spin='-\|/'
  local i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(( (i+1) %4 ))
    printf "\r⌛ Descargando... ${spin:$i:1} Ten paciencia, son muchas URLs..."
    sleep 0.2
  done

  wait $pid
  echo -e "\r✅ Descarga finalizada.                         "
}

filter_by_extensions() {
  local FILE="$1"

  echo "📂 Filtrando por extensiones en: $FILE"

  cat "$FILE" | grep -Ei "\.pdf$"       > pdf-files.txt
  cat "$FILE" | grep -Ei "\.log$"       > log-files.txt
  cat "$FILE" | grep -Ei "\.(bak|backup|old)$" > bak-files.txt
  cat "$FILE" | grep -Ei "\.env$"       > env-files.txt
  cat "$FILE" | grep -Ei "\.(config|ini|yml|yaml|conf)$" > config-files.txt
  cat "$FILE" | grep -Ei "\.(db|sql|sqlite)$" > db-files.txt
  cat "$FILE" | grep -Ei "\.(doc|docx|xls|xlsx|pptx)$" > doc-files.txt
  cat "$FILE" | grep -Ei "\.(zip|tar|gz|rar|7z|tgz)$" > zip-files.txt
  cat "$FILE" | grep -Ei "\.(pem|key|pub|crt|asc|pfx|p12)$" > keys-files.txt
  cat "$FILE" | grep -Ei "\.(sh|bat|py|js|exe|dll|apk|msi|dmg)$" > source-files.txt
  cat "$FILE" | grep -Ei "\.(cache|shadow|passwd|md5|htaccess|git|svn|DS_Store|bash_history|idea|vscode)$" > other-files.txt
}

# ================== MAIN ==================
mkdir -p "$DOMAIN"
cd "$DOMAIN" || exit

# 1. Obtener Wayback URLs
WAYBACK_FILE="wayback-$DOMAIN.txt"
fetch_wayback_urls "$DOMAIN" "$WAYBACK_FILE"

# 2. Filtrar por extensiones
filter_by_extensions "$WAYBACK_FILE"

echo "✅ Proceso completado. Revisa la carpeta: $DOMAIN"