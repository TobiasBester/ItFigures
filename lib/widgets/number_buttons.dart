import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/models/operand_model.dart';
import 'package:it_figures/responsive_utils.dart';
import 'package:it_figures/widgets/number_button.dart';
import 'package:responsive_grid/responsive_grid.dart';

class NumberButtons extends ConsumerWidget {
  const NumberButtons(this.numbers, {super.key});

  final List<Operand> numbers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Card(
        borderOnForeground: true,
        child: Container(
          alignment: Alignment.center,
          child: ResponsiveGridRow(
            children: numbers
                .map((n) => ResponsiveGridCol(
                    xs: 4,
                    child: Padding(
                        padding: _getPadding(context), child: NumberButton(operand: n))))
                .toList(),
          ),
        ));
  }
}

EdgeInsetsGeometry _getPadding(BuildContext context) {
  return ResponsiveUtils.largeSmall(
      context, const EdgeInsets.all(4.0), const EdgeInsets.symmetric(vertical: 0, horizontal: 2.0));
}
