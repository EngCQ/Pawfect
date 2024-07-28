class Users {
  final String id;
  final String name;
  final String imageUrl;
  final bool isOnline;

  Users(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.isOnline});

  factory Users.fromMap(Map<String, dynamic> data, String id) {
    return Users(
      id: id,
      name: data['name'],
      imageUrl: data['imageUrl'],
      isOnline: data['isOnline'],
    );
  }
}
