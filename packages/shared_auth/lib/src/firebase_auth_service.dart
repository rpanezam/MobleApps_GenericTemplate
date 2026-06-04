import 'dart:async';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Reusable Firebase Authentication Service for the App Factory platform.
/// Handles user login, registration, password resets, and session monitoring.
class FirebaseAuthService {
  final FirebaseAuth _auth;
  final _secureStorage = const FlutterSecureStorage();

  // Brute force protection state tracking (in-memory)
  final Map<String, int> _failedAttempts = {};
  final Map<String, DateTime> _lockoutTimes = {};

  FirebaseAuthService(this._auth);

  /// Access the underlying [FirebaseAuth] instance directly if required.
  FirebaseAuth get auth => _auth;

  /// Stream of [User?] that emits changes to the authentication state.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Retrieve the currently authenticated [User] (if any).
  User? get currentUser => _auth.currentUser;

  /// Sign in using an email and password.
  /// Implements brute-force protection with max 5 failed attempts and 15-minute lockout.
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final now = DateTime.now();

    // Check if account is currently locked out
    if (_lockoutTimes.containsKey(email)) {
      final lockoutExpiry = _lockoutTimes[email]!;
      if (now.isBefore(lockoutExpiry)) {
        final remainingTime = lockoutExpiry.difference(now);
        throw Exception(
          'Too many failed attempts. This account is temporarily locked out. '
          'Please try again in ${remainingTime.inMinutes} minutes and ${remainingTime.inSeconds % 60} seconds.',
        );
      } else {
        // Lockout expired, clean up lockout status
        _lockoutTimes.remove(email);
        _failedAttempts[email] = 0;
      }
    }

    final failedAttempts = _failedAttempts[email] ?? 0;

    // Apply exponential backoff between retries (e.g. pow(2, failedAttempts) seconds delay)
    if (failedAttempts > 0) {
      final backoffSeconds = math.pow(2, failedAttempts).toInt();
      await Future.delayed(Duration(seconds: backoffSeconds));
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Reset tracking on successful sign-in
      _failedAttempts.remove(email);
      _lockoutTimes.remove(email);

      // Securely persist login status/metadata
      await _secureStorage.write(key: 'last_login_method', value: 'email');
      await _secureStorage.write(key: 'last_login_time', value: now.toIso8601String());

      return credential;
    } on FirebaseAuthException catch (e) {
      // Increment failed attempts
      final newFailedAttempts = failedAttempts + 1;
      _failedAttempts[email] = newFailedAttempts;

      if (newFailedAttempts >= 5) {
        _lockoutTimes[email] = now.add(const Duration(minutes: 15));
        throw Exception(
          'Too many failed attempts. This account has been locked for 15 minutes.',
        );
      }

      throw Exception('Firebase Sign-In Exception [${e.code}]: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Sign-In Exception: $e');
    }
  }

  /// Sign in using Google OAuth.
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In aborted by user');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Persist login method and time securely
      await _secureStorage.write(key: 'last_login_method', value: 'google');
      await _secureStorage.write(key: 'last_login_time', value: DateTime.now().toIso8601String());

      return userCredential;
    } catch (e) {
      throw Exception('Google Sign-In Exception: $e');
    }
  }

  /// Sign in using Apple OAuth.
  Future<UserCredential> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Persist login method and time securely
      await _secureStorage.write(key: 'last_login_method', value: 'apple');
      await _secureStorage.write(key: 'last_login_time', value: DateTime.now().toIso8601String());

      return userCredential;
    } catch (e) {
      throw Exception('Apple Sign-In Exception: $e');
    }
  }

  /// Register a new user using an email and password.
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Firebase Sign-Up Exception [${e.code}]: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Sign-Up Exception: $e');
    }
  }

  /// Send a password reset email.
  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception('Firebase Password Reset Exception [${e.code}]: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected Password Reset Exception: $e');
    }
  }

  /// Terminate the active user session.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      await _secureStorage.delete(key: 'last_login_method');
      await _secureStorage.delete(key: 'last_login_time');
    } catch (e) {
      throw Exception('Firebase Sign-Out Exception: $e');
    }
  }
}
