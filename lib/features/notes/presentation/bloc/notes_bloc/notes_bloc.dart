import 'dart:async';

import 'package:authentication_notes_manager/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:authentication_notes_manager/features/notes/domain/entities/note_entity.dart';
import 'package:authentication_notes_manager/features/notes/domain/usecases/add_note_usecase.dart';
import 'package:authentication_notes_manager/features/notes/domain/usecases/delete_note_usecase.dart';
import 'package:authentication_notes_manager/features/notes/domain/usecases/update_note_usecase.dart';
import 'package:authentication_notes_manager/features/notes/domain/usecases/watch_notes_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({
    required WatchNotesUseCase watchNotesUseCase,
    required AddNoteUseCase addNoteUseCase,
    required UpdateNoteUseCase updateNoteUseCase,
    required DeleteNoteUseCase deleteNoteUseCase,
    required AuthBloc authBloc,
  })  : _watchNotesUseCase = watchNotesUseCase,
        _addNoteUseCase = addNoteUseCase,
        _updateNoteUseCase = updateNoteUseCase,
        _deleteNoteUseCase = deleteNoteUseCase,
        _authBloc = authBloc,
        super(const NotesState()) {
    on<NotesUserBound>(_onUserBound);
    on<_NotesUpdated>(_onNotesUpdated);
    on<_NotesFailed>(_onNotesFailed);
    on<NotesAddRequested>(_onAddRequested);
    on<NotesUpdateRequested>(_onUpdateRequested);
    on<NotesDeleteRequested>(_onDeleteRequested);

    // React to auth changes the same way the old controller's bindUser did.
    _authSubscription = _authBloc.stream.listen((authState) {
      add(NotesUserBound(authState.user?.id));
    });
    // Seed with whatever the current auth state already is.
    add(NotesUserBound(_authBloc.state.user?.id));
  }

  final WatchNotesUseCase _watchNotesUseCase;
  final AddNoteUseCase _addNoteUseCase;
  final UpdateNoteUseCase _updateNoteUseCase;
  final DeleteNoteUseCase _deleteNoteUseCase;
  final AuthBloc _authBloc;

  StreamSubscription<AuthState>? _authSubscription;
  StreamSubscription<List<NoteEntity>>? _notesSubscription;
  String? _userId;

  void _onUserBound(NotesUserBound event, Emitter<NotesState> emit) {
    if (_userId == event.userId) {
      return;
    }
    _userId = event.userId;
    _notesSubscription?.cancel();

    if (event.userId == null) {
      emit(state.copyWith(notes: []));
      return;
    }

    _notesSubscription = _watchNotesUseCase(event.userId!).listen(
      (items) => add(_NotesUpdated(items)),
      onError: (_) => add(_NotesFailed('Failed to load notes.')),
    );
  }

  void _onNotesUpdated(_NotesUpdated event, Emitter<NotesState> emit) {
    emit(state.copyWith(notes: event.notes));
  }

  void _onNotesFailed(_NotesFailed event, Emitter<NotesState> emit) {
    emit(state.copyWith(errorMessage: event.message));
  }

  Future<void> _onAddRequested(
    NotesAddRequested event,
    Emitter<NotesState> emit,
  ) async {
    final userId = _userId;
    if (userId == null) {
      emit(state.copyWith(
        errorMessage: 'You must be signed in to add notes.',
      ));
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    ));
    try {
      await _addNoteUseCase(
        userId: userId,
        title: event.title,
        description: event.description,
      );
      emit(state.copyWith(isLoading: false, successMessage: 'Note added.'));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to add note. Please try again.',
      ));
    }
  }

  Future<void> _onUpdateRequested(
    NotesUpdateRequested event,
    Emitter<NotesState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    ));
    try {
      await _updateNoteUseCase(
        noteId: event.noteId,
        title: event.title,
        description: event.description,
      );
      emit(state.copyWith(isLoading: false, successMessage: 'Note updated.'));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to update note. Please try again.',
      ));
    }
  }

  Future<void> _onDeleteRequested(
    NotesDeleteRequested event,
    Emitter<NotesState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    ));
    try {
      await _deleteNoteUseCase(event.noteId);
      emit(state.copyWith(isLoading: false, successMessage: 'Note deleted.'));
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to delete note. Please try again.',
      ));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _notesSubscription?.cancel();
    return super.close();
  }
}