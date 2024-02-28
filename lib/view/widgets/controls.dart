import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Controls extends StatelessWidget {
  const Controls({required this.audioPlayer, super.key});
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: audioPlayer.seekToPrevious,
          iconSize: 60,
          color: Colors.white,
          icon: const Icon(Icons.skip_previous_rounded),
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final proccesingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(
                onPressed: audioPlayer.play,
                iconSize: 75,
                color: Colors.white,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (proccesingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                iconSize: 75,
                color: Colors.white,
                icon: const Icon(Icons.pause_rounded),
              );
            }

            return IconButton(
              onPressed: () => audioPlayer.seek(Duration.zero),
              iconSize: 75,
              color: Colors.white,
              icon: const Icon(Icons.replay_rounded),
            );
          },
        ),
        IconButton(
          onPressed: audioPlayer.seekToNext,
          iconSize: 60,
          color: Colors.white,
          icon: const Icon(Icons.skip_next_rounded),
        ),
      ],
    );
  }
}
