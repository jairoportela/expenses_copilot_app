import 'package:query_repository/src/models/exceptions.dart';
import 'package:query_repository/src/models/query_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

abstract class QueryRepository {
  QueryRepository({
    supabase.SupabaseClient? supabaseClient,
  }) : _client = supabaseClient ?? supabase.Supabase.instance.client;

  final supabase.SupabaseClient _client;

  Future<List<R>> getAll<R>({required QueryHelper<R> queryHelper});
}

class SupabaseQueryRepository extends QueryRepository {
  @override
  Future<List<R>> getAll<R>({required QueryHelper<R> queryHelper}) async {
    try {
      final data = await _getQuery(queryHelper);

      if (data == null) throw const QueryError(message: '');
      final result = data.map((e) => queryHelper.fromJson(e)).toList();
      return result;
    } on QueryError {
      rethrow;
    } catch (error) {
      throw const QueryError(message: 'Un error ha ocurrido');
    }
  }

  supabase.PostgrestFilterBuilder<List<Map<String, dynamic>>?> _getQuery(
      QueryHelper queryHelper) {
    var query =
        _client.from(queryHelper.tableName).select(queryHelper.selectString);
    if (queryHelper.filter != null) {
      query.match(queryHelper.filter!);
    }
    return query;
  }
}
