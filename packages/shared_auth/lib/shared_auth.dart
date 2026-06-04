library shared_auth;

// Export the Firebase Authentication service and Riverpod providers.
export 'src/firebase_auth_service.dart';
export 'src/firebase_auth_provider.dart';

// Re-export firebase_auth so consuming applications can access core classes (e.g. User, UserCredential).
export 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_core/firebase_core.dart';
