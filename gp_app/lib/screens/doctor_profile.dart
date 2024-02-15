import 'package:flutter/material.dart';
import 'package:gp_app/Data/doctor_msg.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/models/patient_list.dart';
import 'package:gp_app/widgets/patients_list.dart';

class DocterProfile extends StatefulWidget {
  const DocterProfile({Key? key}) : super(key: key);

  @override
  State<DocterProfile> createState() => DocterProfileState();
}

class DocterProfileState extends State<DocterProfile> {
  // Just for test
  List<Patient> patients = [
    Patient(name: 'Patient 1', info: 'Info for Patient 1'),
    Patient(name: 'Patient 2', info: 'Info for Patient 2'),
  ];

  String _selectedItem = 'Time'; // Default selected item

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
                  'Patients',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedItem,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedItem = newValue!;
                            });
                          },
                          items: <String>['Time', 'Danger']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          // Customizing dropdown menu appearance
                          dropdownColor: Colors.grey[200],
                          elevation: 8,
                          icon: Icon(Icons.arrow_drop_down),
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          iconSize: 24,
                          underline: Container(), // No underline
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: patients.length,
              itemBuilder: (BuildContext context, int index) {
                return PatientList(
                  patient: patients[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
