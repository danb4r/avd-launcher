# avd-launcher

An Android AVD command-line laucher app.

`ANDROID_HOME` env var must be properly set to the Android Sdk to be found.

`USERPROFILE` env var is used as a fallback to try to find the SDK in the default installation directory.  

## download windows executable file

[x64](https://)

## build your own to any dart supported platform

```sh
dart compile exe .\bin\avd_laucher.dart -o .\bin\avdl.exe
```

## code

Entrypoint in `bin/` and library code in `lib/`. Nothing in `test/`.
