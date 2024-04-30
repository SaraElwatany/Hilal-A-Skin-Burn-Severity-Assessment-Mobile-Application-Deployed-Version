import 'package:flutter/material.dart';
import 'package:gp_app/models/patient_message.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/widgets/messages_widget.dart';
import 'package:gp_app/models/global.dart';
// import 'package:gp_app/Data/messages.dart';
import 'package:gp_app/widgets/audio_player_widget.dart';
import 'package:gp_app/widgets/audio_record_widget.dart';



class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() {
    return _ChatScreenState();
  }
}


class _ChatScreenState extends State<ChatScreen> {
  //marina
  List<ChatMessage> chatMessages = [];
  //
  final _messageController = TextEditingController();
  bool introMessageShown = false;

  final AudioRecorder _audioRecorder = AudioRecorder(); 
  bool isRecording = false; // Track recording state


  //marina
@override
  void initState() {
    super.initState();
    _audioRecorder.init(); // Initialize the recorder
  }


@override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (chatMessages.isEmpty && !introMessageShown) {
    chatMessages.add(ChatMessage(
      message: S.of(context).Intro, 
      receiver: false,
    ));
    introMessageShown = true; // Ensure we don't add the intro message again.
  }

  if (latestPrediction.isNotEmpty) {
    chatMessages.add(ChatMessage(
      message: latestPrediction,
      receiver: false,
    ));
    latestPrediction = ''; // Clear the prediction to avoid duplication.
  }
}

  //
  
  @override
  void dispose() {
    _messageController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    //marina
    final messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      setState(() {
        chatMessages.add(ChatMessage(message: messageText, receiver: true));
      });
      //marina
      _messageController.clear();
      
    }
  }

  void _toggleRecording() async {
    if (isRecording) {
      String? filePath = await _audioRecorder.stopRecording();
      if (filePath != null) {
        // Optionally handle the file path, like sending it as a message
      }
      setState(() {
        isRecording = false;
      });
    } else {
      await _audioRecorder.startRecording();
      setState(() {
        isRecording = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const LocalizationIcon(),
        body: Stack(
          children: [
            ListView.builder(
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              final chatMessage = chatMessages[index];
              if (chatMessage.audioUrl != null) {
                // If there's an audio URL, display both the audio player and the message text.
                return Column(
                  children: [
                    ListTile(
                      title: Text("Audio Message: Tap to play"),
                      subtitle: Text(chatMessage.message), // Displaying text message if available
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
                    icon: Icon(isRecording ? Icons.stop : Icons.mic),
                    onPressed: _toggleRecording,
                    color: isRecording ? Colors.red : Color.fromARGB(255, 10, 15, 153),
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
      chatMessages.add(ChatMessage(message: prediction, receiver: false));
    });
  }
//
}
