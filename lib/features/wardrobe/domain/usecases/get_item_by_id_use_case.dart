import '../entities/clothing_item.dart';
import '../repositories/clothing_repository.dart';

class GetItemByIdUseCase {
  const GetItemByIdUseCase(this._repository);

  final ClothingRepository _repository;

  Future<ClothingItem?> call(String id) => _repository.getItemById(id);
}
