import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/pages/game_page.dart';
import 'package:it_figures/providers/game_providers.dart';

class InfinitePage extends ConsumerStatefulWidget {
  const InfinitePage({super.key});

  @override
  ConsumerState createState() => _InfinitePageState();
}

class _InfinitePageState extends ConsumerState<InfinitePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const GamePage(GameType.infinite);
  }
}
