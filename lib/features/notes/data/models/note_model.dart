import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/note_entity.dart';

class NoteModel extends NoteEntity {
  const NoteModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NoteModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    DateTime readDate(String key) {
      final value = data[key];
      if (value is Timestamp) {
        return value.toDate();
      }
      return DateTime.now();
    }

    return NoteModel(
      id: doc.id,
      userId: (data['userId'] as String?) ?? '',
      title: (data['title'] as String?) ?? '',
      description: (data['description'] as String?) ?? '',
      createdAt: readDate('createdAt'),
      updatedAt: readDate('updatedAt'),
    );
  }
}
