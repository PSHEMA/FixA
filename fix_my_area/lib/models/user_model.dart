import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final List<String> services;
  final String bio;
  final String rate;
  String photoUrl;
  final String district;
  final String sector;
  final Map<String, dynamic> workingHours;
  final List<Timestamp> daysOff;
  final bool isVerified;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.services,
    required this.bio,
    required this.rate,
    required this.photoUrl,
    required this.district,
    required this.sector,
    required this.workingHours,
    required this.daysOff,
    required this.isVerified,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? 'Guest',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'customer',
      services: List<String>.from(data['services'] ?? []),
      bio: data['bio'] ?? '',
      rate: data['rate'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      district: data['district'] ?? '',
      sector: data['sector'] ?? '',
      workingHours: Map<String, dynamic>.from(data['workingHours'] ?? {}),
      daysOff: List<Timestamp>.from(data['daysOff'] ?? []),
      isVerified: data['isVerified'] ?? false,
    );
  }
}
