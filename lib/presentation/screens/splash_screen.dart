import 'package:aptyou/logic/auth_bloc/auth_bloc.dart';
import 'package:aptyou/logic/auth_bloc/auth_event.dart';
import 'package:aptyou/logic/auth_bloc/auth_state.dart';
import 'package:aptyou/presentation/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/215472_small.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller
          ..setLooping(true)
          ..play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_controller.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),

          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              } else if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              return Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(GoogleSignInRequested());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text(
                      "Sign in with Google",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
