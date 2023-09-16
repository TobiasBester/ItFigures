import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/constants.dart';
import 'package:it_figures/providers/game_providers.dart';
import 'package:it_figures/responsive_utils.dart';
import 'package:it_figures/services/game_management.dart';

class SolutionDialog extends ConsumerWidget {
  final bool ownSolution;

  const SolutionDialog({super.key, this.ownSolution = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        title: headerText(context, ownSolution ? 'You did it!' : 'Solution'),
        content: Container(
            padding: const EdgeInsets.all(8),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Solution here'), // TODO
                    const SizedBox(height: 32),
                    actionButtons(context, ref),
                    const SizedBox(height: 16),
                    baseButton(context, 'Close', false, () => Navigator.of(context).pop())
                  ],
                ))));
  }
}

Widget actionButtons(BuildContext context, WidgetRef ref) {
  List<Widget> buttons = [
    baseButton(context, 'Share', true, null), // TODO
    const SizedBox(width: 16, height: 8),
  ];

  bool isInfinite = ref.read(gameTypeProvider) == GameType.infinite;
  if (isInfinite) {
    buttons.addAll([
      baseButton(context, 'Another One', true, () {
        anotherOne(ref);
        Navigator.of(context).pop();
      }),
      const SizedBox(width: 16, height: 8)
    ]);
  }

  if (ref.read(difficultyLevelProvider) < NUM_LEVELS - 1) {
    buttons.add(baseButton(context, 'Next Level', true, () {
      toNextLevel(ref);
      Navigator.of(context).pop();
    }));
  }

  Widget container = ResponsiveUtils.largeSmall(
      context,
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: buttons),
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: buttons));

  return container;
}

void toNextLevel(WidgetRef ref) {
  int currentLevel = ref.read(difficultyLevelProvider);
  updateLevel(ref, currentLevel + 1);
}

void anotherOne(WidgetRef ref) {
  int currentLevel = ref.read(difficultyLevelProvider);
  updateLevel(ref, currentLevel);
}

Text headerText(BuildContext context, String text) {
  return Text(
    text,
    style: Theme.of(context).textTheme.headlineMedium,
  );
}

OutlinedButton baseButton(BuildContext context, String text, bool useTertiary, void Function()? onPressed) {
  final color = useTertiary ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onPrimary;

  return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(side: MaterialStateProperty.all(BorderSide(width: 2, color: color))),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: color)));
}
