import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/screens/signup_screen.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/models/patient_list.dart';
import 'package:gp_app/models/global.dart';

import 'package:gp_app/widgets/patients_list.dart';
import 'package:gp_app/apis/apis.dart';

class DocterProfile extends StatefulWidget {
  const DocterProfile({Key? key}) : super(key: key);

  @override
  State<DocterProfile> createState() => DocterProfileState();
}

class DocterProfileState extends State<DocterProfile> {
/* // Just for test
  List<Patient> patients = [
    Patient(name: 'Patient 1', info: 'Info for Patient 1'),
    Patient(name: 'Patient 2', info: 'Info for Patient 2'),
  ];

 */

  String _selectedItem = 'Time'; // Default
  List<Patient> patients = [];
  bool adminPassword = Global.adminPassword;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      String userProfession =
          (await SessionManager.getUserProfession()) ?? 'patient';
      if (!adminPassword) {
        await _fetchPatients();
      } else {
        print('Hiiiiiiiiiiiiiiiiiii ADMIN');
        await _fetchDoctors();
      }
    } catch (error) {
      print('Error during initialization: $error');
    }
  }

  // Get the list of patients from the database along with their information
  Future<void> _fetchPatients() async {
    try {
      List<Patient> fetchedPatients = await getPatients();
      setState(() {
        patients = fetchedPatients;
      });
    } catch (error) {
      // Handle error
    }
  }

  // Get the list of doctors from the database along with their information
  Future<void> _fetchDoctors() async {
    try {
      List<Patient> fetchedDoctors = await getDoctors();
      setState(() {
        patients = fetchedDoctors;
      });
    } catch (error) {
      // Handle error
    }
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
                  (adminPassword)
                      ? S.of(context).doctors
                      : S.of(context).patients,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!adminPassword)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            items: <String>[
                              S.of(context).time,
                              S.of(context).danger,
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value == S.of(context).time
                                    ? 'Time'
                                    : 'Danger',
                                child: Text(value),
                              );
                            }).toList(),
                            dropdownColor: Colors.grey[200],
                            elevation: 8,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            iconSize: 24,
                            underline: Container(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (!adminPassword)
            (Expanded(
              child: ListView.builder(
                itemCount: patients.length,
                itemBuilder: (BuildContext context, int index) {
                  return PatientList(
                    patient: patients[index],
                  );
                },
              ),
            )),
          if (adminPassword)
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton.icon(
                  onPressed: () async {
                    await SessionManager.saveUserProfession(
                        'admin'); // set user profession to patient on press
                    Global.adminPassword = true;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const SignUpScreen()));
                  },
                  icon: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      fixedSize: const Size(210, 60)),
                  label: Text(
                    S.of(context).addDoctors,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 255, 251, 251),
                    ),
                    textAlign: TextAlign.center,
                  )),
            )
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:gp_app/generated/l10n.dart';
// import 'package:gp_app/widgets/add_Doctor.dart';
// import 'package:gp_app/widgets/localization_icon.dart';
// import 'package:gp_app/models/patient_list.dart';
// import 'package:gp_app/widgets/patients_list.dart';
// import 'package:gp_app/apis/apis.dart';

// class DocterProfile extends StatefulWidget {
//   const DocterProfile({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => DocterProfileState();
// }

// class DocterProfileState extends State<StatefulWidget> {
//   String _selectedItem = 'Time'; // Default
//   List<Patient> patients = [];
//   bool adminPassword = true;

//   @override
//   void initState() {
//     super.initState();
//     // Uncomment the test data
//     patients = [
//       Patient(name: 'Patient 1', info: 'Info for Patient 1',id: 5),
//       Patient(name: 'Patient 2', info: 'Info for Patient 2', id: 7),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const LocalizationIcon(),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   (adminPassword)
//                       ? S.of(context).doctors
//                       : S.of(context).patients,
//                   style: const TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//             Stack(
//   alignment: Alignment.center,
//   children: [
//     if (!adminPassword)
//       Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: _selectedItem,
//             onChanged: (String? newValue) {
//               setState(() {
//                 _selectedItem = newValue!;
//               });
//             },
//             items: <String>[
//               S.of(context).time,
//               S.of(context).danger,
//             ].map(
//               (String value) {
//                 return DropdownMenuItem<String>(
//                   value: value == S.of(context).time ? 'Time' : 'Danger',
//                   child: Text(value),
//                 );
//               },
//             ).toList(),
//             dropdownColor: Colors.grey[200],
//             elevation: 8,
//             icon: const Icon(Icons.arrow_drop_down),
//             iconEnabledColor: Colors.black,
//             iconDisabledColor: Colors.black,
//             iconSize: 24,
//             underline: Container(),
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       )
//   ],
// ),
//               ],
//             ),

//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: patients.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return
//                 PatientList(
//                   patient: patients[index],
//                 );
//               },
//             ),
//           ),
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 40),
//                   child: ElevatedButton.icon(
//                         onPressed: (){
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (ctx) => const AddDoctors()));
//                         },
//                          icon:const Icon(Icons.add),
//                          style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15)),
//                         fixedSize: const Size(210, 60)),

//                          label: Text(S.of(context).addDoctors,
//                           style: const TextStyle(
//                               fontSize: 25,
//                               color: Color.fromARGB(255, 255, 251, 251),
//                             ),
//                             textAlign: TextAlign.center,
//                          )
//                          ),
//                 )
//         ],

//       ),

//     );
//   }
// }
