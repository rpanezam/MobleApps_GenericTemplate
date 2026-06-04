library shared_database;

// Export the public Supabase service and Riverpod provider.
export 'src/supabase_service.dart';
export 'src/supabase_provider.dart';

// Re-export supabase_flutter so consuming packages do not need to import it separately.
export 'package:supabase_flutter/supabase_flutter.dart';
