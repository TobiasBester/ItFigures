import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/constants.dart';
import 'package:it_figures/providers/number_providers.dart';
import 'package:it_figures/responsive_utils.dart';
import 'package:it_figures/widgets/solution_dialog.dart';

class OverviewPanel extends ConsumerWidget {
  const OverviewPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
        height: ResponsiveUtils.largeSmall(context, 240, 100),
        width: ResponsiveUtils.largeSmall(context, 480, 320),
        child: Column(
          mainAxisAlignment:
              ResponsiveUtils.largeSmall(context, MainAxisAlignment.spaceAround, MainAxisAlignment.spaceBetween),
          children: [
            Flexible(child: levelSelectRow(context, ref)),
            Flexible(flex: 2, child: targetText(context, ref)),
            Flexible(child: actionButtons(context, ref))
          ],
        ));
  }
}

Widget levelSelectRow(BuildContext context, WidgetRef ref) {
  int currentLevel = ref.read(difficultyLevelProvider);
  // TODO: Make text buttons which change difficulty
  return Card(
    color: Theme.of(context).colorScheme.secondary,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(NUM_LEVELS, (i) => levelButton(context, i, currentLevel)),
    ),
  );
}

Text levelButton(BuildContext context, int level, int currentLevel) {
  final sizedTextStyle = ResponsiveUtils.largeSmall(
      context, Theme.of(context).textTheme.headlineMedium!, Theme.of(context).textTheme.bodyLarge!);

  int text = level + 1;
  return Text(
    text.toString(),
    style: sizedTextStyle.copyWith(
      color: level == currentLevel
          ? Theme.of(context).colorScheme.onSecondary
          : Theme.of(context).colorScheme.onSecondary.withOpacity(0.5),
      decoration: level == currentLevel ? TextDecoration.underline : TextDecoration.none,
      decorationColor: Theme.of(context).colorScheme.primary,
    ),
  );
}

Widget actionButtons(BuildContext context, WidgetRef ref) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      FilledButton(
          onPressed: () => _solution(context, ref),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.tertiary),
          ),
          child: Text('Solution',
              style: panelButtonStyles(context).copyWith(
                color: Theme.of(context).colorScheme.onTertiary,
              ))),
      FilledButton(
          onPressed: () => _reset(ref),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.error),
          ),
          child: Text('Reset', style: panelButtonStyles(context))),
      OutlinedButton(
          onPressed: () => _undo(ref),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
          ),
          child: Text('Undo',
              style: panelButtonStyles(context).copyWith(
                color: Theme.of(context).colorScheme.onTertiary,
              ))),
    ],
  );
}

void _solution(BuildContext context, WidgetRef ref) {
  showDialog(context: context, builder: (BuildContext ctx) => const SolutionDialog(ownSolution: false));
}

void _reset(WidgetRef ref) {
  ref.read(operandNumbersProvider.notifier).reset();
  ref.read(operationResultsProvider.notifier).reset();
  ref.read(operationSelectionProvider.notifier).reset();
}

void _undo(WidgetRef ref) {
  final results = ref.read(operationResultsProvider);
  if (results.isNotEmpty) {
    final lastResult = results.last;
    ref.read(operandNumbersProvider.notifier).undoOperation(lastResult.operand1Id, lastResult.operand2Id);
    ref.read(operationResultsProvider.notifier).removeLastResult();
  }
}

Widget targetText(BuildContext context, WidgetRef ref) {
  int totalTarget = ref.read(totalTargetProvider);
  String text =
      ResponsiveUtils.largeSmall(context, 'Target 🎯: ${totalTarget.toString()}', '🎯: ${totalTarget.toString()}');

  final TextStyle? textStyle = ResponsiveUtils.largeSmall(
      context, Theme.of(context).textTheme.displayMedium, Theme.of(context).textTheme.headlineSmall);

  return Text(text,
      style: textStyle?.copyWith(
        color: Theme.of(context).colorScheme.onBackground,
      ));
}

TextStyle panelButtonStyles(BuildContext context) {
  return ResponsiveUtils.largeSmall(
      context, Theme.of(context).textTheme.bodyLarge!, Theme.of(context).textTheme.bodyMedium!);
}
