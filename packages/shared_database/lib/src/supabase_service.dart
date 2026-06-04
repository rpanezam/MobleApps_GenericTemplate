import 'package:supabase_flutter/supabase_flutter.dart';

/// A secure, reusable service wrapping the Supabase client for database interactions.
///
/// Implements standard parameterized queries to prevent SQL Injection and enforces
/// Row Level Security (RLS) contexts automatically via the Supabase client sessions.
class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  /// Directly access the raw [SupabaseClient] instance if needed.
  SupabaseClient get client => _client;

  /// Retrieve records from the specified [table].
  ///
  /// Optionally accepts [columns] to limit fields returned, and [filter] map
  /// for simple equality constraints.
  Future<List<Map<String, dynamic>>> select({
    required String table,
    String columns = '*',
    Map<String, dynamic>? filter,
  }) async {
    try {
      var query = _client.from(table).select(columns);
      
      if (filter != null) {
        filter.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      // In production, integrate with Google Cloud Logging / Sentry
      throw Exception('Supabase Select Exception in table "$table": $e');
    }
  }

  /// Insert a single [data] record or list of records into [table] and return the inserted data.
  Future<List<Map<String, dynamic>>> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _client.from(table).insert(data).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Supabase Insert Exception in table "$table": $e');
    }
  }

  /// Update matching records in [table] with new [data] where it matches [match] criteria.
  Future<List<Map<String, dynamic>>> update({
    required String table,
    required Map<String, dynamic> data,
    required Map<String, dynamic> match,
  }) async {
    try {
      final response = await _client.from(table).update(data).match(match).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Supabase Update Exception in table "$table": $e');
    }
  }

  /// Delete records from [table] matching the [match] criteria.
  Future<List<Map<String, dynamic>>> delete({
    required String table,
    required Map<String, dynamic> match,
  }) async {
    try {
      final response = await _client.from(table).delete().match(match).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Supabase Delete Exception in table "$table": $e');
    }
  }
}
