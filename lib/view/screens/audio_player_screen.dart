import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auido_player/models/position_data.dart';
import 'package:auido_player/view/widgets/controls.dart';
import 'package:auido_player/view/widgets/media_meta_data.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;

  final _playlist = ConcatenatingAudioSource(
    children: [
      AudioSource.uri(
        Uri.parse(
          'https://firebasestorage.googleapis.com/v0/b/striped-reserve-383101.appspot.com/o/sounds%2F396hz.mp3?alt=media&token=705339f6-6008-4c65-b038-2cca2c846177',
        ),
        tag: MediaItem(
          id: '0',
          title: '396 hz',
          artist: 'Spiroot',
          artUri: Uri.parse(
            'https://images.unsplash.com/photo-1554832307-e5e32d164958?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          ),
        ),
      ),
      AudioSource.uri(
        Uri.parse(
          'https://firebasestorage.googleapis.com/v0/b/striped-reserve-383101.appspot.com/o/sounds%2F639hz.mp3?alt=media&token=34c46379-7969-4ead-a9d1-0e0495089ccf',
        ),
        tag: MediaItem(
          id: '1',
          title: '639 hz',
          artist: 'Spiroot',
          artUri: Uri.parse(
            'https://images.unsplash.com/photo-1503919275948-1f118d8ecf0b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8c3Bpcml0dWFsfGVufDB8fDB8fHww',
          ),
        ),
      ),
      AudioSource.uri(
        Uri.parse(
          'https://firebasestorage.googleapis.com/v0/b/striped-reserve-383101.appspot.com/o/sounds%2F852hz.mp3?alt=media&token=d543df86-8dd4-43b2-9d9b-9cc8e8ed2b26',
        ),
        tag: MediaItem(
          id: '2',
          title: '852 hz',
          artist: 'Spiroot',
          artUri: Uri.parse(
            'https://images.unsplash.com/photo-1538024333176-f25f63f873ee?q=80&w=1886&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          ),
        ),
      ),
    ],
  );

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  void initState() {
    super.initState();
    //_audioPlayer = AudioPlayer()..setAsset('assets/audio/396hz.mp3');
    // _audioPlayer = AudioPlayer()
    //   ..setUrl('https://www.youtube.com/watch?v=cDT7OitB17M');
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playlist);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff1447771),
              Color(0xFF071A2C),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return MediaMetaData(
                  imageUrl: metadata.artUri.toString(),
                  title: metadata.title,
                  artist: metadata.artist ?? '',
                );
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final PositionData = snapshot.data;
                return ProgressBar(
                  barHeight: 8,
                  baseBarColor: Colors.grey[600],
                  bufferedBarColor: Colors.grey[400],
                  progressBarColor: Colors.red,
                  thumbColor: Colors.red,
                  timeLabelTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  progress: PositionData?.position ?? Duration.zero,
                  buffered: PositionData?.bufferedPosition ?? Duration.zero,
                  total: PositionData?.duration ?? Duration.zero,
                  onSeek: _audioPlayer.seek,
                );
              },
            ),
            const SizedBox(height: 20),
            Controls(audioPlayer: _audioPlayer),
          ],
        ),
      ),
    );
  }
}
