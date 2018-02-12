#!/bin/bash

# Copyright 2017, 2018, Oracle and/or its affiliates. All rights reserved.

echo "$(date +%H:%M:%S):  Hello from the Gradle Wercker Step"
echo "For information on how to use this step, please review the documentation in the Wercker Marketplace,"
echo "or visit https://github.com/wercker/step-gradle"

# check that all of the required parameters were provided
# note that wercker does not enforce this for us, so we have to check
if [[ -z "$WERCKER_GRADLE_TASK" ]]; then
  fail "$(date +%H:%M:%S): All required parameters: task MUST be specified"
fi

#
# check if a specific version of gradle was requested, otherwise use the latest one we have tested with
#
if [[ -z "$WERCKER_GRADLE_VERSION" ]]; then
  WERCKER_GRADLE_VERSION="4.2"
fi
echo "$(date +%H:%M:%S): Gradle version is $WERCKER_GRADLE_VERSION"

#
# check if we have everything we need to run Gradle
#

if [ -n "$JAVA_HOME" ] ; then
  if [ ! -x "$JAVA_HOME/bin/java" ] ; then
      fail "$(date +%H:%M:%S): ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME"
  fi
else
  fail "$(date +%H:%M:%S):  Gradle requires java to work, please ensure Java is installed and JAVA_HOME set correctly"
fi

# check that curl is installed
hash curl 2>/dev/null || { echo "$(date +%H:%M:%S):  curl is required to install gradle, install curl before this step."; exit 1; }

# check unzip is installed
hash unzip 2>/dev/null || { echo "$(date +%H:%M:%S):  unzip is required, install tar before this step"; exit 1; }

if [ ! -d "/gradle" ]; then
  mkdir /gradle
  echo "$(date +%H:%M:%S):  Downloading Gradle"
  curl -O -L https://services.gradle.org/distributions/gradle-$WERCKER_GRADLE_VERSION-bin.zip

  echo "$(date +%H:%M:%S):  Extracting gradle"
  unzip -q gradle-$WERCKER_GRADLE_VERSION-bin.zip -d /gradle
  rm gradle-$WERCKER_GRADLE_VERSION-bin.zip

else
  if [ ! -x "/gradle/gradle-$WERCKER_GRADLE_VERSION-all/bin/gradle" ] ; then
      fail "$(date +%H:%M:%S):  ERROR:  gradle was not installed properly"
  fi
  echo "$(date +%H:%M:%S):  Gradle already present"
fi

#
# prepare gradle command
#

if [ "$WERCKER_GRADLE_DEBUG" = "true" ]; then
  DEBUG="--debug"
else
  DEBUG=""
fi

if [[ -z "$WERCKER_GRADLE_BUILD_FILE" ]]; then
  BUILD_FILE=""
else
  BUILD_FILE="-b $WERCKER_GRADLE_BUILD_FILE"
fi

if [[ -z "$WERCKER_GRADLE_SETTINGS_FILE" ]]; then
  SETTINGS_FILE=""
else
  SETTINGS_FILE="-c $WERCKER_GRADLE_SETTINGS_FILE"
fi

if [[ -z "$WERCKER_GRADLE_SYSTEM_PROPS" ]]; then
  SYSTEM_PROPS=""
else
  SYSTEM_PROPS=""
  for property in $WERCKER_GRADLE_SYSTEM_PROPS
  do
    SYSTEM_PROPS="$SYSTEM_PROPS -D$property"
  done
fi

if [[ -z "$WERCKER_GRADLE_INIT_SCRIPT" ]]; then
  INIT_SCRIPT=""
else
  INIT_SCRIPT="-I $WERCKER_GRADLE_INIT_SCRIPT"
fi

if [[ -z "$WERCKER_GRADLE_PROFILES" ]]; then
  PROFILES=""
else
  PROFILES="-I $WERCKER_GRADLE_PROFILES"
fi


if [ "$WERCKER_GRADLE_CACHE_PROJECT_CACHE" = "true" ]; then
  CACHE_DIR="--project-cache-dir=$WERCKER_CACHE_DIR/.gradle"
else
  CACHE_DIR=""
fi

# set the GRADLE_OPTS
export GRADLE_OPTS="$WERCKER_GRADLE_GRADLE_OPTS"

#
# run gradle
#
export PATH=$PATH:/gradle/gradle-$WERCKER_GRADLE_VERSION/bin
GRADLE_CMD="gradle $BUILD_FILE $SETTINGS_FILE --console=plain $SYSTEM_PROPS $DEBUG $INIT_SCRIPT $CACHE_DIR --stacktrace --no-daemon $WERCKER_GRADLE_TASK"
echo "$(date +%H:%M:%S): Running Gradle with command:"
echo $GRADLE_CMD
$GRADLE_CMD


