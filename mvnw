#!/bin/sh
set -e
MAVEN_OPTS="${MAVEN_OPTS} -Xms128m -Xmx512m"
PRG="$0"
while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
SCRIPT_DIR=`dirname "$PRG"`
BASEDIR=`cd "$SCRIPT_DIR" >/dev/null 2>&1 && pwd`
WRAPPER_JAR="$BASEDIR/.mvn/wrapper/maven-wrapper.jar"
WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain
if [ ! -f "$WRAPPER_JAR" ]; then
  mkdir -p "$BASEDIR/.mvn/wrapper" 2>/dev/null || true
  curl -fsSL -o "$WRAPPER_JAR" https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar
fi
exec java $MAVEN_OPTS -classpath "$WRAPPER_JAR" -Dmaven.multiModuleProjectDirectory="$BASEDIR" $WRAPPER_LAUNCHER "$@"
