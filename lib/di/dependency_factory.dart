// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../features/auth/data/datasources/auth_remote_data_source.dart';
// import '../features/auth/data/repositories/auth_repository_impl.dart';
// import '../features/auth/domain/repositories/auth_repository.dart';
// import '../features/auth/domain/usecases/login_usecase.dart';
// import '../features/auth/domain/usecases/logout_usecase.dart';
// import '../features/auth/domain/usecases/signup_usecase.dart';
// import '../features/auth/domain/usecases/watch_auth_user_usecase.dart';
// import '../features/auth/presentation/controllers/auth_controller.dart';
// import '../features/notes/data/datasources/notes_remote_data_source.dart';
// import '../features/notes/data/repositories/notes_repository_impl.dart';
// import '../features/notes/domain/repositories/notes_repository.dart';
// import '../features/notes/domain/usecases/add_note_usecase.dart';
// import '../features/notes/domain/usecases/delete_note_usecase.dart';
// import '../features/notes/domain/usecases/update_note_usecase.dart';
// import '../features/notes/domain/usecases/watch_notes_usecase.dart';
// import '../features/notes/presentation/controllers/notes_controller.dart';

// class DependencyFactory {
//   DependencyFactory({
//     FirebaseAuth? auth,
//     FirebaseFirestore? firestore,
//   })  : _auth = auth ?? FirebaseAuth.instance,
//         _firestore = firestore ?? FirebaseFirestore.instance;

//   final FirebaseAuth _auth;
//   final FirebaseFirestore _firestore;

//   late final AuthRemoteDataSource _authRemoteDataSource =
//       AuthRemoteDataSource(auth: _auth, firestore: _firestore);
//   late final NotesRemoteDataSource _notesRemoteDataSource =
//       NotesRemoteDataSource(firestore: _firestore);

//   late final AuthRepository _authRepository =
//       AuthRepositoryImpl(remoteDataSource: _authRemoteDataSource);
//   late final NotesRepository _notesRepository =
//       NotesRepositoryImpl(remoteDataSource: _notesRemoteDataSource);

//   late final SignupUseCase _signupUseCase = SignupUseCase(_authRepository);
//   late final LoginUseCase _loginUseCase = LoginUseCase(_authRepository);
//   late final LogoutUseCase _logoutUseCase = LogoutUseCase(_authRepository);
//   late final WatchAuthUserUseCase _watchAuthUserUseCase =
//       WatchAuthUserUseCase(_authRepository);

//   late final WatchNotesUseCase _watchNotesUseCase =
//       WatchNotesUseCase(_notesRepository);
//   late final AddNoteUseCase _addNoteUseCase = AddNoteUseCase(_notesRepository);
//   late final UpdateNoteUseCase _updateNoteUseCase =
//       UpdateNoteUseCase(_notesRepository);
//   late final DeleteNoteUseCase _deleteNoteUseCase =
//       DeleteNoteUseCase(_notesRepository);

//   AuthController createAuthController() {
//     return AuthController(
//       signupUseCase: _signupUseCase,
//       loginUseCase: _loginUseCase,
//       logoutUseCase: _logoutUseCase,
//       watchAuthUserUseCase: _watchAuthUserUseCase,
//     );
//   }

//   NotesController createNotesController() {
//     return NotesController(
//       watchNotesUseCase: _watchNotesUseCase,
//       addNoteUseCase: _addNoteUseCase,
//       updateNoteUseCase: _updateNoteUseCase,
//       deleteNoteUseCase: _deleteNoteUseCase,
//     );
//   }
// }
