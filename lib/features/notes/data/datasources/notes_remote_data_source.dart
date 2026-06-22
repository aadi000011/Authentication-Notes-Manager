import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note_model.dart';

class NotesRemoteDataSource {
  NotesRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<List<NoteModel>> watchNotes(String userId) {
    // NOTE: intentionally no `.orderBy('updatedAt')` here. Combining an
    // equality filter (userId) with orderBy on a *different* field requires
    // a Firestore composite index — without it Firestore throws
    // FAILED_PRECONDITION and the whole stream dies before ever emitting.
    // Sorting client-side avoids needing that index. If this collection
    // grows large, create the composite index in the Firebase console and
    // restore `.orderBy('updatedAt', descending: true)` for server-side
    // sorting + pagination instead.
    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final docs = snapshot.docs.toList()
        ..sort((a, b) {
          final aTime = (a.data()['updatedAt'] as Timestamp?)?.toDate();
          final bTime = (b.data()['updatedAt'] as Timestamp?)?.toDate();

          // A note whose serverTimestamp hasn't synced yet (just
          // added/edited locally) has a null updatedAt — treat it as the
          // most recent so it doesn't jump around once the server ack lands.
          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return -1;
          if (bTime == null) return 1;
          return bTime.compareTo(aTime);
        });

      return docs.map((doc) => NoteModel.fromFirestore(doc)).toList();
    });
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