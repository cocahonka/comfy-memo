import 'package:comfy_memo/src/domain/algorithm/entity/algorithm_type.dart';
import 'package:comfy_memo/src/domain/preferences/repository/repository.dart';

base class PreferencesRepository implements IPreferencesRepository {
  @override
  Future<AlgorithmType> fetchAlgorithmType(int cardId) async =>
      AlgorithmType.fsrs;
}
