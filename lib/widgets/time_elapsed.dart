import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/game_providers.dart';

class ElapsedTime extends ConsumerWidget {
  const ElapsedTime({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopwatch = ref.watch(elapsedTimeProvider);

    return Text(ref.watch(elapsedTimeProvider.notifier).elapsedDuration,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ));
  }
}
