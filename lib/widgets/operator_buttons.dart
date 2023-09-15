import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/models/operator_model.dart';
import 'package:it_figures/responsive_utils.dart';
import 'package:it_figures/widgets/operator_button.dart';
import 'package:responsive_grid/responsive_grid.dart';

class OperatorButtons extends ConsumerWidget {
  const OperatorButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        borderOnForeground: true,
        child: Container(
          alignment: Alignment.center,
          child: ResponsiveGridRow(
            children: Operator.values
                .map((o) => ResponsiveGridCol(
                    xs: 6,
                    md: 3,
                    child: Padding(
                        padding: _getPadding(context), child: OperatorButton(operator: o))))
                .toList(),
          ),
        ));
  }
}

EdgeInsetsGeometry _getPadding(BuildContext context) {
  return ResponsiveUtils.largeSmall(
      context,
      const EdgeInsets.all(8.0),
      const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0));
}
