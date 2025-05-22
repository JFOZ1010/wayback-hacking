# 🕵️‍♂️ waybackHunter.sh

Herramienta en Bash para automatizar la recopilación y filtrado de URLs archivadas por la [Wayback Machine](https://archive.org/web/), orientada al reconocimiento web en bug bounty y pentesting.

## 🚀 ¿Qué hace?

1. **Obtiene URLs históricas** desde la Wayback Machine para un dominio dado.
2. **Filtra URLs** por extensiones sensibles y útiles (PDFs, .env, .sql, backups, credenciales, etc.).
3. Crea automáticamente un directorio con los resultados categorizados.
4. Incluye **banner personalizado** y mensajes amigables para el proceso.

## 📦 Instalación

Solo necesitas `curl`, `grep` y Bash.

```bash
git clone https://github.com/JFOZ1010/wayback-hacking.git
cd wayback-hacking
chmod 777 waybackHunter.sh

./waybackHunter.sh -d dominio.com
```

Esto generará una carpeta dominio.com/ con los siguientes archivos (si aplica):

    pdf-files.txt

    log-files.txt

    env-files.txt

    bak-files.txt

    config-files.txt

    db-files.txt

    doc-files.txt

    zip-files.txt

    keys-files.txt

    source-files.txt

    other-files.txt

## 👨‍💻 Autor

> Hecho con ❤️ por [@jf0x0r](https://x.com/pwnedrar_)

