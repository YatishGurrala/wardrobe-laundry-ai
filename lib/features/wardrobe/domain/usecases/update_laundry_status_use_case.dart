import '../entities/laundry_status.dart';
import '../repositories/clothing_repository.dart';

class UpdateLaundryStatusUseCase {
  const UpdateLaundryStatusUseCase(this._repository);

  final ClothingRepository _repository;

  Future<void> call({
    required String itemId,
    required LaundryStatus status,
    DateTime? lastWorn,
    int? wearCount,
  }) {
    return _repository.updateLaundryStatus(
      itemId: itemId,
      status: status,
      lastWorn: lastWorn,
      wearCount: wearCount,
    );
  }
}
