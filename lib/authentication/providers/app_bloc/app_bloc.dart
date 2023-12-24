import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          const AppState.unauthenticated(),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onUserChanged(
      AppUserChanged event, Emitter<AppState> emit) async {
    await emit.forEach(_authenticationRepository.user, onData: (user) {
      if (user.id.isEmpty) {
        return const AppState.unauthenticated();
      } else {
        return AppState.authenticated(user);
      }
    });
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.signOut());
  }
}
