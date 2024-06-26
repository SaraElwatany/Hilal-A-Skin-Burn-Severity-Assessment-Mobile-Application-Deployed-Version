import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/models/burn_history.dart';
import 'package:gp_app/widgets/burnHistory_widget.dart';

import 'package:gp_app/widgets/localization_icon.dart';

class BurnHistoryScreen extends StatefulWidget {

  const BurnHistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _BurnHistoryScreenState createState() => _BurnHistoryScreenState();
}

class _BurnHistoryScreenState extends State<BurnHistoryScreen> {
    final List<BurnHistory> burnshistory = [
    BurnHistory(
      degree: 'First Degree',
    ),
    BurnHistory(
      degree: 'Second Degree',
    ),
    BurnHistory(
      degree: 'Third Degree',
    ),
  ];

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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
