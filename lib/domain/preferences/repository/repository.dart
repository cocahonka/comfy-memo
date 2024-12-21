import 'package:comfy_memo/domain/algorithm/entity/algorithm_type.dart';

abstract interface class IPreferencesRepository {
  Future<AlgorithmType> fetch(int cardId);
}
