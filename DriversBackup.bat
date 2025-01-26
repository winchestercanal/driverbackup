@echo off
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
echo.
set /p opcao=Digite sua opcao: 

if "%opcao%"=="1" (
    echo.
    echo Criando pasta de backup...
    if not exist "C:\DriversBackup" mkdir "C:\DriversBackup"
    echo.
    echo Iniciando o backup dos drivers...
    dism /online /export-driver /destination:C:\DriversBackup
    echo.
    echo Backup concluido! Os drivers foram salvos em C:\DriversBackup
    echo visite www.youtube.com/WINchesterCanal para mais dicas!
    pause
    goto menu
)

if "%opcao%"=="2" (
    echo.
    set /p caminho=Digite o caminho onde estao os drivers para restauracao: 
    echo.
    echo Iniciando a restauracao dos drivers de %caminho%...
    dism /online /add-driver /driver:%caminho% /recurse
    echo.
    echo Restauracao concluida!
    pause
    goto menu
)

if "%opcao%"=="3" (
    echo.
    echo Abrindo Winchester Canal no YouTube...
    start https://youtube.com/winchestercanal
    timeout /t 3
    goto menu
)

echo.
echo Opcao invalida! Por favor, digite 1 ou 2.
timeout /t 3
goto menu
