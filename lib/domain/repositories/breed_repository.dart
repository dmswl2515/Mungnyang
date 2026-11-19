import '../entities/breed.dart';
import '../entities/pet.dart';

abstract class BreedRepository {
  Future<List<Breed>> getBreeds(AnimalType species);
}
