import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/providers/home_screen_providers.dart';

class ShowTimerSwitch extends ConsumerWidget {
  const ShowTimerSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showTimer = ref.watch(showTimerProvider);
    ref.watch(showTimerProvider.notifier).setFromStorage();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Show Elapsed Time',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                )),
        const SizedBox(width: 16),
        Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            inactiveTrackColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            value: showTimer,
            onChanged: (value) => ref.read(showTimerProvider.notifier).toggleShowTimer().then((value) => null)),
      ],
    );
  }
}
