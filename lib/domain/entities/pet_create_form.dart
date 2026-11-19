import 'package:totalexam/domain/entities/pet.dart';

class PetCreateForm {
  AnimalType? animal;
  String? breedId;
  String? name;
  DateTime? birthdate;
  double? weight;
  Gender? gender;
  NeuterStatus? neuter;
  String? imageUrl;
}