// import 'package:flutter/material.dart';
// import 'package:gp_app/apis/apis.dart';
// import 'package:gp_app/screens/patient_location.dart';
// import 'package:gp_app/models/global.dart';
// import 'package:gp_app/generated/l10n.dart';
// import 'package:gp_app/models/chat_message.dart';
// import 'package:gp_app/widgets/messages_widget.dart';
// import 'package:gp_app/widgets/localization_icon.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:gp_app/manager/voice_note_manager/audio_recorder_file.dart';
// import 'package:gp_app/manager/voice_note_manager/voice_note_state.dart';
// import 'package:gp_app/manager/voice_note_manager/voive_noter_cubit.dart';
// import 'package:gp_app/models/voice_note_model.dart';
// import 'package:gp_app/widgets/audio_recorder_view.dart';
// import 'package:gp_app/widgets/voice_note_card.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:gp_app/utils/app_bottom_sheet.dart';
// import 'package:gp_app/utils/constants/app_colors.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class PatientModelChat extends StatefulWidget {
//   const PatientModelChat({Key? key}) : super(key: key);

//   @override
//   State<PatientModelChat> createState() => PatientModelChatState();
// }

// class PatientModelChatState extends State<PatientModelChat> {
//   List<ChatMessage> messages = [];
//   final TextEditingController _messageController = TextEditingController();
//   bool introMessageShown = false;
//   bool predictionAndHospitalsFetched = false;
//   final PagingController<int, VoiceNoteModel> pagingController =
//       PagingController<int, VoiceNoteModel>(
//           firstPageKey: 1, invisibleItemsThreshold: 6);

//   @override
//   void initState() {
//     pagingController.addPageRequestListener((pageKey) {
//       context.read<VoiceNotesCubit>().getAllVoiceNotes(pageKey);
//     });
//     super.initState();
//     loadChatHistory();
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     pagingController.dispose();
//     super.dispose();
//   }

//   void loadChatHistory() async {
//     try {
//       List<ChatMessage> fetchedMessages =
//           await fetchChatHistory(Global.userId, 1); // Receiver ID set to 1
//       setState(() {
//         messages = fetchedMessages;
//       });
//       print('chat is loaded');
//     } catch (e) {
//       print("Failed to load chat history: $e");
//     }
//   }

//   void onDataFetched(VoiceNotesFetched state) {
//     final data = state.voiceNotes;

