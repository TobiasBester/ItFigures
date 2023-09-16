import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:it_figures/services/storage_service.dart';

final helloWorldProvider = Provider((ref) => 'Hello world!!!');

final storageServiceProvider = Provider((ref) => StorageService());

class ShowTimerNotifier extends StateNotifier<bool> {
  final StorageService _storageService;

  ShowTimerNotifier(this._storageService) : super(false);

  Future<void> toggleShowTimer() async {
    state = !state;
    await _storageService.writeShowTimerValue(state);
  }

  Future<void> setFromStorage() async {
    state = await _storageService.readShowTimerValue();
  }
}

final showTimerProvider = StateNotifierProvider<ShowTimerNotifier, bool>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ShowTimerNotifier(storageService);
});
