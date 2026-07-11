import 'dart:typed_data';
import '../entities/pet.dart';

abstract class PetRepository {
  Future<List<Pet>> getPets();
  Future<void> addPet(Pet pet, {Uint8List? imageBytes});
  Future<void> deletePet(String id);
}