import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/pages/game_page.dart';
import 'package:it_figures/providers/game_providers.dart';

class DailyPage extends ConsumerStatefulWidget {
  const DailyPage({super.key});

  @override
  ConsumerState createState() => _DailyPageState();
}

class _DailyPageState extends ConsumerState<DailyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const GamePage(GameType.daily);
  }
}
