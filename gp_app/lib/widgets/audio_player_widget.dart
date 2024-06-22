// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';

// class AudioPlayerWidget extends StatefulWidget {
//   final String audioPath;

//   const AudioPlayerWidget({Key? key, required this.audioPath}) : super(key: key);

//   @override
//   _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
// }

// class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
//   FlutterSoundPlayer? _player;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _initPlayer();
//   }

//   Future<void> _initPlayer() async {
//     _player = FlutterSoundPlayer();
//     await _player!.openAudioSession();  // Change this line from openAudioSession
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _player!.closeAudioSession();  // Change this line from closeAudioSession
//     _player = null;
//     super.dispose();
//   }

//   void _togglePlay() async {
//     if (_isPlaying) {
//       await _player!.stopPlayer();
//     } else {
//       await _player!.startPlayer(fromURI: widget.audioPath);
//     }
//     setState(() {
//       _isPlaying = !_isPlaying;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//       onPressed: _togglePlay,
//     );
//   }
// }
