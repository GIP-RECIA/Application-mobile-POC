# Application Mobile POC
## Description
ENT Mobile application.

## Structure

The project contains the three POCs used. There's `netocentre_login_poc/` which lets us test the various back-end aspects of the project (API connection, etc...), there's `netocentre_frontend_poc/` for front-end, layout and responsiveness testing. Finally, there's the `netocentre_app_poc/`, which assembles the best of both poc and gets as close as possible to the future app.

    .
    ├── netocentre_app_poc/
    ├── netocentre_frontend_poc/
    └── netocentre_login_poc/

Each POC has a classic Flutter project tree. Most of the cross-platform logic can be found in the `lib/` folder. The various configurations are in ___.yaml files___, with dependencies to be found in ___pubspec.yaml___.
<br>Front and back POCs also have their own special features. They include ___standalone tries___, the first attempts to implement the various elements of the application. These tests are disconnected from the rest of the project, hence the name “standalone”.

    .
    ├── android/
    ├── ios/
    ├── lib/
    ├── test/
    ├── pubspec.lock
    └── pubspec.yaml

## Install
Prerequisites :
- Flutter => minimal : 3.19.6 | currently : 3.22.1
- Dart => minimal & currently : 3.4.1 (integrated to the Flutter 3.19.6 SDK)

More docs here :
- [Hardware & Software requirements - Linux](https://docs.flutter.dev/get-started/install/linux/android#verify-system-requirements)
- [Download then install Flutter - Linux](https://docs.flutter.dev/get-started/install/linux/android#download-then-install-flutter)

To install the project :
- clone it
- get the dependencies of all the projects with the following command at the main POC `netocentre_app_poc` root directory.
```console
flutter pub get
```

_Optional:_
If you open and work on the project with Android Studio, you can optionally install the Flutter et Dart plugins.


## Run
To run the differents POCs :
- _Option 1 :_ use an IDE like Android Studio & run the project or standalone try entrypoint
- _Option 2 :_ run the project or standalone try entrypoint with the following command.
```console
flutter run lib/{entrypoint}.dart
```

More docs here :
- [Flutter CLI](https://docs.flutter.dev/reference/flutter-cli)
- [Flutter Test drive](https://docs.flutter.dev/get-started/test-drive)