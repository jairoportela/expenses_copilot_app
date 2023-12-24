import 'package:query_repository/src/models/create_helper.dart';
import 'package:query_repository/src/models/exceptions.dart';
import 'package:query_repository/src/models/query_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

abstract class QueryRepository {
  Future<List<R>> getAll<R>({required QueryHelper<R> queryHelper});
  Future<bool> create({required CreateHelper createHelper});
  Future<R> createWithValue<R>(
      {required CreateHelperWithValue<R> createHelper});
}

class SupabaseQueryRepository extends QueryRepository {
  SupabaseQueryRepository({
    supabase.SupabaseClient? client,
  }) : _client = client ?? supabase.Supabase.instance.client;

  final supabase.SupabaseClient _client;

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

  @override
  Future<bool> create({required CreateHelper createHelper}) async {
    try {
      await _client.from(createHelper.tableName).insert(createHelper.data);
      return true;
    } on CreateError {
      rethrow;
    } catch (error) {
      throw const CreateError(
          message: 'Un error ha ocurrido al crear un elemento');
    }
  }

  @override
  Future<R> createWithValue<R>(
      {required CreateHelperWithValue<R> createHelper}) async {
    try {
      final data = await _client
          .from(createHelper.tableName)
          .insert(createHelper.data)
          .select(createHelper.selectString)
          .single();

      final result = createHelper.fromJson(data);
      return result;
    } on CreateError {
      rethrow;
    } catch (error) {
      throw const CreateError(message: 'Un error ha ocurrido');
    }
  }
}
