// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';

// class AudioRecorder {
//   FlutterSoundRecorder? _audioRecorder;
//   bool _isRecorderInitialized = false; // Manually track initialization state

//   Future<void> init() async {
//     _audioRecorder = FlutterSoundRecorder();
    
//     final status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw Exception('Microphone permission not granted');
//     }

//     await _audioRecorder!.openAudioSession();
//     _isRecorderInitialized = true;  // Set flag when initialized
//   }

//   void dispose() {
//     if (_isRecorderInitialized && _audioRecorder != null) {
//       _audioRecorder!.closeAudioSession();
//       _audioRecorder = null;
//       _isRecorderInitialized = false;
//     }
//   }

//   Future<void> startRecording() async {
//     if (!_isRecorderInitialized) throw Exception('Recorder not initialized');
//     await _audioRecorder!.startRecorder(toFile: 'audio_message.aac');
//   }

//   Future<String?> stopRecording() async {
//     if (!_isRecorderInitialized) throw Exception('Recorder not initialized');
//     final path = await _audioRecorder!.stopRecorder();
//     return path;
//   }
// }
