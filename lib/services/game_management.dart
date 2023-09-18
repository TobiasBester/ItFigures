import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/models/game_solution.dart';
import 'package:it_figures/providers/game_providers.dart';
import 'package:it_figures/providers/number_providers.dart';
import 'package:it_figures/services/number_generator.dart';
import 'package:it_figures/services/solution_checker.dart';

Future<void> updateLevel(WidgetRef ref, int newLevel) async {
  ref.read(difficultyLevelProvider.notifier).update(newLevel);
  resetAllStates(ref);
  return regenerateAll(ref, newLevel);
}

Future<void> regenerateAll(WidgetRef ref, int newLevel) async {
  ref.read(gameLoadingProvider.notifier).setLoading(true);
  int maxAttempts = NumberGenerator.MAX_OPERAND_LIST_GENERATIONS;
  int numAttempts = 0;
  try {
    while (numAttempts < maxAttempts) {
      ref.read(operandNumbersProvider.notifier).regenerate(newLevel, ref.read(gameTypeProvider), numAttempts);
      ref.read(totalTargetProvider.notifier).regenerate(newLevel, ref.read(gameTypeProvider), numAttempts);

      GameSolution? gameSolution = await getGameSolution(ref);
      if (gameSolution != null) {
        ref.read(currentLevelSolutionProvider.notifier).update(gameSolution);
        ref.read(gameLoadingProvider.notifier).setLoading(false);
        return;
      } else {
        numAttempts++;
      }
    }
  } catch (e, st) {
    print('Exception caught: $e, $st');
  }
  throw Exception('Could not generate a solvable game in time');
}

Future<GameSolution?> getGameSolution(WidgetRef ref) async {
  GameType gameType = ref.read(gameTypeProvider);
  if (gameType == GameType.infinite) {
    return SolutionChecker.trySolve(ref.read(operandNumbersProvider), ref.read(totalTargetProvider));
  } else {
    int level = ref.read(difficultyLevelProvider);

    final cachedSolution = await ref.read(dailySolutionCacheProvider.notifier).getSolutionForTodayAndLevel(level);
    if (cachedSolution != null) {
      return cachedSolution;
    }

    GameSolution? solution = SolutionChecker.trySolve(ref.read(operandNumbersProvider), ref.read(totalTargetProvider));
    if (solution != null) {
      await ref.read(dailySolutionCacheProvider.notifier).saveSolutionForTodayAndLevel(level, solution);
      return solution;
    }
    return null;
  }
}

void resetAllStates(WidgetRef ref) {
  ref.read(operandNumbersProvider.notifier).reset();
  ref.read(operationResultsProvider.notifier).reset();
  ref.read(operationSelectionProvider.notifier).reset();
}
