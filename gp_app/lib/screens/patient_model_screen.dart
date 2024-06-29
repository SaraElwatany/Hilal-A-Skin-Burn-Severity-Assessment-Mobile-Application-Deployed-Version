import 'package:flutter/material.dart';
import 'package:gp_app/apis/apis.dart';
import 'package:gp_app/models/global.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/models/my_state.dart';
import 'package:gp_app/models/chat_message.dart';
import 'package:gp_app/widgets/docter_model_widget.dart';
import 'package:gp_app/widgets/messages_widget.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/screens/patient_location.dart';
import 'package:gp_app/manager/voice_note_manager/audio_recorder_file.dart';
import 'package:gp_app/manager/voice_note_manager/voice_note_state.dart';
import 'package:gp_app/manager/voice_note_manager/voive_noter_cubit.dart';
import 'package:gp_app/models/voice_note_model.dart';
import 'package:gp_app/widgets/audio_recorder_view.dart';
import 'package:gp_app/widgets/voice_note_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:gp_app/utils/app_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    String burn_id = await SessionManager.getBurnId() ?? '0';
    print('Burn ID For Doctor Messages: $burn_id');
    print('Burn ID Before Messages: $burn_id');
    // (bool model, bool doctor, String mess_age, int receive_r)
    _sendMessage(true, false, S.of(context).Intro,
        Global.userId, null); // send intro message to the database
  }

  // Function to Provide the Intro Message If The User Was A Guest
  void updateChatScreenWithIntroGuest() async {
    int burn_id = int.parse(await SessionManager.getBurnId() ?? '0');
    setState(() {
      messages.add(ChatMessage(
          message: S.of(context).Intro,
          receiver: false,
          timestamp: DateTime.now(),
          // senderId: userId, (Sara)
          senderId: Global.userId,
          burnId: burn_id,
          receiverId: 1));
    });
  }

  // Function To Display The Model's Output & The Treatment Protocol For The Signed Up User
  void updateChatScreenWithPrediction(String prediction) async {
    String message = '';
    String drMessage = '';
    String clinical_flag = '0';
    print("Message From Location: $message");

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
      drMessage = drMessage + 'The Clinical Data Provided:\n';
    }

    // (bool model, bool doctor, String mess_age, int receive_r)
    _sendMessage(true, false, message,
        Global.userId, null); // send prediction message to the database
    _sendMessage(
        true, true, drMessage, 1, null); // send prediction message to the database
  }

  // Function To Display The Model's Output & The Treatment Protocol For The Guest User
  void updateChatScreenWithPredictionGuest(String prediction) async {
    String message = '';
    String drMessage = '';
    String clinical_flag = '0';
    int burn_id = int.parse(await SessionManager.getBurnId() ?? '0');
    print("Message From Location: $message");

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
      drMessage = drMessage + 'The Clinical Data Provided:\n';
    }

    setState(() {
      messages.add(ChatMessage(
          message: message, // message,
          receiver: false,
          // senderId: userId, // (Sara)
          senderId: Global.userId,
          burnId: burn_id,
          receiverId: 1,
          timestamp: DateTime.now()));
    });
  }

  // Function To Display The List Of Nearest Hospitals For The Signed Up User
  void updateChatScreenWithHospitals(List<dynamic> hospitals) {
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

    // (bool model, bool doctor, String mess_age, int receive_r)
    _sendMessage(true, false, fullMessage,
        Global.userId, null); // send hospital locations message to the database
  }

  // Function To Display The List Of Nearest Hospitals For The Guest User
  void updateChatScreenWithHospitalsGuest(List<dynamic> hospitals) async {
    int burn_id = int.parse(await SessionManager.getBurnId() ?? '0');
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

    setState(() {
      messages.add(ChatMessage(
          message: fullMessage,
          receiver: false,
          senderId: Global.userId,
          receiverId: 1,
          burnId: burn_id,
          hospitalDetails: hospitalDetails,
          timestamp: DateTime.now()));
    });
  }

  Future<void> fetchPredictionAndHospitals(int guest) async {
    var url = Uri.parse('https://my-trial-t8wj.onrender.com/respond_to_user');

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
            updateChatScreenWithPredictionGuest(prediction);
            // Ensure the prediction message is added first
            await Future.delayed(Duration(
                milliseconds: 10)); // Adding a small delay to ensure the order
            updateChatScreenWithHospitalsGuest(hospitals);
          } else {
            updateChatScreenWithPrediction(prediction);
            // Ensure the prediction message is added first
            await Future.delayed(Duration(
                milliseconds: 10)); // Adding a small delay to ensure the order
            updateChatScreenWithHospitals(hospitals);
          }

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
      fetchPredictionAndHospitals(0);
    }
    // The user is a Guest (So only display the output messages, no saving in the db occur)
    else if (user_id == 0 && newBurn == 'true') {
      updateChatScreenWithIntroGuest();
      introMessageShown = true;
      fetchPredictionAndHospitals(1);
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

  // Function To Send The Messages To The Server & Save It In The DB For The Signed Up User
  void _sendMessage(bool model, bool doctor, String mess_age, int receive_r, String? voiceNotePath) async {
    int burn_id = int.parse(await SessionManager.getBurnId() ?? '0');

    if (model == true) {
      if (doctor == true) {
        String burnId = await SessionManager.getBurnId() ?? '0';
        print('Burn ID For Doctor Messages: $burnId');

        final message = ChatMessage(
          message: mess_age,
          receiver: true,
          image:
              "C:\Users\Marina\OneDrive\Pictures\Screenshots\Screenshot 2024-06-22 160114.png",
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
          image:
              "C:\Users\Marina\OneDrive\Pictures\Screenshots\Screenshot 2024-06-22 160114.png",
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
        image: null,
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
            image:
              null,
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
                        onPressed: () => _sendMessage(false, false, '',
                            1, null), // (bool model, bool doctor, String mess_age, int receive_r)
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
                            _sendMessage(false, false, '', 1, newVoiceNote.path); // Pass voice note path
                            } else {
                              _sendMessage(false, false, '', 1, null); // Pass null if no voice note
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
