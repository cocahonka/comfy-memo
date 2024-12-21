import 'package:comfy_memo/domain/algorithm/entity/algorithm_type.dart';
import 'package:comfy_memo/domain/preferences/repository/repository.dart';

base class PreferencesRepositoryImpl implements IPreferencesRepository {
  @override
  Future<AlgorithmType> fetch(int cardId) async => AlgorithmType.fsrs;
}
