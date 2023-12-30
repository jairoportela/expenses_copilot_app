import 'package:authentication_repository/src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

abstract class AuthenticationRepository {
  Stream<User> get user;

  Future<bool> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  });

  Future<void> signOut();
}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class SupabaseAuthenticationRepository extends AuthenticationRepository {
  SupabaseAuthenticationRepository({required supabase.SupabaseClient client})
      : _supabase = client;

  final supabase.SupabaseClient _supabase;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  @override
  Stream<User> get user async* {
    try {
      final session = _supabase.auth.currentSession;
      final isSessionExpired = session?.isExpired;
      if (isSessionExpired != true && session != null) {
        final user = session.user;
        yield user.toUser;
      }
    } catch (_) {}
    yield* _supabase.auth.onAuthStateChange.asyncMap((data) async {
      final supabase.User? user = data.session?.user;
      if (user == null) return User.empty;
      return user.toUser;
    });
  }

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
}

extension on supabase.User {
  /// Maps a [supabase.User] into a [User].
  User get toUser {
    return User(
      id: id,
      email: email,
      name: userMetadata?['name'],
      profileImage: userMetadata?['photo_url'],
    );
  }
}
