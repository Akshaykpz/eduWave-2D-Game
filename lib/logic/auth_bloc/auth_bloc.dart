import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../data/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<GoogleSignInRequested>(_handleGoogleSignIn);
    on<SignOutRequested>(_handleSignOut);
  }

  Future<void> _handleGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final success = await authRepository.signInAndCallApi();
      if (success) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthError("Login failed."));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _handleSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.signOut();
    emit(AuthSignedOut());
  }
}
