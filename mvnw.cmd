@ECHO OFF
setlocal
set MAVEN_OPTS=%MAVEN_OPTS% -Xms128m -Xmx512m

set SCRIPT_DIR=%~dp0
set WRAPPER_JAR="%SCRIPT_DIR%.mvn\wrapper\maven-wrapper.jar"
set WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain

if exist %WRAPPER_JAR% (
  set DOWNLOAD=F
) else (
  set DOWNLOAD=T
)

if %DOWNLOAD%==T (
  powershell -Command "Invoke-WebRequest -OutFile %WRAPPER_JAR% https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar"
)

set JAVA_EXE=java.exe

%JAVA_EXE% %MAVEN_OPTS% -classpath %WRAPPER_JAR% %WRAPPER_LAUNCHER% %*
