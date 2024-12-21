import 'dart:async';
import 'dart:developer';

import 'package:comfy_memo/domain/flashcard/controller/flashcard_overview_controller.dart';
import 'package:comfy_memo/domain/initialization/composition_root.dart';
import 'package:comfy_memo/view/overview/overview_screen.dart';
import 'package:comfy_memo/view/scopes/controller_scope.dart';
import 'package:comfy_memo/view/scopes/dependencies_scope.dart';
import 'package:comfy_memo/view/theme/theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  final dependencies = await CompositionRoot().compose();

  runZonedGuarded(
    () => runApp(
      DependenciesScope(
        dependencies: dependencies,
        child: const App(),
      ),
    ),
    (error, stack) {
      log('Uncaught error: $error\n$stack', name: 'Root Zone');
    },
  );
}

ColorScheme _adaptDynamicColorScheme(ColorScheme colorScheme) {
  final schemeBase = ColorScheme.fromSeed(
    seedColor: colorScheme.primary,
    brightness: colorScheme.brightness,
  );

  return schemeBase.harmonized();
}

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const themeMode = ThemeMode.system;
    final textTheme = Theme.of(context).textTheme;
    final theme = MaterialTheme(textTheme);
    final dependencies = DependenciesScope.of(context, listen: true);
    final overviewController = FlashcardOverviewController(
      flashcardRepository: dependencies.flashcardRepository,
      schedulerEntryRepository: dependencies.schedulerEntryRepository,
      preferencesRepository: dependencies.preferencesRepository,
    );
    unawaited(overviewController.fetchAll());


    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final ThemeData lightTheme;
        final ThemeData darkTheme;

        if (kDebugMode) {
          (lightDynamic, darkDynamic) = (null, null);
        }

        if (lightDynamic != null && darkDynamic != null) {
          lightTheme = theme.theme(_adaptDynamicColorScheme(lightDynamic));
          darkTheme = theme.theme(_adaptDynamicColorScheme(darkDynamic));
        } else {
          lightTheme = theme.light();
          darkTheme = theme.dark();
        }

        return ControllerScope(
          controller: overviewController,
          child: MaterialApp(
            themeMode: themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            title: 'Comfy memo',
            home: const OverviewScreen(),
          ),

        );
      },
    );
  }
}
