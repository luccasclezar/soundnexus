import 'dart:io';

import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:soundnexus/features/project/presentation/project_page.dart';
import 'package:soundnexus/features/projects/data/projects_repository.dart';
import 'package:soundnexus/features/projects/presentation/projects_page.dart';
import 'package:soundnexus/global/app_platform.dart';
import 'package:soundnexus/global/desktop_mouse_tracker.dart';
import 'package:soundnexus/global/globals.dart';

Future<void> main() async {
  await GetStorage.init();

  GetIt.I.registerSingleton<ProjectsRepository>(
    LocalProjectsRepository(),
    dispose: (param) => param.dispose(),
  );

  runApp(const ProviderScope(child: SoundNexusApp()));
}

class SoundNexusApp extends StatefulWidget {
  const SoundNexusApp({super.key});

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
  State<SoundNexusApp> createState() => _SoundNexusAppState();
}

class _SoundNexusAppState extends State<SoundNexusApp> {
  static final GoRouter _router = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => ProjectsPage(),
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

  @override
  void initState() {
    super.initState();

    // On macOS the pointer shouldn't change to 'clickable' when hovering
    // buttons. Overriding MouseTracker is the workaround.
    if (AppPlatform.isDekstop && !kIsWeb) {
      // ignore: invalid_use_of_visible_for_testing_member
      RendererBinding.instance.initMouseTracker(DesktopMouseTracker());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SoundNexus',
      theme: SoundNexusApp.createTheme(Colors.indigo),
      scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
      routerConfig: _router,
      builder: (context, child) => Listener(
        onPointerDown: (event) {
          // Handle mouse back button. Don't pop if web, as the
          // browser pops automatically.
          if (event.buttons == kBackMouseButton && !kIsWeb) {
            navigatorContext.pop();
            return;
          }
        },
        // Add a top padding on macOS as the titlebar was removed.
        child: Platform.isMacOS && !kIsWeb
            ? MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  padding: const EdgeInsets.only(top: 30),
                ),
                child: child!,
              )
            : child,
      ),
    );
  }
}
