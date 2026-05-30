import '../entities/clothing_item.dart';
import '../repositories/clothing_repository.dart';

class GetClothingItemsUseCase {
  const GetClothingItemsUseCase(this._repository);

  final ClothingRepository _repository;

  Future<List<ClothingItem>> call() => _repository.getItems();
}
