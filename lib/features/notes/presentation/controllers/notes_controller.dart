// import 'dart:async';

// import 'package:flutter/foundation.dart';

// import '../../domain/entities/note_entity.dart';
// import '../../domain/usecases/add_note_usecase.dart';
// import '../../domain/usecases/delete_note_usecase.dart';
// import '../../domain/usecases/update_note_usecase.dart';
// import '../../domain/usecases/watch_notes_usecase.dart';

// class NotesController extends ChangeNotifier {
//   NotesController({
//     required WatchNotesUseCase watchNotesUseCase,
//     required AddNoteUseCase addNoteUseCase,
//     required UpdateNoteUseCase updateNoteUseCase,
//     required DeleteNoteUseCase deleteNoteUseCase,
//   })  : _watchNotesUseCase = watchNotesUseCase,
//         _addNoteUseCase = addNoteUseCase,
//         _updateNoteUseCase = updateNoteUseCase,
//         _deleteNoteUseCase = deleteNoteUseCase;

//   final WatchNotesUseCase _watchNotesUseCase;
//   final AddNoteUseCase _addNoteUseCase;
//   final UpdateNoteUseCase _updateNoteUseCase;
//   final DeleteNoteUseCase _deleteNoteUseCase;

//   StreamSubscription<List<NoteEntity>>? _notesSubscription;
//   List<NoteEntity> _notes = [];
//   String? _userId;
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<NoteEntity> get notes => _notes;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   void bindUser(String? userId) {
//     if (_userId == userId) {
//       return;
//     }

//     _userId = userId;
//     _notesSubscription?.cancel();

//     if (userId == null) {
//       _notes = [];
//       notifyListeners();
//       return;
//     }

//     _notesSubscription = _watchNotesUseCase(userId).listen(
//       (items) {
//         _notes = items;
//         notifyListeners();
//       },
//       onError: (_) {
//         _errorMessage = 'Failed to load notes.';
//         notifyListeners();
//       },
//     );
//   }

//   Future<bool> addNote({
//     required String title,
//     required String description,
//   }) async {
//     final userId = _userId;
//     if (userId == null) {
//       return false;
//     }

//     _setLoading(true);
//     try {
//       await _addNoteUseCase(
//         userId: userId,
//         title: title,
//         description: description,
//       );
//       _errorMessage = null;
//       return true;
//     } catch (_) {
//       _errorMessage = 'Unable to add note. Please try again.';
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<bool> updateNote({
//     required String noteId,
//     required String title,
//     required String description,
//   }) async {
//     _setLoading(true);
//     try {
//       await _updateNoteUseCase(
//         noteId: noteId,
//         title: title,
//         description: description,
//       );
//       _errorMessage = null;
//       return true;
//     } catch (_) {
//       _errorMessage = 'Unable to update note. Please try again.';
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<bool> deleteNote(String noteId) async {
//     _setLoading(true);
//     try {
//       await _deleteNoteUseCase(noteId);
//       _errorMessage = null;
//       return true;
//     } catch (_) {
//       _errorMessage = 'Unable to delete note. Please try again.';
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _notesSubscription?.cancel();
//     super.dispose();
//   }
// }
