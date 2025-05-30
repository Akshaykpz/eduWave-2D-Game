import 'package:aptyou/data/auth_repository.dart';
import 'package:aptyou/data/auth_proivder.dart';
import 'package:aptyou/logic/auth_bloc/auth_bloc.dart';
import 'package:aptyou/logic/home_bloc/home_bloc.dart';
import 'package:aptyou/logic/home_bloc/home_event.dart';
import 'package:aptyou/presentation/screens/home_page.dart';

import 'package:aptyou/data/api_client.dart';
import 'package:aptyou/presentation/screens/splash_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final loggedIn = await isLoggedIn();
  runApp(MyApp(isLoggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    final apiClient = ApiClient(dio);
    final authRepository = AuthRepository(apiClient: apiClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc()..add(LoadLessonData()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: isLoggedIn ? const HomePage() : const SplashScreen(),
        // home: RiveDemo(),
      ),
    );
  }
}
