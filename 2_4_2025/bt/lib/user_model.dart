class UserModel {
  String id;
  String name;
  String email;
  int age;
  String avatarUrl;
  String address;
  String phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.avatarUrl,
    required this.address,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'avatarUrl': avatarUrl,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
      avatarUrl: json['avatarUrl'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
