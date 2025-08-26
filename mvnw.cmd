@REM ----------------------------------------------------------------------------
@REM Maven Start Up Batch script for Windows
@REM Simplificado para o desafio (baseado no wrapper oficial 3.2.0)
@REM ----------------------------------------------------------------------------
@echo off
setlocal

set MAVEN_OPTS=%MAVEN_OPTS% -Xms128m -Xmx512m

set SCRIPT_DIR=%~dp0
set WRAPPER_JAR=%SCRIPT_DIR%.mvn\wrapper\maven-wrapper.jar
set WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain

if not exist "%WRAPPER_JAR%" (
  if not exist "%SCRIPT_DIR%.mvn\wrapper" mkdir "%SCRIPT_DIR%.mvn\wrapper" >NUL 2>&1
  powershell -Command "Invoke-WebRequest -UseBasicParsing -OutFile '%WRAPPER_JAR%' https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar" || (
    echo Falha ao baixar maven-wrapper.jar & exit /b 1
  )
)

for %%i in (java.exe) do set JAVA_EXE=%%~$PATH:i
if not defined JAVA_EXE (
  echo Java não encontrado no PATH & exit /b 1
)

set MAVEN_PROJECTBASEDIR=%SCRIPT_DIR%
set MAVEN_PROJECTBASEDIR=%MAVEN_PROJECTBASEDIR:~0,-1%

"%JAVA_EXE%" %MAVEN_OPTS% -classpath "%WRAPPER_JAR%" -Dmaven.multiModuleProjectDirectory="%MAVEN_PROJECTBASEDIR%" %WRAPPER_LAUNCHER% %*
endlocal
