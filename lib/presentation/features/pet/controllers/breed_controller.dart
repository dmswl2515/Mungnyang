import 'package:totalexam/data/repositories/mock/mock_breed_repository.dart';
import 'package:totalexam/domain/repositories/breed_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/breed.dart';
import '../../../../domain/entities/pet.dart';

final breedRepositoryProvider = Provider<BreedRepository>((ref) {
  return MockBreedRepository();
});

final breedsProvider =
  FutureProvider.family<List<Breed>, AnimalType>((ref, species) {
    return ref.watch(breedRepositoryProvider).getBreeds(species);
  });

String breedNameOf(List<Breed> breeds, String? breedId) {
  return breeds.where((b) => b.id == breedId).firstOrNull?.name ?? '-';
}