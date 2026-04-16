class UserModel {
  final String uid;
  final String email;
  final bool isAdmin;
  final int totalOrders;
  final bool isGuest;

  UserModel({
    required this.uid,
    required this.email,
    this.isAdmin = false,
    this.totalOrders = 0,
    this.isGuest = false,
  });

  // Factory to create a UserModel from a Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      totalOrders: map['totalOrders'] ?? 0,
      isGuest: map['isGuest'] ?? false,
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
    };
  }
}
