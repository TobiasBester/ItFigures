import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/models/game_solution.dart';
import 'package:it_figures/providers/home_screen_providers.dart';
import 'package:it_figures/services/storage_service.dart';

class GameTypeNotifier extends StateNotifier<GameType> {
  GameTypeNotifier() : super(GameType.daily);

  void setGameType(GameType gameType) {
    state = gameType;
  }
}

final gameTypeProvider = StateNotifierProvider<GameTypeNotifier, GameType>((ref) => GameTypeNotifier());

class GameLoadingNotifier extends StateNotifier<bool> {
  GameLoadingNotifier() : super(true);

  void setLoading(bool loading) {
    state = loading;
  }
}

final gameLoadingProvider = StateNotifierProvider<GameLoadingNotifier, bool>((ref) => GameLoadingNotifier());

// LEVEL
class DifficultyLevelNotifier extends StateNotifier<int> {
  DifficultyLevelNotifier() : super(0);

  void update(int newLevel) {
    state = newLevel;
  }
}

final difficultyLevelProvider = StateNotifierProvider<DifficultyLevelNotifier, int>((ref) => DifficultyLevelNotifier());

class CurrentLevelSolutionNotifier extends StateNotifier<GameSolution?> {
  CurrentLevelSolutionNotifier() : super(null);

  void update(GameSolution newSolution) {
    state = newSolution;
  }
}

final currentLevelSolutionProvider =
    StateNotifierProvider<CurrentLevelSolutionNotifier, GameSolution?>((ref) => CurrentLevelSolutionNotifier());

class ElapsedTimeNotifier extends StateNotifier<Stopwatch> {
  ElapsedTimeNotifier() : super(Stopwatch());

  String get elapsedDuration {
    final elapsed = state.elapsed;
    final minutes = elapsed.inMinutes % 60;
    final seconds = elapsed.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

}

final elapsedTimeProvider = StateNotifierProvider<ElapsedTimeNotifier, Stopwatch>((ref) => ElapsedTimeNotifier());

class DailySolutionCacheNotifier extends StateNotifier<GameSolution?> {
  final StorageService _storageService;

  DailySolutionCacheNotifier(this._storageService) : super(null);

  Future<GameSolution?> getSolutionForTodayAndLevel(int level) async {
    final now = DateTime.now();
    final lastMidnight = DateTime(now.year, now.month, now.day);
    final day = lastMidnight.millisecondsSinceEpoch;
    String dayLevelKey = 'solution-$day-$level';

    final solutionText = await _storageService.read(dayLevelKey);
    return solutionText != null ? GameSolution.fromJson(const JsonDecoder().convert(solutionText)) : null;
  }

  Future<void> saveSolutionForTodayAndLevel(int level, GameSolution gameSolution) async {
    final now = DateTime.now();
    final lastMidnight = DateTime(now.year, now.month, now.day);
    final day = lastMidnight.millisecondsSinceEpoch;
    String dayLevelKey = 'solution-$day-$level';

    return _storageService.write(dayLevelKey, const JsonEncoder().convert(gameSolution.toJson()));
  }
}

final dailySolutionCacheProvider = StateNotifierProvider<DailySolutionCacheNotifier, GameSolution?>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return DailySolutionCacheNotifier(storageService);
});

enum GameType {
  daily('Daily'),
  infinite('Infinite');

  final String name;

  const GameType(this.name);
}

// TODO: Make time elapse live
