@echo off
chcp 65001 > nul
title Téléchargement YouTube en MP3

echo ==========================================================================
echo Script de téléchargement automatique d'une playlist Youtube au format MP3
echo Aurélien Bulliard - 24.11.2026
echo ==========================================================================
echo:
echo:

set "YtdlpPath=.\exec\yt-dlp.exe"
set "FfmpegPath=.\exec\ffmpeg\bin"

echo Veuillez coller l'URL (lien) YouTube (Video ou Playlist) (avec Ctrl+V ou clic droit):
set /p "Url="

set "Url=%Url:"=%"

if "%Url%"=="" (
    echo [ERREUR] Aucune URL fournie. Arrêt du script.
    pause
    exit /b
)

echo.
echo Analyse de l'URL en cours...

set "FolderTitle="
for /f "delims=" %%i in ('"%YtdlpPath%" --flat-playlist --skip-download --print "playlist_title" "%Url%" 2^>nul') do (
    set "FolderTitle=%%i"
)

if "%FolderTitle%"=="" (
    for /f "delims=" %%i in ('"%YtdlpPath%" --skip-download --print "title" "%Url%" 2^>nul') do (
        set "FolderTitle=%%i"
    )
)

if "%FolderTitle%"=="" set "FolderTitle=Telechargement_Audio"

echo Dossier cible : %FolderTitle%
echo.
echo Début du téléchargement et de la conversion en MP3...
echo.

set "OutputTemplate=%FolderTitle%/%%(playlist_index&{} - |)s%%(title)s.%%(ext)s"

"%YtdlpPath%" -x --audio-format mp3 -o "%OutputTemplate%" --ffmpeg-location "%FfmpegPath%" "%Url%"

if %ERRORLEVEL% equ 0 (
    echo.
    echo [SUCCÈS] Téléchargement terminé avec succès dans le dossier "%FolderTitle%" !
) else (
    echo.
    echo [ATTENTION] Une erreur est survenue lors du téléchargement.
)

echo.
pause
