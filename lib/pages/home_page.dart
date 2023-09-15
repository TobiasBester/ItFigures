import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/constants.dart';
import 'package:it_figures/widgets/home_page_button.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(APP_TITLE,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              )),
                      Text(APP_SUBTITLE,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              )),
                      Center(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HomePageButton(onPressed: () => {
                                  Navigator.pushNamed(context, '/daily')
                                }, text: 'Daily'),
                                const SizedBox(height: 16),
                                HomePageButton(onPressed: () => {
                                  Navigator.pushNamed(context, '/timed')
                                }, text: 'Timed'),
                                const SizedBox(height: 16),
                                HomePageButton(onPressed: () => {
                                  Navigator.pushNamed(context, '/infinite')
                                }, text: 'Infinite'),
                              ],
                            )),
                      ),
                      Text(APP_INSTRUCTIONS,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          )),
                    ]))));
  }
}
