import '../repositories/notes_repository.dart';

class UpdateNoteUseCase {
  UpdateNoteUseCase(this._repository);

  final NotesRepository _repository;

  Future<void> call({
    required String noteId,
    required String title,
    required String description,
  }) {
    return _repository.updateNote(
      noteId: noteId,
      title: title,
      description: description,
    );
  }
}
