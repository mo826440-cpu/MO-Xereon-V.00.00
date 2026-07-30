@echo off
chcp 65001 >nul
setlocal EnableExtensions

REM ============================================================
REM  ACTUALIZAR GITHUB - Xereon (MO-Xereon-V.00.00)
REM
REM  1) Editá solo la variable COMMIT de abajo.
REM  2) Guardá este archivo.
REM  3) Hacé doble clic para: git add + commit + push.
REM ============================================================

set "COMMIT=Agrega icono de descarga local en Login y referencia a descarga_local.md"

REM ============================================================
REM  (Opcional) Identidad de Git solo para este commit.
REM  Si ya configuraste git user.name / user.email, podés borrar
REM  estas 4 líneas.
REM ============================================================
set "GIT_AUTHOR_NAME=mo826440-cpu"
set "GIT_AUTHOR_EMAIL=236918057+mo826440-cpu@users.noreply.github.com"
set "GIT_COMMITTER_NAME=mo826440-cpu"
set "GIT_COMMITTER_EMAIL=236918057+mo826440-cpu@users.noreply.github.com"

REM Ir a la carpeta donde está este .bat (raíz del proyecto)
cd /d "%~dp0"

echo.
echo ========================================
echo   Xereon - Actualizar GitHub
echo ========================================
echo.
echo Mensaje de commit:
echo   %COMMIT%
echo.
echo Carpeta:
echo   %CD%
echo.

if "%COMMIT%"=="" (
  echo [ERROR] La variable COMMIT esta vacia. Edita este archivo y escribe un mensaje.
  goto :fin
)

where git >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Git no esta instalado o no esta en el PATH.
  goto :fin
)

echo [1/3] Agregando cambios...
git add -A
if errorlevel 1 (
  echo [ERROR] Fallo git add.
  goto :fin
)

git diff --cached --quiet
if %errorlevel%==0 (
  echo [INFO] No hay cambios para commitear.
  echo [INFO] Intentando push por si quedo algo pendiente...
  goto :push
)

echo [2/3] Creando commit...
git commit -m "%COMMIT%"
if errorlevel 1 (
  echo [ERROR] Fallo git commit.
  goto :fin
)

:push
echo [3/3] Enviando a GitHub...
git push origin HEAD
if errorlevel 1 (
  echo [ERROR] Fallo git push. Revisá conexion, permisos o rama remota.
  goto :fin
)

echo.
echo [OK] Listo. GitHub actualizado.
echo Repo: https://github.com/mo826440-cpu/MO-Xereon-V.00.00

:fin
echo.
echo ========================================
pause
endlocal
