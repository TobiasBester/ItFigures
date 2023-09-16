import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/constants.dart';
import 'package:it_figures/providers/game_providers.dart';
import 'package:it_figures/widgets/show_timer_switch.dart';
import 'package:it_figures/widgets/home_page_button.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(APP_TITLE,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              )),
                      Text(APP_SUBTITLE,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              )),
                      Center(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HomePageButton(onPressed: () => _navigateToDaily(context, ref), text: 'Daily'),
                                const SizedBox(height: 16),
                                HomePageButton(onPressed: () => _navigateToInfinite(context, ref), text: 'Infinite'),
                                const SizedBox(height: 32),
                                const ShowTimerSwitch(),
                              ],
                            )),
                      ),
                      Text(APP_INSTRUCTIONS,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              )),
                    ]))));
  }
}

void _navigateToDaily(BuildContext context, WidgetRef ref) {
  ref.read(gameTypeProvider.notifier).setGameType(GameType.daily);
  ref.read(difficultyLevelProvider.notifier).update(0);
  Navigator.of(context).pushNamed('/daily');
}

void _navigateToInfinite(BuildContext context, WidgetRef ref) {
  ref.read(gameTypeProvider.notifier).setGameType(GameType.infinite);
  ref.read(difficultyLevelProvider.notifier).update(0);
  Navigator.of(context).pushNamed('/infinite');
}
