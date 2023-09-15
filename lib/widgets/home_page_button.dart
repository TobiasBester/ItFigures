import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePageButton extends ConsumerWidget {
  final void Function () onPressed;
  final String text;

  const HomePageButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(200, 50)),
          textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.bodyLarge),
        ),
        onPressed: onPressed,
        child: Text(text));
  }
}
