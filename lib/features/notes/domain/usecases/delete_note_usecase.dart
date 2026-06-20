import '../repositories/notes_repository.dart';

class DeleteNoteUseCase {
  DeleteNoteUseCase(this._repository);

  final NotesRepository _repository;

  Future<void> call(String noteId) {
    return _repository.deleteNote(noteId);
  }
}
