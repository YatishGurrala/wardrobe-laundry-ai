import '../entities/clothing_item.dart';
import '../repositories/clothing_repository.dart';

class AddClothingItemUseCase {
  const AddClothingItemUseCase(this._repository);

  final ClothingRepository _repository;

  Future<void> call(ClothingItem item) => _repository.addItem(item);
}
