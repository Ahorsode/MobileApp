class UserModel {
  final String uid;
  final String email;
  final bool isAdmin;
  final int totalOrders;
  final bool isGuest;

  final String name;
  final String phoneNumber;
  final String cafeteria; // Oyibi, Techiman, Kumasi
  final String? fcmToken;

  UserModel({
    required this.uid,
    required this.email,
    this.isAdmin = false,
    this.totalOrders = 0,
    this.isGuest = false,
    this.name = '',
    this.phoneNumber = '',
    this.cafeteria = 'Oyibi',
    this.fcmToken,
  });

  // Factory to create a UserModel from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      totalOrders: map['totalOrders'] ?? 0,
      isGuest: map['isGuest'] ?? false,
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      cafeteria: map['cafeteria'] ?? 'Oyibi',
      fcmToken: map['fcmToken'],
    );
  }

  // Convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'isAdmin': isAdmin,
      'totalOrders': totalOrders,
      'isGuest': isGuest,
      'name': name,
      'phoneNumber': phoneNumber,
      'cafeteria': cafeteria,
      'fcmToken': fcmToken,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    bool? isAdmin,
    int? totalOrders,
    bool? isGuest,
    String? name,
    String? phoneNumber,
    String? cafeteria,
    String? fcmToken,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      totalOrders: totalOrders ?? this.totalOrders,
      isGuest: isGuest ?? this.isGuest,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      cafeteria: cafeteria ?? this.cafeteria,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
