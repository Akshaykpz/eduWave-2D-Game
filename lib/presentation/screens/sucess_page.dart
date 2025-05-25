import 'dart:math';
import 'package:aptyou/logic/home_bloc/home_bloc.dart';
import 'package:aptyou/logic/home_bloc/home_event.dart';
import 'package:aptyou/logic/home_bloc/home_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' as rive;

class SuccessPage extends StatefulWidget {
  final int round;
  final bool isFinalRound;
  final VoidCallback onNextRound;
  final String backgroundUrl;
  const SuccessPage({
    super.key,
    required this.round,
    required this.isFinalRound,
    required this.onNextRound,
    required this.backgroundUrl,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          String? backgroundUrl;

          if (state is HomeLoaded) {
            backgroundUrl = state.userData.data?.backgroundAssetUrl;
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              if (backgroundUrl != null)
                rive.RiveAnimation.asset(
                  'assets/en_in_rq_L1_ls2_T5_1-4_round.riv',

                  fit: BoxFit.contain,
                ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Title Text
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Woohoo! ',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: "Round ${widget.round} done"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      "You’ve earned a T trophy  Look!\nAnother trophy for you!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 24),

                    const SizedBox(height: 24),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onNextRound();
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        label: Text(
                          widget.isFinalRound
                              ? "Restart Game"
                              : "Round ${widget.round + 1}",
                          style: const TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
