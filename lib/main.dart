import 'dart:async';
import 'dart:developer';

import 'package:comfy_memo/src/common/bloc_scope.dart';
import 'package:comfy_memo/src/common/composition_root.dart';
import 'package:comfy_memo/src/common/constants.dart';
import 'package:comfy_memo/src/common/dependencies_scope.dart';
import 'package:comfy_memo/src/presentation/main_list/main_list_screen.dart';
import 'package:comfy_memo/src/presentation/theme/theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  final dependencies = await CompositionRoot().compose();

  runZonedGuarded(
    () => runApp(
      DependenciesScope(
        dependencies: dependencies,
        child: const BlocScope(child: App()),
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

        return MaterialApp(
          themeMode: themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          title: Constants.appName,
          home: const MainListScreen(),
        );
      },
    );
  }
}
