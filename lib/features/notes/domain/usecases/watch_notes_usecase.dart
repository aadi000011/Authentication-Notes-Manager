import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

class WatchNotesUseCase {
  WatchNotesUseCase(this._repository);

  final NotesRepository _repository;

  Stream<List<NoteEntity>> call(String userId) {
    return _repository.watchNotes(userId);
  }
}
