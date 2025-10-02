import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String id;
  final DateTime createdAt;

  Message(this.message, this.id, this.createdAt);

  factory Message.fromjson(DocumentSnapshot jsonData) {
    final data = jsonData.data() as Map<String, dynamic>;
    return Message(
      data['message'] ?? '',
      data['id'] ?? 'unknown',
      (data['createdAt'] as Timestamp).toDate(),  // 🔹 convert from Firestore
    );
  }
}
