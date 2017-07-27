#!/bin/bash

main() {

  if [ -n "$JAVA_HOME" ] ; then
    if [ ! -x "$JAVA_HOME/bin/java" ] ; then
        echo "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME"
        exit 1
    fi
  else
    echo 'Gradle requires java to work, please ensure Java is installed and JAVA_HOME set correctly'
    exit 1
  fi

  if [ hash wget 2>/dev/null ] ; then
    echo 'wget is required to install gradle, install curl before this step.'
    exit 1
  fi

  if [ hash unzip 2>/dev/null ] ; then
    echo 'unzip is required, install tar before this step'
    exit 1
  fi

  if [ ! -d "/gradle" ]; then
    mkdir /gradle
    echo 'Downloading Gradle'
    wget -nv https://services.gradle.org/distributions/gradle-$WERCKER_GRADLE_VERSION-bin.zip

    echo 'Extracting gradle'
    unzip -q gradle-$WERCKER_GRADLE_VERSION-bin.zip -d /gradle
    rm gradle-$WERCKER_GRADLE_VERSION-bin.zip

  else
    if [ ! -x "/gradle/gradle-$WERCKER_GRADLE_VERSION-all/bin/gradle" ] ; then
        echo "ERROR:  gradle was not installed properly"
        exit 1
    fi
    echo 'Gradle already present'
  fi

  export PATH=$PATH:/gradle/gradle-$WERCKER_GRADLE_VERSION/bin
  gradle $WERCKER_GRADLE_COMMAND
}
main;
