import 'dart:developer';

import '../src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

abstract class CrudRepository {
  Future<List<R>> getAll<R>({required QueryHelper<R> queryHelper});
  Future<R> getOne<R>({required QueryHelper<R> queryHelper});
  Future<bool> create({required CreateHelper createHelper});
  Future<bool> createMany({required CreateManyHelper createHelper});
  Future<bool> edit({required EditHelper editHelper});
  Future<bool> delete({required DeleteHelper deleteHelper});
  Future<R> createWithValue<R>(
      {required CreateHelperWithValue<R> createHelper});
  supabase.SupabaseStreamFilterBuilder subscribe(
      {required SubscribeHelper subscribeHelper});
}

class SupabaseCrudRepository extends CrudRepository {
  SupabaseCrudRepository({
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

  @override
  Future<R> getOne<R>({required QueryHelper<R> queryHelper}) async {
    try {
      final data = await _getQuery(queryHelper).limit(1).single();
      return queryHelper.fromJson(data);
    } on QueryError {
      rethrow;
    } catch (error) {
      throw const QueryError(message: 'Un error ha ocurrido');
    }
  }

  supabase.PostgrestTransformBuilder<List<Map<String, dynamic>>?> _getQuery(
      QueryHelper queryHelper) {
    var query =
        _client.from(queryHelper.tableName).select(queryHelper.selectString);
    if (queryHelper.filter != null) {
      query = query.match(queryHelper.filter!);
    }
    if (queryHelper.inFilter != null) {
      query = query.inFilter(
        queryHelper.inFilter!.columnName,
        queryHelper.inFilter!.dataToFilter,
      );
    }

    supabase.PostgrestTransformBuilder<List<Map<String, dynamic>>?> queryOrder =
        query;

    //Siempre debe ir de ultimo el order
    if (queryHelper.orderFilter != null) {
      for (var orderData in queryHelper.orderFilter!) {
        queryOrder = queryOrder.order(
          orderData.columnName,
          ascending: orderData.ascending,
        );
      }
    }

    return queryOrder;
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
  Future<bool> edit({required EditHelper editHelper}) async {
    try {
      await _client
          .from(editHelper.tableName)
          .update(editHelper.data)
          .eq(editHelper.columnName, editHelper.value);
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

  @override
  supabase.SupabaseStreamFilterBuilder subscribe(
      {required SubscribeHelper subscribeHelper}) {
    return _client
        .from(subscribeHelper.tableName)
        .stream(primaryKey: subscribeHelper.primaryKey);
  }

  @override
  Future<bool> delete({required DeleteHelper deleteHelper}) async {
    try {
      await _client.from(deleteHelper.tableName).delete().eq(
            deleteHelper.columnName,
            deleteHelper.valueToDelete,
          );
      return true;
    } on CreateError {
      rethrow;
    } catch (error) {
      throw const CreateError(
          message: 'Un error ha ocurrido al crear un elemento');
    }
  }

  @override
  Future<bool> createMany({required CreateManyHelper createHelper}) async {
    try {
      await _client.from(createHelper.tableName).insert(createHelper.data);
      return true;
    } on CreateError {
      rethrow;
    } catch (error) {
      log(error.toString(), name: 'CreateManyHelper error');
      throw const CreateError(
          message: 'Un error ha ocurrido al crear los elementos');
    }
  }
}
