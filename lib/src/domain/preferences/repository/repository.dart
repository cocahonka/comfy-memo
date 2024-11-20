import 'package:comfy_memo/src/domain/algorithm/entity/algorithm_type.dart';

abstract interface class IPreferencesRepository {
  Future<AlgorithmType> fetchAlgorithmType(int cardId);
}
