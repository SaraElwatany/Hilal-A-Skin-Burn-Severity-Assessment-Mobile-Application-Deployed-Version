import 'package:flutter/material.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/models/global.dart';
import 'package:gp_app/apis/apis.dart';
import 'package:gp_app/models/my_state.dart';
import 'package:provider/provider.dart';

import 'package:gp_app/models/chat_message.dart';
import 'package:gp_app/widgets/docter_model_widget.dart';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:gp_app/widgets/audio_player_widget.dart';



class DocterModelChat extends StatefulWidget {

  const DocterModelChat({
    Key? key,
  }) : super(key: key);

  @override
  State<DocterModelChat> createState() => DocterModelChatState();
}

class DocterModelChatState extends State<DocterModelChat> {

  //marina
  List<ChatMessage> messages = [];
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadChatHistory();
    // AudioApi.initRecorder();
  }

 @override
  void dispose() {
    // AudioApi.closeRecorder();
    _messageController.dispose();
    super.dispose();
  }

  void loadChatHistory() async {
  final myState = Provider.of<MyState>(context, listen: false);
  String userId = myState.userId;

    try {
      List<ChatMessage> fetchedMessages = await fetchChatHistory(userId, '1'); // Receiver ID set to 1
      setState(() {
        messages = fetchedMessages;
      });
    } catch (e) {
      print("Failed to load chat history: $e");
    }
  }
    

  void _toggleRecording() async {
    final myState = Provider.of<MyState>(context, listen: false);
    String userId = myState.userId;

    if (_isRecording) {
      final path = await _recorder.stopRecorder();
      if (path != null) {
        setState(() {
          messages.add(ChatMessage(
            message: 'New audio message',
            // audioUrl: path,
            receiver: false,
            timestamp: DateTime.now(),
            senderId: userId,
            receiverId: '1'
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
  final myState = Provider.of<MyState>(context, listen: false);
    String userId = myState.userId;

    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final message = ChatMessage(
          message: text,
          receiver: true,
          image: null,
          // audioUrl: null,
          timestamp: DateTime.now(),
          senderId: userId,
          receiverId: '1');

      // Send the message to the server
      sendMessageToServer(message);

      setState(() {
        messages.add(message);
        _messageController.clear();
      });
    }
    else print('message is empty');
  }

//marina

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
              if (chatMessage.message != null) {
                // If there's an audio URL, display both the audio player and the message text.
                return Column(
                  children: [
                    ListTile(
                      title: Text(chatMessage.message),
                      subtitle:  Text(chatMessage.receiver ? "Doctor" : "Patient"),// Displaying text message if available
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      // child: AudioPlayerWidget(audioPath: chatMessage.audioUrl!),
                    ),
                  ],
                );
              } 
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.only(left: 16, bottom: 10, right: 16),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 106, 105, 105),
                ),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      // controller: _messageController,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration:
                          InputDecoration(hintText: S.of(context).message),
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  //   onPressed: _toggleRecording,
                  //   color: _isRecording ? Colors.red : Colors.white,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: IconButton(
                      onPressed: () {}, // Implement send message logic here
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
      ),
    );
  }
}
