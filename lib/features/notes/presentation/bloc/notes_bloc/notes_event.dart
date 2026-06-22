part of 'notes_bloc.dart';

sealed class NotesEvent {}

final class NotesUserBound extends NotesEvent {
  NotesUserBound(this.userId);
  final String? userId;
}

final class NotesAddRequested extends NotesEvent {
  NotesAddRequested({required this.title, required this.description});
  final String title;
  final String description;
}

final class NotesUpdateRequested extends NotesEvent {
  NotesUpdateRequested({
    required this.noteId,
    required this.title,
    required this.description,
  });
  final String noteId;
  final String title;
  final String description;
}

final class NotesDeleteRequested extends NotesEvent {
  NotesDeleteRequested(this.noteId);
  final String noteId;
}

final class _NotesUpdated extends NotesEvent {
  _NotesUpdated(this.notes);
  final List<NoteEntity> notes;
}

final class _NotesFailed extends NotesEvent {
  _NotesFailed(this.message);
  final String message;
}