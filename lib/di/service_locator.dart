import 'package:authentication_notes_manager/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:authentication_notes_manager/features/notes/presentation/controllers/bloc/notes_bloc/notes_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/signup_usecase.dart';
import '../features/auth/domain/usecases/watch_auth_user_usecase.dart';
import '../features/notes/data/datasources/notes_remote_data_source.dart';
import '../features/notes/data/repositories/notes_repository_impl.dart';
import '../features/notes/domain/repositories/notes_repository.dart';
import '../features/notes/domain/usecases/add_note_usecase.dart';
import '../features/notes/domain/usecases/delete_note_usecase.dart';
import '../features/notes/domain/usecases/update_note_usecase.dart';
import '../features/notes/domain/usecases/watch_notes_usecase.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // External / firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(auth: getIt(), firestore: getIt()),
  );
  getIt.registerLazySingleton<NotesRemoteDataSource>(
    () => NotesRemoteDataSource(firestore: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(remoteDataSource: getIt()),
  );

  // Auth use cases
  getIt.registerLazySingleton(() => SignupUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => WatchAuthUserUseCase(getIt()));

  // Notes use cases
  getIt.registerLazySingleton(() => WatchNotesUseCase(getIt()));
  getIt.registerLazySingleton(() => AddNoteUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateNoteUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteNoteUseCase(getIt()));

  // Blocs — factories, never singletons. A fresh instance per
  // BlocProvider.create call, so subscriptions stay tied to the
  // widget tree's lifecycle instead of leaking across app restarts/tests.
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      signupUseCase: getIt(),
      loginUseCase: getIt(),
      logoutUseCase: getIt(),
      watchAuthUserUseCase: getIt(),
    ),
  );

  getIt.registerFactoryParam<NotesBloc, AuthBloc, void>(
    (authBloc, _) => NotesBloc(
      watchNotesUseCase: getIt(),
      addNoteUseCase: getIt(),
      updateNoteUseCase: getIt(),
      deleteNoteUseCase: getIt(),
      authBloc: authBloc,
    ),
  );
}