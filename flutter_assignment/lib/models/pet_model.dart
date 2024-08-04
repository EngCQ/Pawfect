class PetModel {
  final String sellerUid;
  final String petName;
  final String species;
  final String purpose;
  final String fee;
  final String location;
  final String description;
  final String? imageUrl;

  PetModel({
    required this.sellerUid,
    required this.petName,
    required this.species,
    required this.purpose,
    required this.fee,
    required this.location,
    required this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'sellerUid': sellerUid,
      'petName': petName,
      'species': species,
      'purpose': purpose,
      'fee': fee,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
