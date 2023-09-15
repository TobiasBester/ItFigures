import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/models/operator_model.dart';
import 'package:it_figures/providers/number_providers.dart';
import 'package:it_figures/responsive_utils.dart';

class OperatorButton extends ConsumerWidget {
  final Operator operator;

  const OperatorButton({super.key, required this.operator});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isSelected = ref.watch(operationSelectionProvider).operator == operator;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedButton(
            onPressed: () => _onPressed(ref, operator),
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
              minimumSize: MaterialStateProperty.all(_getButtonSize(context)),
              side: MaterialStateProperty.all(BorderSide(width: 2, color: _getOutlineColor(context, isSelected))),
            ),
            child: Text(
              operator.standaloneText,
              style: _getButtonTextStyle(context, isSelected),
            )));
  }
}

Color _getOutlineColor(BuildContext context, bool isSelected) {
  return isSelected ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onSurface;
}

void _onPressed(WidgetRef ref, Operator operator) {
  ref.read(operationSelectionProvider.notifier).setOperator(operator);
}

Size _getButtonSize(BuildContext context) {
  return ResponsiveUtils.largeSmall(context, const Size(50, 100), const Size(50, 50));
}

TextStyle _getButtonTextStyle(BuildContext context, bool isSelected) {
  return ResponsiveUtils.largeSmall(
          context, Theme.of(context).textTheme.displayLarge!, Theme.of(context).textTheme.headlineMedium!)
      .copyWith(color: _getOutlineColor(context, isSelected));
}
