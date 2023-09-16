import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/providers/game_providers.dart';
import 'package:it_figures/providers/number_providers.dart';

void updateLevel(WidgetRef ref, int newLevel) {
  ref.read(difficultyLevelProvider.notifier).update(newLevel);
  resetAllStates(ref);
  regenerateAll(ref, newLevel);
}

void regenerateAll(WidgetRef ref, int newLevel) {
  ref.read(operandNumbersProvider.notifier).regenerate(newLevel, ref.read(gameTypeProvider));
  ref.read(totalTargetProvider.notifier).regenerate(newLevel, ref.read(gameTypeProvider));
}

void resetAllStates(WidgetRef ref) {
  ref.read(operandNumbersProvider.notifier).reset();
  ref.read(operationResultsProvider.notifier).reset();
  ref.read(operationSelectionProvider.notifier).reset();
}