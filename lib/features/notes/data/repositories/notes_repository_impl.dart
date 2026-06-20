import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_remote_data_source.dart';

class NotesRepositoryImpl implements NotesRepository {
  NotesRepositoryImpl({required NotesRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final NotesRemoteDataSource _remoteDataSource;

  @override
  Stream<List<NoteEntity>> watchNotes(String userId) {
    return _remoteDataSource.watchNotes(userId);
  }

  @override
  Future<void> addNote({
    required String userId,
    required String title,
    required String description,
  }) {
    return _remoteDataSource.addNote(
      userId: userId,
      title: title,
      description: description,
    );
  }

  @override
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String description,
  }) {
    return _remoteDataSource.updateNote(
      noteId: noteId,
      title: title,
      description: description,
    );
  }

  @override
  Future<void> deleteNote(String noteId) {
    return _remoteDataSource.deleteNote(noteId);
  }
}
