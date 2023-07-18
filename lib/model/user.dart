class User {
  final int id;
  final bool isAdmin;
  String fullName;
  String phoneNumber;
  String email;

  User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.isAdmin,
  });

  void setFullName(String fullName) {
    this.fullName = fullName;
  }

  void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  void setEmail(String email) {
    this.email = email;
  }

  static User fromJson(dynamic obj) {
    return User(
      id: obj['id'],
      fullName: obj['full_name'],
      phoneNumber: obj['phone_number'],
      email: obj['email'],
      isAdmin: obj['is_admin'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      'is_admin': isAdmin,
    };
  }
}
