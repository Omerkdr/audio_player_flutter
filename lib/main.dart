// ignore_for_file: prefer_const_constructors

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:auido_player/models/position_data.dart';
import 'package:auido_player/view/screens/audio_player_screen.dart';
import 'package:auido_player/view/widgets/controls.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import 'package:auido_player/view/widgets/media_meta_data.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelName: 'Spiroot',
    androidNotificationChannelDescription: 'Spiroot',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Audio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AudioPlayerScreen(),
    );
  }
}
