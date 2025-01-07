import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
BuildContext get navigatorContext => navigatorKey.currentContext!;

GetIt get getIt => GetIt.instance;
