import 'package:aptyou/presentation/widgets/letter_board.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:aptyou/logic/home_bloc/home_bloc.dart';
import 'package:aptyou/logic/home_bloc/home_event.dart';
import 'package:aptyou/logic/home_bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import 'package:rive/rive.dart' show RiveAnimation;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasPlayedAudio = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio() async {
    const audioUrl =
        'https://apty-read-bucket.s3.us-east-1.amazonaws.com/flutter_app_assets/lesson-2_topic-5/mp3/en_in_rq_L1_ls2_T5_Now_let%E2%80%99s_play_a_fun_game.mp3';
    await _audioPlayer.play(UrlSource(audioUrl));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadLessonData()),
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              if (!_hasPlayedAudio) {
                _hasPlayedAudio = true;
                _playAudio();
              }

              final backgroundUrl = state.userData.data?.backgroundAssetUrl;
              final topics = state.userData.data?.topics ?? [];
              final letters =
                  topics
                      .expand(
                        (topic) =>
                            topic.scriptTags.expand((tag) => tag.sampleWords),
                      )
                      .toList();

              return Stack(
                fit: StackFit.expand,
                children: [
                  if (backgroundUrl != null)
                    Positioned.fill(
                      child: Image.network(
                        backgroundUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(color: Colors.grey),
                      ),
                    ),
                  Positioned.fill(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        SizedBox(height: 40),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lesson: ${state.userData.data?.lessonId ?? ''}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                state.userData.data?.lessonName ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        if (letters.isNotEmpty)
                          LetterGameWidget(
                            letters: letters,
                            url: backgroundUrl ?? "",
                          )
                        else
                          const Text('No letters available from API'),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is HomeError) {
              return Center(child: Text(state.message));
            }

            return const Center(child: Text("Welcome"));
          },
        ),
      ),
    );
  }
}
