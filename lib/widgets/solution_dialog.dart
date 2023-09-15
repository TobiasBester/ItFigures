import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

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
                    const Text('Solution here'),  // TODO
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        baseButton(context, 'Next Level', true, null), // TODO
                        baseButton(context, 'Share', true, null) // TODO
                      ],
                    ),
                    const SizedBox(height: 16),
                    baseButton(context, 'Close', false, () => Navigator.of(context).pop())
                  ],
                ))));
  }
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
