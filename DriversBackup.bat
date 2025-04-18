@echo off
setlocal EnableDelayedExpansion

:: ================= VERIFICAR SE É ADMINISTRADOR =================
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo ===============================================
    echo Este script precisa ser executado como ADMINISTRADOR.
    echo ===============================================
    echo Clique com o botao direito no arquivo e selecione:
    echo "Executar como administrador".
    echo.
    pause
    exit /b
)

:: ================= DEFINIR TIMESTAMP E VARIAVEIS =================
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do (
    set "DD=%%a"
    set "MM=%%b"
    set "YYYY=%%c"
)
for /f "tokens=1-3 delims=:.," %%a in ("%time%") do (
    set "HH=%%a"
    set "Min=%%b"
    set "SS=%%c"
)

set "timestampFile=%YYYY%-%MM%-%DD%_%HH%%Min%%SS%"
set "scriptDir=%~dp0"
set "logFile=%scriptDir%drivers_backup_%timestampFile%.log"
set "backupDir=C:\DriversBackup"

:: Loga quando iniciou o script
echo [%date% %time%] [INFO] Inicio do script > "%logFile%"

:: ================= MENU PRINCIPAL =================
:menu
cls
echo =================================
echo   BACKUP E RESTAURACAO DE DRIVERS
echo =================================
echo script disponibilizado por Canal WINchester
echo visite www.youtube.com/WINchesterCanal
echo.
echo 1 - Fazer backup dos drivers
echo 2 - Restaurar drivers
echo 3 - Acessar tutorial
echo 0 - Sair
echo.
set /p opcao=Digite sua opcao: 

if "%opcao%"=="1" goto selecionarPasta
if "%opcao%"=="2" goto restaurarDrivers
if "%opcao%"=="3" goto abrirTutorial
if "%opcao%"=="0" goto sair

echo [%date% %time%] [ERRO] Opcao invalida: %opcao% >> "%logFile%"
echo Opcao invalida. Por favor, digite 1, 2, 3 ou 0.
timeout /t 3 >nul
goto menu

:: ================= BACKUP DOS DRIVERS =================
:selecionarPasta
echo.
set /p usarPadrao="Deseja usar a pasta padrao (%backupDir%)? [S/n]: "

echo [%date% %time%] [INFO] Opcao de uso de pasta padrao: "%usarPadrao%" >> "%logFile%"

if /i "!usarPadrao!"=="n" goto pastaPersonalizada
if /i "!usarPadrao!"=="s" goto iniciarBackup

echo Opcao invalida. Tente novamente.
goto selecionarPasta

:pastaPersonalizada
echo.
set /p backupDir="Digite o caminho completo para o backup: "
echo [%date% %time%] [INFO] Pasta definida para backup: "%backupDir%" >> "%logFile%"

if not exist "%backupDir%" (
    echo Pasta nao existe. Verificando se precisa ajustar o nome...
    
    echo %backupDir% | find " " >nul
    if !errorlevel! == 0 (
        set "backupDir=%backupDir: =_%"
        echo A pasta tinha espacos. Usando nome ajustado para: "%backupDir%"
        echo [%date% %time%] [INFO] Pasta tinha espacos. Nome ajustado para: "%backupDir%" >> "%logFile%"
    )

    echo Criando pasta: "%backupDir%"...
    echo [%date% %time%] [INFO] Criando pasta: "%backupDir%" >> "%logFile%"
    mkdir "%backupDir%" || (
        echo Falha ao criar a pasta. Verifique o caminho e tente novamente.
        echo [%date% %time%] [ERRO] Falha ao criar a pasta "%backupDir%" >> "%logFile%"
        pause
        goto pastaPersonalizada
    )
)

:iniciarBackup
echo.
echo Iniciando o backup dos drivers...
echo [%date% %time%] [INFO] Iniciando backup para: "%backupDir%" >> "%logFile%"

if not exist "%backupDir%" mkdir "%backupDir%"
dism /online /export-driver /destination:"%backupDir%"
echo Backup concluido. Os drivers foram salvos em "%backupDir%".
echo [%date% %time%] [INFO] Backup concluido em: "%backupDir%" >> "%logFile%"
pause
goto menu

:: ================= RESTAURACAO DOS DRIVERS =================
:restaurarDrivers
echo.
set /p restoreDir=Digite o caminho onde estao os drivers para restauracao: 
echo [%date% %time%] [INFO] Pasta definida para restauracao: "%restoreDir%" >> "%logFile%"

if not exist "%restoreDir%" (
    echo Caminho da pasta de restauração "%restoreDir%" invalido ou inexistente.
    echo [%date% %time%] [ERRO] Caminho de restauracao invalido: "%restoreDir%" >> "%logFile%"
    pause
    goto menu
)

echo Iniciando a restauracao dos drivers de "%restoreDir%"...
echo [%date% %time%] [INFO] Iniciando restauracao dos drivers >> "%logFile%"

for /r "%restoreDir%" %%f in (*.inf) do (
    echo Instalando driver: %%f
    echo [%date% %time%] [INFO] Instalando driver: %%f >> "%logFile%"
    pnputil /add-driver "%%f" /install
)

echo Restauracao concluida.
echo [%date% %time%] [INFO] Restauracao concluida para "%restoreDir%" >> "%logFile%"
pause
goto menu

:: ================= ABRIR TUTORIAL =================
:abrirTutorial
echo Abrindo Winchester Canal no YouTube...
start https://youtu.be/ymOwOXdzHGQ
timeout /t 3 >nul
goto menu

:: ================= SAIR =================
:sair
echo Saindo...
echo [%date% %time%] [INFO] Script encerrado pelo usuario >> "%logFile%"
exit /b
