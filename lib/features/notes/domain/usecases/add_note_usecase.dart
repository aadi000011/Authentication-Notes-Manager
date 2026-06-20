import '../repositories/notes_repository.dart';

class AddNoteUseCase {
  AddNoteUseCase(this._repository);

  final NotesRepository _repository;

  Future<void> call({
    required String userId,
    required String title,
    required String description,
  }) {
    return _repository.addNote(
      userId: userId,
      title: title,
      description: description,
    );
  }
}
