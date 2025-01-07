import 'dart:io';

class AppPlatform {
  AppPlatform._();

  static bool get isDekstop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}
