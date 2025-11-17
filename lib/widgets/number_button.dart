import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/models/operand_model.dart';
import 'package:it_figures/providers/number_providers.dart';
import 'package:it_figures/responsive_utils.dart';
import 'package:it_figures/widgets/solution_dialog.dart';

class NumberButton extends ConsumerWidget {
  final Operand operand;

  const NumberButton({super.key, required this.operand});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isSelected = ref.watch(operationSelectionProvider).operand1 == operand;
    bool isHidden = operand.hidden;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: OutlinedButton(
            onPressed: isHidden ? null : () => _onPressed(context, ref, operand),
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
              minimumSize: MaterialStateProperty.all(_getButtonSize(context)),
              side: MaterialStateProperty.all(
                  BorderSide(width: 2, color: _getOutlineColor(context, isSelected, isHidden))),
            ),
            child: Text(
              operand.value.toString(),
              style: _getButtonTextStyle(context, isSelected, isHidden),
            )));
  }
}

Color _getOutlineColor(BuildContext context, bool isSelected, bool isHidden) {
  if (isHidden) {
    return Theme.of(context).colorScheme.onSurface.withOpacity(0.3);
  }
  if (isSelected) {
    return Theme.of(context).colorScheme.tertiary;
  }

  return Theme.of(context).colorScheme.onSurface;
}

void _onPressed(BuildContext context, WidgetRef ref, Operand operand) {
  ref.read(operationSelectionProvider.notifier).setNextOperand(operand);
  addResult(context, ref);
}

void addResult(BuildContext context, WidgetRef ref) {
  final OperationResult? result = ref.read(operationSelectionProvider).result;
  if (result != null) {
    checkIfSolved(context, ref);
    ref.read(operationResultsProvider.notifier).addResult(result);

    // Find the operand that now contains the result (operand2 from the operation)
    final operands = ref.read(operandNumbersProvider);
    final resultOperand = operands.firstWhere((op) => op.id == result.operand2Id);

    // Auto-select the result operand as operand1 for the next operation
    ref.read(operationSelectionProvider.notifier).reset();
    ref.read(operationSelectionProvider.notifier).setNextOperand(resultOperand);
  }
}

void checkIfSolved(BuildContext context, WidgetRef ref) {
  final OperationResult result = ref.read(operationSelectionProvider).result!;
  final int totalTarget = ref.read(totalTargetProvider);
  if (result.result == totalTarget) {
    showDialog(context: context, builder: (BuildContext ctx) => const SolutionDialog(ownSolution: true));
  }
}

Size _getButtonSize(BuildContext context) {
  return ResponsiveUtils.largeSmall(context, const Size(50, 100), const Size(50, 50));
}

TextStyle _getButtonTextStyle(BuildContext context, bool isSelected, bool isHidden) {
  return ResponsiveUtils.largeSmall(
          context, Theme.of(context).textTheme.headlineMedium!, Theme.of(context).textTheme.headlineSmall!)
      .copyWith(color: _getOutlineColor(context, isSelected, isHidden));
}
