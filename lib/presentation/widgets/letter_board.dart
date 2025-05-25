import 'dart:math';
import 'package:rive/rive.dart' as rive;
import 'package:aptyou/logic/home_bloc/home_bloc.dart';
import 'package:aptyou/logic/home_bloc/home_event.dart';
import 'package:aptyou/presentation/screens/sucess_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import 'package:audioplayers/audioplayers.dart';

class LetterGameWidget extends StatefulWidget {
  final String url;
  final List<String> letters;
  const LetterGameWidget({super.key, required this.letters, required this.url});

  @override
  State<LetterGameWidget> createState() => _LetterGameWidgetState();
}

class _LetterGameWidgetState extends State<LetterGameWidget> {
  int round = 1;
  int stepIndex = 0;
  final int totalRounds = 5;
  final String capitalT = 'T';
  final String smallT = 't';
  late Map<String, double> letterSizes;

  late List<String> displayLetters;
  late List<Offset> positions;
  late Map<String, Color> letterColors;
  String? message;

  final AudioPlayer _audioPlayer = AudioPlayer();

  final String audioTapCapitalT =
      "https://apty-read-bucket.s3.us-east-1.amazonaws.com/flutter_app_assets/lesson-2_topic-5/mp3/en_in_rq_L1_ls2_T5_Tap_on_Capital_T.mp3";
  final String audioTapSmallT =
      "https://apty-read-bucket.s3.us-east-1.amazonaws.com/flutter_app_assets/lesson-2_topic-5/mp3/en_in_rq_L1_ls2_T5_Now_tap_on_Small_t.mp3";
  final String audioWrongTap =
      "https://apty-read-bucket.s3.us-east-1.amazonaws.com/flutter_app_assets/lesson-2_topic-5/mp3/en_in_rq_L1_ls2_T5_Oops_Try_again_Look_carefully.mp3";
  final String audioSuccess =
      "https://apty-read-bucket.s3.us-east-1.amazonaws.com/flutter_app_assets/lesson-2_topic-5/mp3/en_in_rq_L1_ls2_T5_You_did_it.mp3";

  @override
  void initState() {
    super.initState();
    _startNewRound();
    _playInstructionAudio(audioTapCapitalT);
  }

  List<Offset> _generateNonOverlappingPositions(int count) {
    const double boxWidth = 360;
    const double boxHeight = 450;
    const double padding = 10;

    final Random random = Random();
    final List<Offset> positions = [];

    int attempts = 0;

    while (positions.length < count && attempts < 1000) {
      final dx = random.nextDouble() * (boxWidth - 80);
      final dy = random.nextDouble() * (boxHeight - 80);
      final newOffset = Offset(dx, dy);

      bool overlaps = positions.any(
        (pos) => (pos - newOffset).distance < 80 + padding,
      );

      if (!overlaps) {
        positions.add(newOffset);
      }

      attempts++;
    }

    return positions;
  }

  void _showLetterToast(
    String message,
    Color backgroundColor,
    Color iconColor,
    IconData icon,
  ) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 2),
      icon: Icon(icon, color: iconColor),
      primaryColor: Colors.orange,
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,
      closeOnClick: true,
      applyBlurEffect: true,
    );
  }

  void _startNewRound() {
    final random = Random();

    displayLetters = List.from(widget.letters);
    if (!displayLetters.contains(capitalT)) displayLetters.add(capitalT);
    if (!displayLetters.contains(smallT)) displayLetters.add(smallT);
    displayLetters.shuffle();

    letterSizes = {for (var l in displayLetters) l: 40.0 + random.nextInt(41)};

    positions = _generateNonOverlappingPositions(displayLetters.length);
    letterColors = {for (var l in displayLetters) l: Colors.grey};
    stepIndex = 0;
    message = null;
  }

  Future<void> _playInstructionAudio(String url) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(url));
  }

  void _onLetterTap(String letter) {
    setState(() {
      bool correctTap = false;

      if (stepIndex == 0 && letter == capitalT) {
        correctTap = true;
        letterColors[letter] = Colors.green;
        _showLetterToast(
          'Yeah! That is Capital T',
          Colors.white,
          const Color(0xFF1B5E20),
          Icons.check_circle,
        );
        message = "Great! Now find small t.";
        _playInstructionAudio(audioTapSmallT);
      } else if (stepIndex == 1 && letter == smallT) {
        correctTap = true;
        letterColors[letter] = Colors.green;
        _showLetterToast(
          'Yeah! That is small t',
          Colors.white,
          const Color(0xFF1B5E20),
          Icons.check_circle,
        );
        _playInstructionAudio(audioSuccess);
        _navigateToSuccessPage(round == totalRounds);
      }

      if (correctTap) {
        stepIndex++;
      } else {
        letterColors[letter] = Colors.red;
        message = "Wrong letter. Try again!";
        _showLetterToast(
          'Oops! Try again',
          Colors.orange,
          Colors.white,
          Icons.close,
        );
        _playInstructionAudio(audioWrongTap);
      }
    });
  }

  void _navigateToSuccessPage(bool isFinalRound) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => BlocProvider(
              create: (_) => HomeBloc()..add(LoadLessonData()),
              child: SuccessPage(
                round: round,
                isFinalRound: isFinalRound,
                onNextRound: () {
                  setState(() {
                    if (isFinalRound) {
                      round = 1;
                    } else {
                      round++;
                    }
                    _startNewRound();
                    _playInstructionAudio(audioTapCapitalT);
                    message = null;
                  });
                },
                backgroundUrl: widget.url,
              ),
            ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 20, color: Colors.black),
            children: [
              TextSpan(text: 'Tap on '),
              TextSpan(
                text: 'Capital T',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: ' then '),
              TextSpan(
                text: 'small t',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Text("Round: $round", style: const TextStyle(fontSize: 18)),
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(
          height: 450,
          width: 360,
          child: Stack(
            children: List.generate(displayLetters.length, (index) {
              final letter = displayLetters[index];
              final pos = positions[index];
              final size = letterSizes[letter] ?? 60.0;

              return Positioned(
                left: pos.dx,
                top: pos.dy,
                child: GestureDetector(
                  onTap: () => _onLetterTap(letter),
                  child: Container(
                    height: size,
                    width: size,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: letterColors[letter],
                    ),
                    child: Center(
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: size * 0.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
