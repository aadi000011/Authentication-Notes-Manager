import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note_model.dart';

class NotesRemoteDataSource {
  NotesRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<List<NoteModel>> watchNotes(String userId) {
    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NoteModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> addNote({
    required String userId,
    required String title,
    required String description,
  }) async {
    final now = FieldValue.serverTimestamp();
    await _firestore.collection('notes').add({
      'userId': userId,
      'title': title,
      'description': description,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  Future<void> updateNote({
    required String noteId,
    required String title,
    required String description,
  }) async {
    await _firestore.collection('notes').doc(noteId).update({
      'title': title,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String noteId) async {
    await _firestore.collection('notes').doc(noteId).delete();
  }
}
