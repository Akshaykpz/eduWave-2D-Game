import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveDemo extends StatefulWidget {
  final int round;
  final bool isFinalRound;
  final VoidCallback onNextRound;
  final String backgroundUrl;

  const RiveDemo({
    super.key,
    required this.round,
    required this.isFinalRound,
    required this.onNextRound,
    required this.backgroundUrl,
  });

  @override
  State<RiveDemo> createState() => _RiveDemoState();
}

class _RiveDemoState extends State<RiveDemo> {
  RiveFile? _riveFile;
  StateMachineController? _controller;
  SMINumber? stateInput;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    try {
      final riveUrl =
          widget.round == 5
              ? 'https://apty-read-bucket.s3.us-east-1.amazonaws.com/flutter_app_assets/lesson-2_topic-5/rive/en_in_rq_L1_ls2_T5_final_round.riv'
              : 'https://apty-read-bucket.s3.us-east-1.amazonaws.com/flutter_app_assets/lesson-2_topic-5/rive/en_in_rq_L1_ls2_T5_1-4_round.riv';

      final file = await RiveFile.network(riveUrl);

      setState(() {
        _riveFile = file;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onRiveInit(Artboard artboard) {
    final stateMachines = artboard.stateMachines;
    if (stateMachines.isEmpty) {
      return;
    }

    final stateMachine = stateMachines.first;
    _controller = StateMachineController.fromArtboard(
      artboard,
      stateMachine.name,
    );

    if (_controller != null) {
      artboard.addController(_controller!);
      stateInput = _controller!.findSMI('T') as SMINumber?;
      if (stateInput != null) {
        stateInput!.value = widget.round.toDouble();
      }
    }
  }

  @override
  void didUpdateWidget(covariant RiveDemo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.round != widget.round) {
      if (stateInput != null) {
        stateInput!.value = widget.round.toDouble();
      }

      // Reload Rive file if we switch to final round
      if (widget.isFinalRound && !oldWidget.isFinalRound) {
        _loadRiveFile();
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                fit: StackFit.expand,
                children: [
                  // Rive animation in the background
                  _riveFile != null
                      ? RiveAnimation.direct(
                        _riveFile!,
                        onInit: _onRiveInit,
                        fit: BoxFit.cover,
                      )
                      : const Center(child: Text('Failed to load animation')),

                  // Overlay content
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 32.0,
                      ),
                      child: Column(
                        children: [
                          // Text at top
                          Column(
                            children: [
                              Text(
                                "Woohoo! Round ${widget.round} done!",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8,
                                      color: Colors.green,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "You’ve earned a T trophy 🎉 Look!\nAnother trophy for you!",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8,
                                      color: Colors.black,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const Spacer(),

                          // Button at bottom
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
                  ),
                ],
              ),
    );
  }
}
