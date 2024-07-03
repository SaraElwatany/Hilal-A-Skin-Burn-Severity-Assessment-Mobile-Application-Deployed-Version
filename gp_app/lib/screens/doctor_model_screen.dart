import 'package:flutter/material.dart';
import 'package:gp_app/apis/apis.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/models/chat_message.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/widgets/docter_model_widget.dart';

// Newly Added Imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_app/utils/app_bottom_sheet.dart';
import 'package:gp_app/models/voice_note_model.dart';
import 'package:gp_app/screens/patient_location.dart';
import 'package:gp_app/widgets/audio_recorder_view.dart';
import 'package:gp_app/manager/voice_note_manager/voive_noter_cubit.dart';
import 'package:gp_app/manager/voice_note_manager/audio_recorder_file.dart';

// import 'package:gp_app/models/my_state.dart';
// import 'package:provider/provider.dart';
// import 'package:gp_app/manager/voice_note_manager/voice_note_state.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class DocterModelChat extends StatefulWidget {
  const DocterModelChat({
    Key? key,
  }) : super(key: key);

  @override
  State<DocterModelChat> createState() => DocterModelChatState();
}

class DocterModelChatState extends State<DocterModelChat> {
  // marina
  List<ChatMessage> messages = [];
  // final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  // bool _isRecording = false;
  final TextEditingController _messageController = TextEditingController();
  static final GlobalKey<DocterModelChatState> _key =
      GlobalKey<DocterModelChatState>();

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
    try {
      int patientID = await SessionManager.getScreenIndex() ?? 0;
      print("Patient ID Associated With the pressed thread");

      int burnId = int.parse(await SessionManager.getBurnId() ?? '0');
      print("Burn ID Associated with that index tapped");

      List<ChatMessage> fetchedMessages =
          await fetchChatHistory(1, patientID, burnId); // Receiver ID set to 1
      setState(() {
        messages = fetchedMessages;
      });
    } catch (e) {
      print("Failed to load chat history: $e");
    }
  }

  // Static method to be called from outside
  static void sendMessageStatic(String dr_msg, int dr) {
    print('Entered sendMessageStatic');
    if (_key.currentState == null) {
      print('_key.currentState is null');
    } else {
      print('_key.currentState is not null');
      _key.currentState!.sendMessage(dr_msg, dr);
    }
  }

  void addMessage(String dr_msg, int dr) {
    print("Entered Add Message");
    sendMessage(dr_msg, dr);
  }

  void sendMessage(String dr_msg, int dr) async {
    int patientID = await SessionManager.getScreenIndex() ?? 0;
    print("Patient ID Associated With the pressed thread");

    int burnId = int.parse(await SessionManager.getBurnId() ?? '0');
    print("Burn ID Associated with that index tapped: $burnId");

    if (dr == 1) {
      final message_dr = ChatMessage(
          message: dr_msg,
          receiver: false,
          show_btn: false,
          image: null,
          timestamp: DateTime.now(),
          voiceNote: null,
          senderId: 3,
          receiverId: 1,
          imgFlag: 0,
          burnId: burnId);

      // Send the message of the dr to the server
      sendMessageToServer(message_dr);

      setState(() {
        messages.add(message_dr);
        _messageController.clear();
      });
    } else {
      final text = _messageController.text.trim();
      if (text.isNotEmpty) {
        final message = ChatMessage(
            message: text,
            receiver: true,
            show_btn: false,
            image: null,
            voiceNote: null,
            timestamp: DateTime.now(),
            senderId: 1,
            receiverId: patientID,
            burnId: burnId,
            imgFlag: 0);

        // Send the message to the server
        sendMessageToServer(message);

        setState(() {
          messages.add(message);
          _messageController.clear();
        });
      } else
        print('message is empty');
    }
  }

  // void _toggleRecording() async {
  //   final myState = Provider.of<MyState>(context, listen: false);
  //   String userId = myState.userId;

  //   if (_isRecording) {
  //     final path = await _recorder.stopRecorder();
  //     if (path != null) {
  //       setState(() {
  //         messages.add(ChatMessage(
  //           message: 'New audio message',
  //           receiver: false,
  //           timestamp: DateTime.now(),
  //           senderId: userId,
  //           receiverId: '1'
  //         ));
  //       });
  //     }
  //     setState(() {
  //       _isRecording = false;
  //     });
  //   } else {
  //     await _recorder.startRecorder(toFile: 'audio_message.aac');
  //     setState(() {
  //       _isRecording = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VoiceNotesCubit(AudioRecorderFileHelper()),
      child: Scaffold(
        appBar: const LocalizationIcon(),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final chatMessage = messages[index];
                return DoctorMessagesWidget(
                    doctorMessage: chatMessage, addMessage: addMessage);
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: true,
                          enableSuggestions: true,
                          decoration: InputDecoration(
                            hintText: S.of(context).message,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => sendMessage('', 0),
                        icon: const Icon(Icons.send),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Location()),
                          );
                        },
                        icon: const Icon(Icons.location_on_outlined),
                      ),
                      IconButton(
                        onPressed: () async {
                          final VoiceNoteModel? newVoiceNote =
                              await showAppBottomSheet(context,
                                  builder: (context) {
                            return const AudioRecorderView();
                          });

                          if (newVoiceNote != null && context.mounted) {
                            context
                                .read<VoiceNotesCubit>()
                                .addToVoiceNotes(newVoiceNote);
                          }
                        },
                        icon: const Icon(Icons.mic),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}













//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => VoiceNotesCubit(AudioRecorderFileHelper()),
//       child: Scaffold(
//         appBar: const LocalizationIcon(),
//         body: Stack(
//           children: [
//             ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final chatMessage = messages[index];
//                 return DoctorMessagesWidget(
//                     doctorMessage: chatMessage, addMessage: addMessage);
//               },
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.only(left: 16, bottom: 10, right: 16),
//                   height: 60,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: const Color.fromARGB(255, 106, 105, 105),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _messageController,
//                           textCapitalization: TextCapitalization.sentences,
//                           autocorrect: true,
//                           enableSuggestions: true,
//                           decoration: InputDecoration(
//                             hintText: S.of(context).message,
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () => sendMessage('', 0),
//                         icon: const Icon(Icons.send),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const Location()),
//                           );
//                         },
//                         icon: const Icon(Icons.location_on_outlined),
//                       ),
//                       IconButton(
//                         onPressed: () async {
//                           final VoiceNoteModel? newVoiceNote =
//                               await showAppBottomSheet(context,
//                                   builder: (context) {
//                             return const AudioRecorderView();
//                           });

//                           if (newVoiceNote != null && context.mounted) {
//                             context
//                                 .read<VoiceNotesCubit>()
//                                 .addToVoiceNotes(newVoiceNote);
//                           }
//                         },
//                         icon: const Icon(Icons.mic),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
