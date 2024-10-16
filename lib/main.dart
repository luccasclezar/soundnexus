import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:soundnexus/features/project/presentation/project_page.dart';
import 'package:soundnexus/features/projects/presentation/projects_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
BuildContext get navigatorContext => navigatorKey.currentContext!;

Future<void> main() async {
  await GetStorage.init();

  runApp(const ProviderScope(child: SoundNexusApp()));
}

class SoundNexusApp extends StatelessWidget {
  const SoundNexusApp({super.key});

  static GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ProjectsPage(),
        routes: [
          GoRoute(
            path: 'project/:projectId',
            builder: (context, state) => ProjectPage(
              projectId: state.pathParameters['projectId']!,
            ),
          ),
        ],
      ),
    ],
  );

  static ThemeData createTheme(Color seed, [Brightness? brightness]) {
    const primaryChroma = 64.0;
    const secondaryChroma = 16.0;
    const tertiaryChroma = 32.0;

    brightness ??= Brightness.dark;

    return ThemeData.localize(
      ThemeData(
        brightness: brightness,
        colorScheme: SeedColorScheme.fromSeeds(
          brightness: brightness,
          primaryKey: seed,
          tones: brightness == Brightness.light
              ? const FlexTones.light(
                  primaryChroma: primaryChroma,
                  secondaryChroma: secondaryChroma,
                  tertiaryChroma: tertiaryChroma,
                  useCam16: false,
                )
              : const FlexTones.dark(
                  primaryChroma: primaryChroma,
                  secondaryChroma: secondaryChroma,
                  tertiaryChroma: tertiaryChroma,
                  useCam16: false,
                ),
        ),
      ),

      // See #1841 and #1908 before changing.
      Typography.englishLike2021,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SoundNexus',
      theme: createTheme(Colors.indigo),
      routerConfig: router,
      builder: (context, child) => Listener(
        onPointerDown: (event) {
          // Handle mouse back button. Don't pop if web, as the
          // browser pops automatically.
          if (event.buttons == kBackMouseButton && !kIsWeb) {
            navigatorContext.pop();
            return;
          }
        },
        child: child,
      ),
    );
  }
}
