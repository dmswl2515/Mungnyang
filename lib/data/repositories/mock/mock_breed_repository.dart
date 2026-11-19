import '../../../domain/entities/breed.dart';
import '../../../domain/entities/pet.dart';
import '../../../domain/repositories/breed_repository.dart';
import 'mock_breed_data.dart';

class MockBreedRepository implements BreedRepository {
  @override
  Future<List<Breed>> getBreeds(AnimalType species) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return species == AnimalType.dog ? mockDogBreeds : mockCatBreeds;
  }
}
