enum AnimalType { dog, cat }
enum Gender { male, female }
enum NeuterStatus { done, yet }

class Pet {
  final String id;
  final String name;
  final AnimalType animal;
  final String? breed;
  final String? registrationNumber;
  final DateTime birthdate;
  final double weight;
  final Gender gender;
  final NeuterStatus neuter;
  final String? imageUrl;

  const Pet({
    required this.id,
    required this.name,
    required this.animal,
    this.breed,
    this.registrationNumber,
    required this.birthdate,
    required this.weight,
    required this.gender,
    required this.neuter,
    this.imageUrl
  });

  int get age {
    final today = DateTime.now();
    int age = today.year - birthdate.year;
    if (today.month < birthdate.month ||
        (today.month == birthdate.month && today.day < birthdate.day)) {
      age--;
    }
    return age;
  }
}