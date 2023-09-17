import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/models/operation_solution.dart';
import 'package:it_figures/providers/game_providers.dart';
import 'package:it_figures/providers/number_providers.dart';
import 'package:it_figures/services/number_generator.dart';
import 'package:it_figures/services/solution_checker.dart';

void updateLevel(WidgetRef ref, int newLevel) {
  ref.read(difficultyLevelProvider.notifier).update(newLevel);
  resetAllStates(ref);
  regenerateAll(ref, newLevel);
}

void regenerateAll(WidgetRef ref, int newLevel) {
  ref.read(gameLoadingProvider.notifier).setLoading(true);
  int maxAttempts = NumberGenerator.MAX_OPERAND_LIST_GENERATIONS;
  int numAttempts = 0;
  while (numAttempts < maxAttempts) {
    ref.read(operandNumbersProvider.notifier).regenerate(newLevel, ref.read(gameTypeProvider), numAttempts);
    ref.read(totalTargetProvider.notifier).regenerate(newLevel, ref.read(gameTypeProvider), numAttempts);

    GameSolution? gameSolution = SolutionChecker.trySolve(ref.read(operandNumbersProvider), ref.read(totalTargetProvider));
    if (gameSolution != null) {
      ref.read(currentLevelSolutionProvider.notifier).update(gameSolution);
      ref.read(gameLoadingProvider.notifier).setLoading(false);
      return;
    } else {
      numAttempts++;
    }
  }
  throw Exception('Could not generate a solvable game in time');
}

void resetAllStates(WidgetRef ref) {
  ref.read(operandNumbersProvider.notifier).reset();
  ref.read(operationResultsProvider.notifier).reset();
  ref.read(operationSelectionProvider.notifier).reset();
}