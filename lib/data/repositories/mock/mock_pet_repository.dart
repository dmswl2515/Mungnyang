import 'dart:typed_data';
import '../../../../domain/entities/pet.dart';
import '../../../../domain/repositories/pet_repository.dart';

class MockPetRepository implements PetRepository {
  final List<Pet> _pets = [
    Pet(
      id: '1',
      name: '쿠키',
      animal: AnimalType.dog,
      breed: '골든 리트리버',
      registrationNumber: '410181234567890',
      birthdate: DateTime(2020, 3, 15),
      weight: 4.2,
      gender: Gender.male,
      neuter: NeuterStatus.done,
    ),
    Pet(
      id: '2',
      name: '나비',
      animal: AnimalType.cat,
      breed: '러시안 블루',
      registrationNumber: null,
      birthdate: DateTime(2021, 7, 22),
      weight: 3.8,
      gender: Gender.female,
      neuter: NeuterStatus.done,
    ),
    Pet(
      id: '3',
      name: '몽이',
      animal: AnimalType.dog,
      breed: null,
      registrationNumber: '410189876543210',
      birthdate: DateTime(2022, 11, 5),
      weight: 6.1,
      gender: Gender.male,
      neuter: NeuterStatus.yet,
    ),
  ];

  @override
  Future<List<Pet>> getPets() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_pets);
  }

  @override
  Future<void> addPet(Pet pet, {Uint8List? imageBytes}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _pets.add(pet);
  }

  @override
  Future<void> deletePet(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _pets.removeWhere((pet) => pet.id == id);
  }
}