import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/models/global.dart';
import 'package:gp_app/apis/apis.dart';

import 'package:gp_app/models/chat_message.dart';
import 'package:gp_app/widgets/messages_widget.dart';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:gp_app/widgets/audio_player_widget.dart';




class PatientModelChat extends StatefulWidget {
  final int senderId;
  final int receiverId;

  const PatientModelChat({
    Key? key,
    required this.senderId, // Patient
    required this.receiverId, // Doctor
  }) : super(key: key);

  @override
  State<PatientModelChat> createState() => PatientModelChatState();
}

class PatientModelChatState extends State<PatientModelChat> {
  List<ChatMessage> messages = [];
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  final TextEditingController _messageController = TextEditingController();
  bool introMessageShown = false;


  //marina
  @override
    void initState() {
      super.initState();
      loadChatHistory();
      AudioApi.initRecorder();
    }

  @override
  void dispose() {
    AudioApi.closeRecorder();
    _messageController.dispose();
    super.dispose();
  }

  void loadChatHistory() async {
      try {
        List<ChatMessage> fetchedMessages = await fetchChatHistory(widget.senderId, widget.receiverId);
        setState(() {
          messages = fetchedMessages;
        });
      } catch (e) {
        print("Failed to load chat history: $e");
      }
    }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (messages.isEmpty && !introMessageShown) {
      messages.add(ChatMessage(
        message: S.of(context).Intro, 
        receiver: false,
        timestamp: DateTime.now(),
      ));
      introMessageShown = true; // Ensure we don't add the intro message again.
    }

    if (latestPrediction.isNotEmpty) {
      messages.add(ChatMessage(
        message: latestPrediction,
        receiver: false,
        timestamp: DateTime.now(),
      ));
      latestPrediction = ''; // Clear the prediction to avoid duplication.
    }
  }

  
  void _toggleRecording() async {
    if (_isRecording) {
      final path = await _recorder.stopRecorder();
      if (path != null) {
        setState(() {
          messages.add(ChatMessage(
            message: 'New audio message',
            audioUrl: path,
            receiver: false,
            timestamp: DateTime.now(),
          ));
        });
      }
      setState(() {
        _isRecording = false;
      });
    } else {
      await _recorder.startRecorder(toFile: 'audio_message.aac');
      setState(() {
        _isRecording = true;
      });
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(
          message: text,
          receiver: true,
          timestamp: DateTime.now(),
        ));
        _messageController.clear();
      });
      // TODO: Implement send message to server logic here
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const LocalizationIcon(),
        body: Stack(
          children: [
            ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final chatMessage = messages[index];
              if (chatMessage.audioUrl != null) {
                // If there's an audio URL, display both the audio player and the message text.
                return Column(
                  children: [
                    ListTile(
                      title: Text(chatMessage.message),
                      subtitle: Text(chatMessage.receiver ? "Doctor" : "Patient"), // Displaying text message if available
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: AudioPlayerWidget(audioPath: chatMessage.audioUrl!),
                    ),
                  ],
                );
              } else {
                // Otherwise, render the text message as usual
                return MessagesWidget(
                  chatMessage: chatMessage,
                  introMessage: null,
                );
              }
            },
          ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 16, bottom: 10, right: 16),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 106, 105, 105),
                  ),
                  child: Row(children: [
                     IconButton(
                    icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                    onPressed: _toggleRecording,
                    color: _isRecording ? Colors.red : Color.fromARGB(255, 10, 15, 153),
                  ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        textCapitalization: TextCapitalization.sentences,
                        autocorrect: true,
                        enableSuggestions: true,
                        decoration:
                            InputDecoration(hintText: S.of(context).message),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(
                          Icons.send,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ));
  }

//marina
  void updateChatScreenWithPrediction(String prediction) {
    setState(() {
      messages.add(ChatMessage(message: prediction, receiver: false));
    });
  }
//
}
