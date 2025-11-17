import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:it_figures/constants.dart';
import 'package:it_figures/models/operand_model.dart';
import 'package:it_figures/providers/game_providers.dart';
import 'package:it_figures/providers/number_providers.dart';
import 'package:it_figures/responsive_utils.dart';
import 'package:it_figures/services/game_management.dart';
import 'package:it_figures/widgets/number_buttons.dart';
import 'package:it_figures/widgets/operator_buttons.dart';
import 'package:it_figures/widgets/overview_panel.dart';
import 'package:it_figures/widgets/tally_board.dart';

class GamePage extends ConsumerStatefulWidget {
  final GameType gameType;

  const GamePage(this.gameType, {super.key});

  @override
  ConsumerState createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  @override
  void initState() {
    super.initState();
    ref.read(operandNumbersProvider);
    final level = ref.read(difficultyLevelProvider);

    Future(() {
      ref.read(gameTypeProvider.notifier).setGameType(widget.gameType);

      return regenerateAll(ref, level);
    }).then((value) {
      ref.read(gameLoadingProvider.notifier).setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Operand> randomNumbers = ref.watch(operandNumbersProvider);
    final gameType = widget.gameType;
    final loading = ref.watch(gameLoadingProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('$APP_TITLE: ${gameType.name}'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          bottom: loading
              ? PreferredSize(
                  preferredSize: Size(size.width, 2), child: const LinearProgressIndicator(backgroundColor: Colors.red))
              : null,
        ),
        body: Center(
            child: Container(
                padding: _getPadding(context),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (gameType == GameType.daily) _buildDateDisplay(),
                      const Flexible(child: OverviewPanel()),
                      actionArea(context, randomNumbers),
                    ]))));
  }

  Widget _buildDateDisplay() {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d, y').format(now);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        formattedDate,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
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
      ));
}

Flex actionAreaSmall(BuildContext context, List<Operand> randomNumbers) {
  return Column(children: [NumberButtons(randomNumbers), const OperatorButtons(), const TallyBoard()]);
}

EdgeInsetsGeometry _getPadding(BuildContext context) {
  return ResponsiveUtils.largeSmall(
      context, const EdgeInsets.symmetric(horizontal: 64.0), const EdgeInsets.symmetric(horizontal: 16.0));
}
