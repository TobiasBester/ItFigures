import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/constants.dart';
import 'package:it_figures/providers/game_providers.dart';
import 'package:it_figures/responsive_utils.dart';
import 'package:it_figures/services/game_management.dart';

class LevelSelect extends ConsumerWidget {
  const LevelSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentLevel = ref.watch(difficultyLevelProvider);

    return Card(
      color: Theme.of(context).colorScheme.tertiary,
      margin: const EdgeInsets.all(0),
      child: SegmentedButton(
        key: const Key('levelSelect'),
        segments: levelSegments(context, ref, currentLevel),
        selected: {currentLevel},
        showSelectedIcon: false,
        onSelectionChanged: (selection) {
          updateLevelSelect(ref, selection.first).then((value) => null);
        },
      ),
    );
  }

  Future<void> updateLevelSelect(WidgetRef ref, int newLevel) {
    return updateLevel(ref, newLevel);
  }

  List<ButtonSegment> levelSegments(BuildContext context, WidgetRef ref, int currentLevel) {
    return List.generate(NUM_LEVELS, (index) => levelSegment(context, ref, index, index == currentLevel));
  }

  ButtonSegment levelSegment(BuildContext context, WidgetRef ref, int level, bool isCurrentLevel) {
    final sizedTextStyle = ResponsiveUtils.largeSmall(
        context, Theme.of(context).textTheme.bodyLarge!, Theme.of(context).textTheme.bodyMedium!);

    final boldTextStyle = sizedTextStyle.copyWith(fontWeight: isCurrentLevel ? FontWeight.w900 : FontWeight.w100);

    int text = level + 1;
    return ButtonSegment(
        value: level,
        label: Text(text.toString(), style: boldTextStyle.copyWith(color: Theme.of(context).colorScheme.onTertiary)));
  }
}
