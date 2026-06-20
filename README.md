# Authentication Notes Manager

Flutter app with Firebase Authentication and Cloud Firestore where users can:

- Sign up
- Login and logout
- Create, view, edit, and delete personal notes
- See real-time note updates

## Tech Stack

- Flutter 3.x (Null Safety)
- Firebase Authentication
- Cloud Firestore
- Provider for presentation state
- Clean Architecture (data/domain/presentation)

## Firestore Structure

- Collection: `users`
	- Document: `{userId}`
	- Fields:
		- `name`
		- `email`

- Collection: `notes`
	- Document: `{noteId}`
	- Fields:
		- `userId`
		- `title`
		- `description`
		- `createdAt`
		- `updatedAt`

## Firebase Setup (Connect Your Own Account)

The app already contains all Firebase logic, but currently uses a placeholder `lib/firebase_options.dart`.

1. Install FlutterFire CLI:
	 - `dart pub global activate flutterfire_cli`
2. Configure Firebase in this project:
	 - `flutterfire configure`
3. Replace the generated `lib/firebase_options.dart` with your configured file.
4. Ensure Authentication (Email/Password) is enabled in Firebase Console.
5. Create Firestore database and add security rules.

Suggested starter Firestore rules:

```txt
rules_version = '2';
service cloud.firestore {
	match /databases/{database}/documents {
		match /users/{userId} {
			allow read, write: if request.auth != null && request.auth.uid == userId;
		}

		match /notes/{noteId} {
			allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
			allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
		}
	}
}
```

## Run

- `flutter pub get`
- `flutter run`
