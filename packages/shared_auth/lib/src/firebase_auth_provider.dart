import 'package:riverpod/riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_service.dart';

/// A Riverpod provider to retrieve the global [FirebaseAuthService] instance.
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService(FirebaseAuth.instance);
});

/// A Riverpod StreamProvider that emits changes to the user's authentication session.
///
/// Can be watched by UI widgets to dynamically adapt screens based on login status.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  return authService.authStateChanges;
});
