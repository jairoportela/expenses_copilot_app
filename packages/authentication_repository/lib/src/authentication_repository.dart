import 'dart:developer';

import 'package:authentication_repository/src/models/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

enum AuthenticationSteps { logged, registered, notLogged }

abstract class AuthenticationRepository {
  Stream<User> getUser();

  Future<bool> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  });
  Future<bool> updateMetadataUser({
    required Map<String, dynamic> data,
  });

  Future<void> signOut();
}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class SupabaseAuthenticationRepository extends AuthenticationRepository {
  SupabaseAuthenticationRepository({required supabase.SupabaseClient client})
      : _supabase = client {
    _init();
  }

  final supabase.SupabaseClient _supabase;

  final _userStreamController = BehaviorSubject<User>.seeded(User.empty);

  void _init() {
    _userStreamController
        .addStream(_supabase.auth.onAuthStateChange.asyncMap((data) async {
      log(data.event.toString(), name: 'onAuthStateChange');
      final supabase.User? user = data.session?.user;
      if (user == null) {
        return User.empty;
      }
      return user.toUser;
    }));
  }

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  @override
  Stream<User> getUser() => _userStreamController.asBroadcastStream();

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  @override
  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await _supabase.auth.signUp(email: email, password: password, data: {
        'name': username,
        'finish_onboarding': false,
      });
      return true;
    } on supabase.AuthException catch (e) {
      if (e.message == 'User already registered') {
        throw EmailAlreadyRegisteredException();
      }
      throw SignUpWithEmailAndPasswordFailure.fromException(e);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  @override
  Future<bool> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
      return true;
    } on supabase.AuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromException(e);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (_) {}
  }

  @override
  Future<bool> updateMetadataUser({required Map<String, dynamic> data}) async {
    try {
      final response = await _supabase.auth.updateUser(supabase.UserAttributes(
        data: data,
      ));
      if (response.user != null) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }
}

extension on supabase.User {
  /// Maps a [supabase.User] into a [User].
  User get toUser {
    return User(
      id: id,
      email: email,
      name: userMetadata?['name'],
      profileImage: userMetadata?['photo_url'],
      finishOnboarding: userMetadata?['finish_onboarding'] ?? false,
    );
  }
}
