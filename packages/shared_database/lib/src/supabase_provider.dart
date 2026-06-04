import 'package:riverpod/riverpod.dart';
import 'supabase_service.dart';

/// A Riverpod provider to access the [SupabaseService] instance throughout the application.
///
/// This provider must be overridden in the root [ProviderScope] or [ProviderContainer]
/// during application initialization:
///
/// ```dart
/// final supabaseService = SupabaseService(Supabase.instance.client);
/// 
/// ProviderScope(
///   overrides: [
///     supabaseServiceProvider.overrideWithValue(supabaseService),
///   ],
///   child: const MyApp(),
/// );
/// ```
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  throw UnimplementedError(
    'supabaseServiceProvider must be overridden in the root ProviderScope with an initialized SupabaseService instance.',
  );
});