//     final isLastPage = data.isEmpty ||
//         data.length < context.read<VoiceNotesCubit>().fetchLimit;
//     if (isLastPage) {
//       pagingController.appendLastPage(data);
//     } else {
//       final nextPageKey = (pagingController.nextPageKey ?? 0) + 1;
//       pagingController.appendPage(data, nextPageKey);
//     }
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     if (!introMessageShown) {
//       updateChatScreenWithIntro();
//       introMessageShown = true;
//       fetchPredictionAndHospitals();
//     }
//   }

//   Future<void> fetchPredictionAndHospitals() async {
//     // Your implementation remains the same
//     // Adjusted based on your previous code snippet
//   }

//   void updateChatScreenWithIntro() {
//     setState(() {
//       messages.add(ChatMessage(
//           message: S.of(context).Intro,
//           receiver: false,
//           timestamp: DateTime.now(),
//           senderId: Global.userId,
//           receiverId: 1));
//     });
//   }

//   void updateChatScreenWithPrediction(String prediction) {
//     setState(() {
//       messages.add(ChatMessage(
//           message:
//               'Your Burn Degree is $prediction.\nThe Following First Aid Protocols are Recommended:\n\n1.\n2.\n3.\n4.\n5.\n',
//           receiver: false,
//           senderId: Global.userId,
//           receiverId: 1,
//           timestamp: DateTime.now()));
//     });
//   }

//   void updateChatScreenWithHospitals(List<dynamic> hospitals) {
//     var fullMessage =
//         'The Following is a List of The Nearest Five Burn Hospitals According to your Location:\n\n';

//     List<Map<String, String>> hospitalDetails = [];

//     for (var i = 0; i < 5 && i < hospitals.length; i++) {
//       var hospital = hospitals[i];
//       var hospitalMessage =
//           '${hospital['english_name']} - ${hospital['arabic_name']}';
//       var mapsLink =
//           'https://www.google.com/maps/search/?api=1&lat=${hospital['lat']}&lon=${hospital['lon']}';

//       fullMessage = fullMessage +
//           '${i + 1}. $hospitalMessage\n[View on Maps]($mapsLink)\n\n';

//       hospitalDetails.add({
//         '${hospital['lat']},${hospital['lon']}': hospitalMessage,
//       });
//     }

//     setState(() {
//       messages.add(ChatMessage(
//           message: fullMessage,
//           receiver: false,
//           senderId: Global.userId,
//           receiverId: 1,
//           hospitalDetails: hospitalDetails,
//           timestamp: DateTime.now()));
//     });
//   }

//   void _sendMessage() async {
//     final text = _messageController.text.trim();
//     if (text.isNotEmpty) {
//       final message = ChatMessage(
//           message: text,
//           receiver: true,
//           image:
//               "C:\Users\Marina\OneDrive\Pictures\Screenshots\Screenshot 2024-06-22 160114.png",
//           timestamp: DateTime.now(),
//           senderId: Global.userId,
//           receiverId: 1);

//       await sendMessageToServer(message);

//       setState(() {
//         messages.add(message);
//         _messageController.clear();
//       });
//     } else
//       print('message is empty');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const LocalizationIcon(),
//       body: Stack(
//         children: [
//           ListView.builder(
//             itemCount: messages.length,
//             itemBuilder: (context, index) {
//               final chatMessage = messages[index];
//               return MessagesWidget(
//                 chatMessage: chatMessage,
//                 introMessage: null,
//               );
//             },
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 padding: const EdgeInsets.only(left: 16, bottom: 10, right: 16),
//                 height: 60,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: const Color.fromARGB(255, 106, 105, 105),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _messageController,
//                         textCapitalization: TextCapitalization.sentences,
//                         autocorrect: true,
//                         enableSuggestions: true,
//                         decoration: InputDecoration(
//                           hintText: S.of(context).message,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: _sendMessage,
//                       icon: const Icon(Icons.send),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const Location()),
//                         );
//                       },
//                       icon: const Icon(Icons.location_on_outlined),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         // Handle recording logic here
//                         // Example: _toggleRecording()
//                       },
//                       icon: const Icon(Icons.mic),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gp_app/apis/apis.dart';
import 'package:gp_app/screens/patient_location.dart';
import 'package:gp_app/models/global.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/models/my_state.dart';
import 'package:gp_app/models/global.dart';

import 'package:gp_app/models/chat_message.dart';
import 'package:gp_app/widgets/messages_widget.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/manager/voice_note_manager/audio_recorder_file.dart';
import 'package:gp_app/manager/voice_note_manager/voice_note_state.dart';
import 'package:gp_app/manager/voice_note_manager/voive_noter_cubit.dart';
import 'package:gp_app/models/voice_note_model.dart';
import 'package:gp_app/widgets/audio_recorder_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:gp_app/utils/app_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gp_app/widgets/voice_note_card.dart';

class PatientModelChat extends StatefulWidget {
  const PatientModelChat({Key? key}) : super(key: key);

  @override
  State<PatientModelChat> createState() => PatientModelChatState();
}

class PatientModelChatState extends State<PatientModelChat> {
  List<ChatMessage> messages = [];
  final TextEditingController _messageController = TextEditingController();
  bool introMessageShown = false;
  bool predictionAndHospitalsFetched = false;
  final PagingController<int, VoiceNoteModel> pagingController =
      PagingController<int, VoiceNoteModel>(
          firstPageKey: 1, invisibleItemsThreshold: 6);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      context.read<VoiceNotesCubit>().getAllVoiceNotes(pageKey);
    });
    super.initState();
    print('Intro Message: $introMessageShown');
    // Ensure the intro message and data fetch is triggered when chat history is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSession();
    });
    loadChatHistory();
    // AudioApi.initRecorder();
  }

  void _initializeSession() async {
    String userProfession =
        (await SessionManager.getUserProfession()) ?? 'patient';
    String newBurn = (await SessionManager.getBurnCondition()) ?? 'true';

    if (userProfession == 'patient' &&
        // !introMessageShown &&
        newBurn == 'true') {
      updateChatScreenWithIntro();
      introMessageShown = true;
      fetchPredictionAndHospitals();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    pagingController.dispose();
    super.dispose();
  }

  void loadChatHistory() async {
    try {
      List<ChatMessage> fetchedMessages =
          await fetchChatHistory(Global.userId, 1); // Receiver ID set to 1
      setState(() {
        messages = fetchedMessages;
      });

      print('chat is loaded');
    } catch (e) {
      print("Failed to load chat history: $e");
    }
  }

  void onDataFetched(VoiceNotesFetched state) {
    final data = state.voiceNotes;

    final isLastPage = data.isEmpty ||
        data.length < context.read<VoiceNotesCubit>().fetchLimit;
    if (isLastPage) {
      pagingController.appendLastPage(data);
    } else {
      final nextPageKey = (pagingController.nextPageKey ?? 0) + 1;
      pagingController.appendPage(data, nextPageKey);
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // String userProfession = (await Session.Manager.getUserProfession()) ?? 'patient';
  // String newBurn = (await Session.Manager.getBurnCondition()) ?? 'true';
  //   if ((userProfession=='patient') && (!introMessageShown) && (newBurn=='true')) {
  //     updateChatScreenWithIntro();
  //     introMessageShown = true;
  //     fetchPredictionAndHospitals();
  //   }

  //   // if (messages.isEmpty && !introMessageShown) {
  //   //   updateChatScreenWithIntro();
  //   //   introMessageShown = true;
  //   //   fetchPredictionAndHospitals();
  //   // }
  // }

  // void _toggleRecording() async {
  //   if (_isRecording) {
  //     final path = await _recorder.stopRecorder();
  //     if (path != null) {
  //       setState(() {
  //         messages.add(ChatMessage(
  //             message: 'New audio message',
  //             receiver: false,
  //             timestamp: DateTime.now(),
  //             senderId: Global.user_id,
  //             receiverId: '1'));
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

  void _sendMessage(bool model, String mess_age) async {
    if (model == true) {
      final message = ChatMessage(
        message: mess_age,
        receiver: false,
        image:
            "C:\Users\Marina\OneDrive\Pictures\Screenshots\Screenshot 2024-06-22 160114.png",
        timestamp: DateTime.now(),
        senderId: 1,
        receiverId: Global.userId,
      );

      // Send the message to the server
      await sendMessageToServer(message);
      setState(() {
        messages.add(message);
        _messageController.clear();
      });
    } else {
      final text = _messageController.text.trim();
      if (text.isNotEmpty) {
        final message = ChatMessage(
            message: text,
            receiver: true,
            image:
                "C:\Users\Marina\OneDrive\Pictures\Screenshots\Screenshot 2024-06-22 160114.png",
            timestamp: DateTime.now(),
            senderId: Global.userId,
            receiverId: 1);

        // Send the message to the server
        await sendMessageToServer(message);

        setState(() {
          messages.add(message);
          _messageController.clear();
        });
      } else
        print('message is empty');
    }
  }

  // Function to (Sara)
  void updateChatScreenWithIntro() {
    _sendMessage(
        true, S.of(context).Intro); // send intro message to the database
    // setState(() {
    //   messages.add(ChatMessage(
    //       message: S.of(context).Intro,
    //       receiver: false,
    //       timestamp: DateTime.now(),
    //       // senderId: userId, (Sara)
    //       senderId: Global.userId,
    //       receiverId: 1));
    // });
  }

  void updateChatScreenWithPrediction(String prediction) {
    String message = '';
    print("Message From Location: $message");

    if (prediction == 'First Degree Burn') {
      message = S.of(context).firstDegreeMessage;
      print("Message From Location: $message");
    } else if (prediction == 'Second Degree Burn') {
      message = S.of(context).secondDegreeMessage;
    } else if (prediction == 'Third Degree Burn') {
      message = S.of(context).thirdDegreeMessage;
    }
    _sendMessage(true, message); // send prediction message to the database
    // setState(() {
    //   messages.add(ChatMessage(
    //       message: message, // message,
    //       receiver: false,
    //       // senderId: userId, // (Sara)
    //       senderId: Global.userId,
    //       receiverId: 1,
    //       timestamp: DateTime.now()));
    // });
  }

  void updateChatScreenWithHospitals(List<dynamic> hospitals) {
    // final myState = Provider.of<MyState>(context, listen: false);
    // String userId = myState.userId;
    var fullMessage = S.of(context).locationMessage;

    List<Map<String, String>> hospitalDetails = [];

    for (var i = 0; i < 5 && i < hospitals.length; i++) {
      var hospital = hospitals[i];
      var hospitalMessage =
          '${hospital['english_name']} - ${hospital['arabic_name']}';
      var mapsLink =
          'https://www.google.com/maps/search/?api=1&lat=${hospital['lat']}&lon=${hospital['lon']}';

      fullMessage = fullMessage +
          '${i + 1}. $hospitalMessage\n[View on Maps]($mapsLink)\n\n';

      hospitalDetails.add({
        '${hospital['lat']},${hospital['lon']}': hospitalMessage,
      });
    }

    _sendMessage(
        true, fullMessage); // send hospital locations message to the database

    // setState(() {
    //   messages.add(ChatMessage(
    //       message: fullMessage,
    //       receiver: false,
    //       senderId: Global.userId,
    //       receiverId: 1,
    //       hospitalDetails: hospitalDetails,
    //       timestamp: DateTime.now()));
    // });
  }

  // // Update chat screen with the list of nearest hospitals (Sara)
  // void updateChatScreenWithHospitals(List<dynamic> hospitals) {
  //   final myState = Provider.of<MyState>(context, listen: false);
  //   String userId = myState.userId;

  //   setState(() {
  //     for (var i = 0; i < 5 && i < hospitals.length; i++) {
  //       var hospital = hospitals[i];
  //       var hospitalMessage =
  //           '${hospital['english_name']} - ${hospital['arabic_name']}';
  //       var mapsLink =
  //           'https://www.google.com/maps/search/?api=1&query=${hospital['lat']},${hospital['lon']}';
  //       print('URL $i $mapsLink');

  //       messages.add(ChatMessage(
  //           message: '$hospitalMessage\n[View on Maps]($mapsLink)',
  //           receiver: false,
  //           senderId: '0',
  //           receiverId: '1',
  //           latitude: hospital['lat'], // Add latitude
  //           longitude: hospital['lon'], // Add longitude
  //           hospitalNameEn: hospital['english_name'],
  //           hospitalNameAr: hospital['arabic_name'],
  //           timestamp: DateTime.now()));
  //     }
  //   });
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
                return MessagesWidget(
                  chatMessage: chatMessage,
                  introMessage: null,
                );
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
                        onPressed: () => _sendMessage(false, ''),
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
