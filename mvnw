#!/bin/sh
MAVEN_OPTS="$MAVEN_OPTS -Xms128m -Xmx512m"
SCRIPT_DIR="$(dirname "$0")/"
WRAPPER_JAR="${SCRIPT_DIR}.mvn/wrapper/maven-wrapper.jar"
WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain
if [ ! -f "$WRAPPER_JAR" ]; then
  mkdir -p "${SCRIPT_DIR}.mvn/wrapper" 2>/dev/null
  curl -fsSL -o "$WRAPPER_JAR" https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar
fi
exec java $MAVEN_OPTS -classpath "$WRAPPER_JAR" $WRAPPER_LAUNCHER "$@"
