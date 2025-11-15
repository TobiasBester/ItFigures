import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/constants.dart' as constants;
import 'package:it_figures/pages/home_page.dart';
import 'package:it_figures/routes.dart';
import 'package:it_figures/theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    )
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: constants.APP_TITLE,
      theme: itFiguresThemeData,
      color: Theme.of(context).colorScheme.primary,
      routes: itFiguresRoutes,
      home: const HomePage(),
      // home: const MyHomePage(title: constants.APP_TITLE),
    );
  }
}
