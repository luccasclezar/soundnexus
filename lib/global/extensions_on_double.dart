import 'dart:math';

extension ExtensionsOnDouble on double {
  double toFixed(int places) {
    final valueForPlace = pow(10, places);
    return (this * valueForPlace).round() / valueForPlace;
  }
}
