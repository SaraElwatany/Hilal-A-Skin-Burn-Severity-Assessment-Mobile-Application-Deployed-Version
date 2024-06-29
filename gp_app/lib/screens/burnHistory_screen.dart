import 'package:flutter/material.dart';
import 'package:gp_app/apis/apis.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/models/burn_history.dart';
import 'package:gp_app/widgets/burnHistory_widget.dart';

import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/screens/patient_model_screen.dart';

class BurnHistoryScreen extends StatefulWidget {
  const BurnHistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _BurnHistoryScreenState createState() => _BurnHistoryScreenState();
}

class _BurnHistoryScreenState extends State<BurnHistoryScreen> {
  // List<BurnHistory> burnshistory = [
  //   BurnHistory(
  //     degree: 'First Degree',
  //     id: 0,
  //   ),
  //   BurnHistory(
  //     degree: 'Second Degree',
  //     id: 1,
  //   ),
  //   BurnHistory(
  //     degree: 'Third Degree',
  //     id: 2,
  //   ),
  // ];

  List<BurnHistory> burnshistory = [];

  @override
  void initState() {
    super.initState();
    print('Burns Chat');
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      String userProfession =
          (await SessionManager.getUserProfession()) ?? 'patient';
      print('User Profession: $userProfession');
      if (userProfession == 'patient') {
        await _fetchBurns();
      }
    } catch (error) {
      print('Error during initialization: $error');
    }
  }

  Future<void> _fetchBurns() async {
    try {
      List<BurnHistory> fetchedBurns = await getBurns();
      print('Fetched Burns: $fetchedBurns');
      setState(() {
        burnshistory = fetchedBurns;
      });
    } catch (error) {
      print('Error fetching patients: $error');
    }
  }

  void _handleTap(int index) async {
    print('Tapped on burn index: $index');
    BurnHistory selectedBurn = burnshistory[index];
    print('Selected Burn: ${selectedBurn.degree}');
    int burn_id = selectedBurn.id;
    // Old Burn Thread
    await SessionManager.saveBurnCondition('false');
    await SessionManager.saveBurnId(burn_id.toString());
    // Navigate to another screen or perform any other action with the selected burn
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const PatientModelChat(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LocalizationIcon(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).ch,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: burnshistory.length,
              itemBuilder: (BuildContext context, int index) {
                return BurnHistoryWidget(
                  burnhistory: burnshistory[index],
                  index: index,
                  onTap: _handleTap,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
