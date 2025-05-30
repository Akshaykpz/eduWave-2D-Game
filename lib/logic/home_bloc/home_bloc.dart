import 'dart:developer';

import 'package:aptyou/logic/home_bloc/home_event.dart'
    show HomeEvent, LoadLessonData;
import 'package:aptyou/logic/home_bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:aptyou/data/user_get_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadLessonData>(_onLoadLessonData);
  }

  Future<void> _onLoadLessonData(
    LoadLessonData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        emit(HomeError("Token not found"));
        return;
      }

      final dio = Dio();
      log(token);
      final response = await dio.get(
        'http://13.60.220.96:8000/content/v5/sample-assets',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final userData = UserGetModel.fromJson(response.data);

        // Store if needed
        await prefs.setString('lesson_id', userData.data?.lessonId ?? '');

        emit(HomeLoaded(userData));
      } else {
        emit(HomeError("Failed to load data: ${response.data['message']}"));
      }
    } catch (e) {
      emit(HomeError("Error: $e"));
    }
  }
}
