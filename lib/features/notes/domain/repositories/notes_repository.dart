import '../entities/note_entity.dart';

abstract class NotesRepository {
  Stream<List<NoteEntity>> watchNotes(String userId);

  Future<void> addNote({
    required String userId,
    required String title,
    required String description,
  });

  Future<void> updateNote({
    required String noteId,
    required String title,
    required String description,
  });

  Future<void> deleteNote(String noteId);
}
