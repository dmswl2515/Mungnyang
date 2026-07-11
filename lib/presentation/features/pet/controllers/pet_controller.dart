import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/pet.dart';
import '../../../../domain/repositories/pet_repository.dart';
import '../../../../data/repositories/mock/mock_pet_repository.dart';

class PetState {
  final List<Pet> pets;
  final bool isLoading;

  const PetState({
    this.pets = const [],
    this.isLoading = false,
  });
  
  PetState copyWith({List<Pet>? pets, bool? isLoading}) {
    return PetState(
      pets: pets ?? this.pets,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PetNotifier extends StateNotifier<PetState> {
    final PetRepository _repository;

    PetNotifier(this._repository) : super(const PetState()) {
      fetchPets();
    }
    
    Future<void> fetchPets() async {
      state = state.copyWith(isLoading: true);
      try {
        final pets = await _repository.getPets();
        state = state.copyWith(pets: pets, isLoading: false);
      } catch (e) {
        state = state.copyWith(isLoading: false);
      }
    }
    
    Future<void> addPet(Pet pet, {Uint8List? imageBytes}) async {
      await _repository.addPet(pet, imageBytes: imageBytes);
      await fetchPets(); 
    }
    
    Future<void> deletePet(String id) async {
      await _repository.deletePet(id);
      await fetchPets();
    }
  }
  
  final petRepositoryProvider = Provider<PetRepository>((ref) {
    return MockPetRepository();
  });

  final petProvider = StateNotifierProvider<PetNotifier, PetState>((ref) {
    return PetNotifier(ref.watch(petRepositoryProvider));
  });
