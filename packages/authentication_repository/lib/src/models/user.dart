import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
    required this.finishOnboarding,
    this.email,
    this.profileImage,
    this.name,
  });

  /// The current user's email address.
  final String? email;

  /// The current user's profile image url.
  final String? profileImage;

  /// The current user's name.
  final String? name;

  /// The current user's id.
  final String id;

  final bool finishOnboarding;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '', finishOnboarding: false);

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, profileImage, name, finishOnboarding];
}
