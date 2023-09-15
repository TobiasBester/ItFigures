import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/models/operand_model.dart';
import 'package:it_figures/models/operation_selection.dart';
import 'package:it_figures/providers/number_providers.dart';
import 'package:it_figures/responsive_utils.dart';
import 'package:it_figures/services/number_generator.dart';
import 'package:responsive_grid/responsive_grid.dart';

class TallyBoard extends ConsumerWidget {
  const TallyBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<OperationResult> results = ref.watch(operationResultsProvider);
    OperationSelection selection = ref.watch(operationSelectionProvider);
    String? error = selection.error;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: getPadding(context),
        child: ResponsiveGridRow(crossAxisAlignment: CrossAxisAlignment.center, children: columns(context, results, error)),
      ),
    );
  }
}

List<ResponsiveGridCol> columns(BuildContext context, List<OperationResult> results, String? error) {
  List<ResponsiveGridCol> result = [];

  if (error != null) {
    result.add(ResponsiveGridCol(xs: 12, child: errorText(context, error)));
  }

  result.addAll(
      results.map((operationResult) => ResponsiveGridCol(xs: 6, child: resultText(context, operationResult))).toList());

  while (result.length < NumberGenerator.NUM_INITIAL_OPERANDS - 1) {
    result.add(ResponsiveGridCol(
        xs: 6, child: Text('--', textAlign: TextAlign.center, style: baseText(context).copyWith(color: Theme.of(context).colorScheme.onSecondary))));
  }

  return result;
}

Text errorText(BuildContext context, String error) {
  return Text(error,
      textAlign: TextAlign.center, style: baseText(context).copyWith(color: Theme.of(context).colorScheme.error));
}

Padding resultText(BuildContext context, OperationResult result) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child:
          Text(result.toString(), textAlign: TextAlign.center, style: baseText(context).copyWith(color: Theme.of(context).colorScheme.onSecondary)));
}

TextStyle baseText(BuildContext context) {
  return ResponsiveUtils.largeSmall(
      context, Theme.of(context).textTheme.headlineSmall!, Theme.of(context).textTheme.bodyLarge!);
}

EdgeInsets getPadding(BuildContext context) {
  return ResponsiveUtils.largeSmall(
      context, const EdgeInsets.symmetric(vertical: 32, horizontal: 4), const EdgeInsets.symmetric(vertical: 8, horizontal: 4));
}
