# Wercker-gradle

This Wercker step will install Gradle and run a build task for you.  Downloading Gradle means that you do not need to have it installed in your box/image, and it will not be included in the image you push at the end of your pipeline - thereby helping to keep your image size as small as possible. 

If you specify the `cache_project_cache: true` parameter, your Gradle project cache will be placed inside the Wercker cache directory, meaning itwill still be available in subsequent builds, so you will not need to download dependencies, plugins, etc., in every build.

## Requirements

The box that you run this step in must have `curl` and `unzip` installed.  You can install in the in a `script` step if they are not in your image.  

The box must have a JDK installed, as required by Gradle.

## Usage

To use the step, include it in your `wercker.yml` as in the example below:

```yaml
build:
  steps:
    - java/gradle:
        task: build
        version: 4.0.1
        cache_project_cache: true
```

## Parameters

All paramaters are optional unless otherwise specified.

* `task` (required)
<br>The gradle task(s) to run.

* `version`
<br>Specify the version of Gradle that you want to use.  If not specified, defaults to `4.2`.

* `build_file`
<br>Specify the name of the build file, defaults to `build.gradle`.

* `debug`
<br>If set to `true`, will run Gradle in debug mode. 

* `cache_project_cache`
<br>If set to `true`, the Gradle project cache directory (usually `<PROJECT_ROOT>/.gradle`) will be placed inside the Wercker cache directory so that it will be available for future executions of the Wercker build (unless the cache is cleared).

* `init_script`
<br>Specify the filename of the Gradle init script that you wish to run. 

* `system_props`
<br>Provide a space-separated list of system properties that you wish to set during the Gradle build.  Specify properties in the format `name=value`.

* `settings_file`
<br>The filename of the Gradle settings file you wish to use.

* `gradle_opts` 
<br>Specify a value that you want set as `GRADLE_OPTS` during the Gradle build. 


## Sample Application

A sample application is provided at [https://github.com/markxnelson/sample-gradle-step](https://github.com/markxnelson/sample-gradle-step) that demonstrates how to use this step. 
