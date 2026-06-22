part of 'notes_bloc.dart';


final class NotesState {
  const NotesState({
    this.notes = const [],
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  final List<NoteEntity> notes;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  NotesState copyWith({
    List<NoteEntity>? notes,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}