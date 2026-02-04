class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String phoneNumber;
  final String address;
  final String? profileImageUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.phoneNumber,
    required this.address,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'address': address,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      profileImageUrl: map['profileImageUrl'],
    );
  }
}
