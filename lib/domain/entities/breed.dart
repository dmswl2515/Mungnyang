import 'pet.dart';

const String kUnknownDogBreedId = 'dog-unknown';
const String kUnknownCatBreedId = 'cat-unknown';

String unknownBreedIdOf(AnimalType species) =>
    species == AnimalType.dog ? kUnknownDogBreedId : kUnknownCatBreedId;

class Breed {
  final String id;
  final AnimalType species;
  final String name;

  const Breed({
    required this.id,
    required this.species,
    required this.name,
  });
}
