import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gp_app/apis/apis.dart';
import 'package:gp_app/models/global.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_app/models/chat_message.dart';
import 'package:gp_app/utils/app_bottom_sheet.dart';
import 'package:gp_app/widgets/voice_note_card.dart';
import 'package:gp_app/models/voice_note_model.dart';
import 'package:gp_app/widgets/messages_widget.dart';
import 'package:gp_app/screens/patient_location.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/widgets/audio_recorder_view.dart';
import 'package:gp_app/manager/voice_note_manager/voice_note_state.dart';
import 'package:gp_app/manager/voice_note_manager/voive_noter_cubit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:gp_app/manager/voice_note_manager/audio_recorder_file.dart';

import 'package:http/http.dart' as http;

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

  // Function to Provide the Intro Message For Every New Burn Thread Created
  void updateChatScreenWithIntro() async {
    // String burn_id = await SessionManager.getBurnId() ?? '0';
    // print('Burn ID For Doctor Messages: $burn_id');
    // print('Burn ID Before Messages: $burn_id');

    // (bool model, bool doctor, String mess_age, int receive_r)
    _sendMessage(true, false, S.of(context).Intro, Global.userId, null, 0,
        null); // send intro message to the database
  }

  // Function to Provide the Intro Message If The User Was A Guest
  void updateChatScreenWithIntroGuest() async {
    int burn_id = int.parse(await SessionManager.getBurnId() ?? '0');

    setState(() {
      messages.add(ChatMessage(
          message: S.of(context).Intro,
          receiver: false,
          timestamp: DateTime.now(),
          senderId: Global.userId,
          burnId: burn_id,
          image: null,
          imgFlag: 0,
          receiverId: 1));
    });
  }

  // Function to Provide the Intro Message For Every New Burn Thread Created
  void updateChatScreenWithWaitingMessage() async {
    String waitingMessage = S.of(context).waitingMessage;
    _sendMessage(true, false, waitingMessage, Global.userId, null, 0,
        null); // Display waiting Message
  }

  // Function To Display The Model's Output & The Treatment Protocol For The Signed Up User
  void updateChatScreenWithPrediction(
      String prediction, String? base64Img) async {
    String message = '';
    String drMessage = '';
    String clinical_flag = '0';
    print("Message From Location: $message");

    // Retrieve the base64 encoded image string from session
    String? base64Img = await SessionManager.getImageBlob();
    print("Blob Image Retrieved: $base64Img");

    if (prediction == 'First Degree Burn') {
      message = S.of(context).firstDegreeMessage;
      drMessage = S.of(context).doctorFirstDegreeMessage;
      print("Message From Location: $message");
    } else if (prediction == 'Second Degree Burn') {
      message = S.of(context).secondDegreeMessage;
      drMessage = S.of(context).doctorSecondDegreeMessage;
    } else if (prediction == 'Third Degree Burn') {
      message = S.of(context).thirdDegreeMessage;
      drMessage = S.of(context).doctorThirdDegreeMessage;
    }

    clinical_flag = (await SessionManager.getClinicalData()) ?? '0';
    // If clinical Data was Provided Display it
    if (clinical_flag == '1') {
      // Retrieve clinical data details
      Map<String, dynamic>? clinicalData =
          SessionManager.getClinicalDataDetails();
      drMessage += '\n' + S.of(context).clinicalDataMessage + '\n';

      if (clinicalData != null) {
        if (clinicalData['symptoms'] != null &&
            clinicalData['symptoms'].isNotEmpty) {
          drMessage += S.of(context).numberOne +
              S.of(context).symptoms +
              ': ' +
              clinicalData['symptoms'].join(', ') +
              '\n';
        }
        if (clinicalData['cause'] != null && clinicalData['cause'].isNotEmpty) {
          drMessage += S.of(context).numberTwo +
              S.of(context).cause +
              ': ' +
              clinicalData['cause'] +
              '\n';
        }
        if (clinicalData['place'] != null && clinicalData['place'].isNotEmpty) {
          drMessage += S.of(context).numberThree +
              S.of(context).place +
              ': ' +
              clinicalData['place'] +
              '\n';
        }
      }
    }

    // (bool model, bool doctor, String mess_age, int receive_r, voice_path, display_img)
    _sendMessage(true, false, message, Global.userId, null, 1,
        base64Img); // send prediction message to the database
    _sendMessage(true, true, drMessage, 1, null, 1,
        base64Img); // send prediction message to the database
  }

  // Function To Display The Model's Output & The Treatment Protocol For The Guest User
  void updateChatScreenWithPredictionGuest(
      String prediction, String? base64Img) async {
    String message = '';
    String drMessage = '';
    String waitingMessage = S.of(context).waitingMessage;
    String clinical_flag = '0';

    int burn_id = int.parse(await SessionManager.getBurnId() ?? '0');
    print("Message From Location: $message");

    // Retrieve the base64 encoded image string from session
    String? base64Image = await SessionManager.getImageBlob();
    print("Blob Image Retrieved: $base64Image");

    if (prediction == 'First Degree Burn') {
      message = S.of(context).firstDegreeMessage;
      drMessage = "The User's Burn is a First Degree Burn.\n";
      print("Message From Location: $message");
    } else if (prediction == 'Second Degree Burn') {
      message = S.of(context).secondDegreeMessage;
      drMessage = "The User's Burn is a Second Degree Burn.\n";
    } else if (prediction == 'Third Degree Burn') {
      message = S.of(context).thirdDegreeMessage;
      drMessage = "The User's Burn is a Third Degree Burn.\n";
    }

    clinical_flag = (await SessionManager.getClinicalData()) ?? '0';
    // If clinical Data was Provided Display it
    if (clinical_flag == '1') {
      drMessage =
          drMessage + 'The Clinical Data Provided by user:\n1.Symptoms:';
    }

    // _sendMessage(true, false, waitingMessage, Global.userId, null,
    //     0); // Display waiting Message

    setState(() {
      messages.add(ChatMessage(
          message: message, // message,
          receiver: false,
          image: base64Img,
          senderId: Global.userId,
          burnId: burn_id,
          receiverId: 1,
          imgFlag: 1,
          timestamp: DateTime.now()));
    });
  }

  // Function To Display The List Of Nearest Hospitals For The Signed Up User
  void updateChatScreenWithHospitals(List<dynamic> hospitals) async {
    var fullMessage = '';

    double lat = (await SessionManager.getLongitude()) ?? 0.0;

    if (lat == 0.0) {
      fullMessage = S.of(context).locationDisabledMessage;
    } else {
      fullMessage = S.of(context).locationMessage;
    }

    List<Map<String, String>> hospitalDetails = [];

    for (var i = 0; i < 5 && i < hospitals.length; i++) {
      var hospital = hospitals[i];
      var hospitalMessage =
          '${hospital['english_name']} - ${hospital['arabic_name']}';
      var mapsLink =
          'https://www.google.com/maps/search/?api=1&lat=${hospital['lat']}&lon=${hospital['lon']}';

      var map = S.of(context).viewMapsMessage;

      fullMessage =
          fullMessage + '${i + 1}. $hospitalMessage\n[$map]($mapsLink)\n\n';

      hospitalDetails.add({
        '${hospital['lat']},${hospital['lon']}': hospitalMessage,
      });
    }

    // (bool model, bool doctor, String mess_age, int receive_r)
    _sendMessage(true, false, fullMessage, Global.userId, null, 0,
        null); // send hospital locations message to the database
  }

  // Function To Display The List Of Nearest Hospitals For The Guest User
  void updateChatScreenWithHospitalsGuest(List<dynamic> hospitals) async {
    int burn_id = int.parse(await SessionManager.getBurnId() ?? '0');

    var fullMessage = '';

    double lat = (await SessionManager.getLongitude()) ?? 0.0;

    if (lat == 0.0) {
      fullMessage = S.of(context).locationDisabledMessage;
    } else {
      fullMessage = S.of(context).locationMessage;
    }

    List<Map<String, String>> hospitalDetails = [];

    for (var i = 0; i < 5 && i < hospitals.length; i++) {
      var hospital = hospitals[i];
      var hospitalMessage =
          '${hospital['english_name']} - ${hospital['arabic_name']}';
      var mapsLink =
          'https://www.google.com/maps/search/?api=1&lat=${hospital['lat']}&lon=${hospital['lon']}';

      var map = S.of(context).viewMapsMessage;

      fullMessage =
          fullMessage + '${i + 1}. $hospitalMessage\n[$map]($mapsLink)\n\n';

      hospitalDetails.add({
        '${hospital['lat']},${hospital['lon']}': hospitalMessage,
      });
    }

    setState(() {
      messages.add(ChatMessage(
          message: fullMessage,
          receiver: false,
          senderId: Global.userId,
          receiverId: 1,
          burnId: burn_id,
          image: null,
          imgFlag: 0,
          hospitalDetails: hospitalDetails,
          timestamp: DateTime.now()));
    });
  }

  Future<void> fetchPredictionAndHospitals(int guest, String? base64Img) async {
    var url = Uri.parse('https://deploy-2uif.onrender.com/respond_to_user');

    double userLat = (await SessionManager.getLatitude()) ?? 0.0;
    double userLong = (await SessionManager.getLongitude()) ?? 0.0;

    var params = {
      'user_latitude': userLat.toString(),
      'user_longitude': userLong.toString(),
    };

    try {
      var response = await http.post(
        url.replace(queryParameters: params),
      );

      print('Latitude From Chat Screen: $userLat');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody['error'] != null) {
          print('Error: ${responseBody['error']}');
        } else {
          List<dynamic> hospitals = responseBody['hospitals'];

          String prediction;
          prediction = (await SessionManager.getPrediction()) ?? '';
          Global.latestPrediction = prediction;

          if (guest == 1) {
            updateChatScreenWithPredictionGuest(prediction, base64Img);
            // Ensure the prediction message is added first
            await Future.delayed(Duration(
                milliseconds:
                    3000)); // Adding a small delay to ensure the order

            if (prediction != 'First Degree Burn') {
              updateChatScreenWithHospitalsGuest(hospitals);
              // Ensure the hospital message is added first
              await Future.delayed(Duration(milliseconds: 7000));
            }
          } else {
            updateChatScreenWithPrediction(prediction, base64Img);
            // Ensure the prediction message is added first
            await Future.delayed(Duration(
                milliseconds:
                    7000)); // Adding a small delay to ensure the order

            updateChatScreenWithHospitals(
                hospitals); //////////////////////////////////////////////
            // if (prediction != 'First Degree Burn') {
            //   updateChatScreenWithHospitals(hospitals);
            // // Ensure the hospital message is added first
            // await Future.delayed(Duration(milliseconds: 3000));
            // }
          }

          updateChatScreenWithWaitingMessage();

          setState(() {
            predictionAndHospitalsFetched = true;
          });
        }
      } else {
        print('Failed to get response. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      context.read<VoiceNotesCubit>().getAllVoiceNotes(pageKey);
    });

    super.initState();
    print('Intro Message: $introMessageShown');

    // // Ensure the intro message and data fetch is triggered when chat history is loaded
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _initializeSession();
    // });

    // if (newBurn != 'true') {
    //   print('New Burn Detected !!');
    //   loadChatHistory(burn_id);
    // }
    // AudioApi.initRecorder();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // variable to assess whether this was a new burn or not
    String newBurn = (await SessionManager.getBurnCondition()) ?? 'false';
    print('Burn Condition: $newBurn');
    int burn_id = int.parse((await SessionManager.getBurnId()) ?? '0');
    print('Burn ID: $burn_id');

    if (newBurn != 'true') {
      print('Old Burn Thread !!');
      loadChatHistory(burn_id);
    } else {
      // Access inherited widgets or context-dependent values
      _initializeSession();
    }
  }

  void _initializeSession() async {
    String userProfession =
        (await SessionManager.getUserProfession()) ?? 'patient';
    String? base64Img = await SessionManager.getImageBlob() ?? null;
    print('User Profession: $userProfession');

    int user_id = Global.userId;
    String newBurn = (await SessionManager.getBurnCondition()) ?? 'true';

    print('User ID: $user_id');
    print('New Burn Condition: $newBurn');

    if (userProfession == 'patient' &&
        // !introMessageShown &&
        newBurn == 'true') {
      String burn_id = await SessionManager.getBurnId() ?? '0';
      print('Burn ID Before Messages: $burn_id');

      updateChatScreenWithIntro();
      introMessageShown = true;
      fetchPredictionAndHospitals(0, base64Img);
    }
    // The user is a Guest (So only display the output messages, no saving in the db occur)
    else if (user_id == 0 && newBurn == 'true') {
      updateChatScreenWithIntroGuest();
      introMessageShown = true;
      fetchPredictionAndHospitals(1, base64Img);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    pagingController.dispose();
    super.dispose();
  }

  // Load The Chat History For The Old Chat Thread Once The Chat Screen Is Loaded
  void loadChatHistory(int burn_id) async {
    try {
      List<ChatMessage> fetchedMessages = await fetchChatHistory(
          Global.userId, 1, burn_id); // Receiver ID set to 1
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

  // Function To Send The Messages To The Server & Save It In The DB For The Signed Up User
  void _sendMessage(bool model, bool doctor, String mess_age, int receive_r,
      String? voiceNotePath, int img_flag, String? base64Img) async {
    int burn_id = int.parse(await SessionManager.getBurnId() ?? '0');

    if (model == true) {
      if (doctor == true) {
        String burnId = await SessionManager.getBurnId() ?? '0';
        print('Burn ID For Doctor Messages: $burnId');

        final message = ChatMessage(
          message: mess_age,
          receiver: true,
          image: base64Img,
          imgFlag: img_flag,
          timestamp: DateTime.now(),
          senderId: 3,
          receiverId: receive_r,
          burnId: burn_id,
        );

        // Send the message to the server
        await sendMessageToServer(message);
      } else {
        String burnId = await SessionManager.getBurnId() ?? '0';
        print('Burn ID For Model/Patient Interface Messages: $burnId');

        final message = ChatMessage(
          message: mess_age,
          receiver: false,
          image: base64Img,
          imgFlag: img_flag,
          timestamp: DateTime.now(),
          senderId: 3,
          receiverId: Global.userId,
          burnId: burn_id,
        );

        // Send the message to the server
        await sendMessageToServer(message);
        setState(() {
          messages.add(message);
          _messageController.clear();
        });
      }
    } else {
      if (voiceNotePath != null) {
        final voiceNoteMessage = ChatMessage(
          message: mess_age,
          receiver: false,
          image: base64Img,
          imgFlag: img_flag,
          voiceNote: voiceNotePath,
          timestamp: DateTime.now(),
          senderId: Global.userId,
          receiverId: receive_r,
          burnId: burn_id,
        );

        // Send the voice note message to the server
        await sendMessageToServer(voiceNoteMessage);
        setState(() {
          messages.add(voiceNoteMessage);
          _messageController.clear();
        });
      } else {
        final text = _messageController.text.trim();

        String burnId = await SessionManager.getBurnId() ?? '0';
        print('Burn ID For Patient/Doctor Messages: $burnId');

        if (text.isNotEmpty) {
          final message = ChatMessage(
              message: text,
              receiver: true,
              image: base64Img,
              imgFlag: img_flag,
              timestamp: DateTime.now(),
              senderId: Global.userId,
              burnId: burn_id,
              receiverId: receive_r);

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
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VoiceNotesCubit(AudioRecorderFileHelper()),
      child: Scaffold(
        appBar: const LocalizationIcon(),
        body: Stack(
          children: [
            BlocListener<VoiceNotesCubit, VoiceNotesState>(
              listener: (context, state) {
                if (state is VoiceNotesError) {
                  pagingController.error = state.message;
                } else if (state is VoiceNotesFetched) {
                  onDataFetched(state);
                } else if (state is VoiceNoteDeleted) {
                  final List<VoiceNoteModel> voiceNotes =
                      List.from(pagingController.value.itemList ?? []);
                  voiceNotes.remove(state.voiceNoteModel);
                  pagingController.itemList = voiceNotes;
                } else if (state is VoiceNoteAdded) {
                  final List<VoiceNoteModel> newItems =
                      List.from(pagingController.itemList ?? []);
                  newItems.insert(0, state.voiceNoteModel);
                  pagingController.itemList = newItems;
                }
              },
              child: PagedListView<int, VoiceNoteModel>(
                pagingController: pagingController,
                padding: const EdgeInsets.only(right: 24, left: 24, bottom: 80),
                builderDelegate: PagedChildBuilderDelegate<VoiceNoteModel>(
                  noItemsFoundIndicatorBuilder: (context) {
                    return const Column(children: [
                      SizedBox(height: 55),
                    ]);
                  },
                  itemBuilder: (context, item, index) {
                    return VoiceNoteCard(voiceNoteInfo: item);
                  },
                ),
              ),
            ),
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
                        onPressed: () => _sendMessage(
                            false,
                            false,
                            '',
                            1,
                            null,
                            0,
                            null), // (bool model, bool doctor, String mess_age, int receive_r)
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
                            _sendMessage(false, false, '', 1, newVoiceNote.path,
                                0, null); // Pass voice note path
                          } else {
                            _sendMessage(false, false, '', 1, null, 0,
                                null); // Pass null if no voice note
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