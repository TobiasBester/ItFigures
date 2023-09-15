import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/constants.dart';
import 'package:it_figures/models/operand_model.dart';
import 'package:it_figures/providers/number_providers.dart';
import 'package:it_figures/responsive_utils.dart';
import 'package:it_figures/widgets/number_buttons.dart';
import 'package:it_figures/widgets/operator_buttons.dart';
import 'package:it_figures/widgets/overview_panel.dart';
import 'package:it_figures/widgets/tally_board.dart';

class DailyPage extends ConsumerStatefulWidget {
  const DailyPage({super.key});

  @override
  ConsumerState createState() => _DailyPageState();
}

class _DailyPageState extends ConsumerState<DailyPage> {
  @override
  void initState() {
    super.initState();
    ref.read(operandNumbersProvider);
  }

  @override
  Widget build(BuildContext context) {
    List<Operand> randomNumbers = ref.watch(operandNumbersProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('$APP_TITLE: Daily'),
        ),
        body: Center(
            child: Container(
                padding: _getPadding(context),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      instructionText(context),
                      const OverviewPanel(),
                      actionArea(context, randomNumbers),
                    ]))));
  }
}

Widget actionArea(BuildContext context, List<Operand> randomNumbers) {
  return ResponsiveUtils.largeSmall(
      context, actionAreaLarge(context, randomNumbers), actionAreaSmall(context, randomNumbers));
}

Widget actionAreaLarge(BuildContext context, List<Operand> randomNumbers) {
  return Flexible(
    flex: 0,
    child: Row(
      children: [
        Flexible(flex: 3, child: Column(children: [NumberButtons(randomNumbers), const OperatorButtons()])),
        const Expanded(flex: 2, child: TallyBoard()),
      ],
    )
  );
}

Flex actionAreaSmall(BuildContext context, List<Operand> randomNumbers) {
  return Column(children: [NumberButtons(randomNumbers), const OperatorButtons(), const TallyBoard()]);
}

Widget instructionText(BuildContext context) {
  final TextStyle? textStyle = ResponsiveUtils.largeSmall(
      context, Theme.of(context).textTheme.headlineSmall, Theme.of(context).textTheme.bodyLarge);

  return Text(APP_INSTRUCTIONS,
      style: textStyle?.copyWith(
        color: Theme.of(context).colorScheme.onBackground,
      ));
}

Widget targetText(BuildContext context, int totalTarget) {
  final TextStyle? textStyle = ResponsiveUtils.largeSmall(
      context, Theme.of(context).textTheme.displaySmall, Theme.of(context).textTheme.headlineMedium);

  return Text('Target: ${totalTarget.toString()}',
      style: textStyle?.copyWith(
        color: Theme.of(context).colorScheme.onBackground,
      ));
}

EdgeInsetsGeometry _getPadding(BuildContext context) {
  return ResponsiveUtils.largeSmall(
      context, const EdgeInsets.symmetric(horizontal: 64.0), const EdgeInsets.symmetric(horizontal: 16.0));
}
