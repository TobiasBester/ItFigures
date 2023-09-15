import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/constants.dart';
import 'package:it_figures/providers/home_screen_providers.dart';

class InfinitePage extends ConsumerStatefulWidget {
  const InfinitePage({super.key});

  @override
  ConsumerState createState() => _InfinitePageState();
}

class _InfinitePageState extends ConsumerState<InfinitePage> {
  @override
  Widget build(BuildContext context) {
    final String value = ref.watch(helloWorldProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text(APP_TITLE),
        ),
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
                    ]))));
  }
}
