import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/screens/clinical_data.dart';

class ClinicalData extends StatefulWidget{

   ClinicalData({
    super.key,
    required this.symptom
    });

  Symptoms symptom;

  @override
  State<ClinicalData> createState() => _ClinicalDataState();
}

class _ClinicalDataState extends State<ClinicalData> {
  Symptoms? selectedSymptom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            if (widget.symptom.index >= 4 && widget.symptom.index <= 7) {
              selectedSymptom = selectedSymptom == widget.symptom
                  ? null
                  : widget.symptom;
            } else {
              selectedSymptom =
                  selectedSymptom == widget.symptom ? null : widget.symptom;
            }
          });
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: selectedSymptom == widget.symptom
                  ? const Color.fromARGB(255, 29, 49, 78)
                  : Colors.grey.shade500,
              radius: 12,
              child: selectedSymptom == widget.symptom
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              widget.symptom == Symptoms.symptom_1
                  ? S.of(context).symptom_1
                  : widget.symptom == Symptoms.symptom_2
                      ? S.of(context).symptom_2
                      : widget.symptom == Symptoms.symptom_3
                          ? S.of(context).symptom_3
                          : widget.symptom == Symptoms.symptom_4
                              ? S.of(context).symptom_4
                              : widget.symptom == Symptoms.heat
                                  ? S.of(context).heat
                                  : widget.symptom == Symptoms.electricity
                                      ? S.of(context).electricity
                                      : widget.symptom == Symptoms.chemical
                                          ? S.of(context).chemical
                                          : widget.symptom ==
                                                  Symptoms.radioactive
                                              ? S.of(context).radioactive
                                              : '',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:gp_app/generated/l10n.dart';
// import 'package:gp_app/screens/clinical_data.dart';

// class ClinicalData extends StatefulWidget {
//   ClinicalData({
//     Key? key,
//     required this.symptom,
//   }) : super(key: key);

//   final Symptoms symptom;

//   @override
//   State<ClinicalData> createState() => _ClinicalDataState();
// }

// class _ClinicalDataState extends State<ClinicalData> {
//   Symptoms? selectedSymptom;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Radio<Symptoms>(
//             value: widget.symptom,
//             groupValue: selectedSymptom,
//             onChanged: (Symptoms? value) {
//               setState(() {
//                 selectedSymptom = value == selectedSymptom ? null : value;
//               });
//             },
//             activeColor: const Color.fromARGB(255, 29, 49, 78),
//           ),
//           const SizedBox(width: 10),
//           Text(
//             widget.symptom == Symptoms.symptom_1
//                 ? S.of(context).symptom_1
//                 : widget.symptom == Symptoms.symptom_2
//                     ? S.of(context).symptom_2
//                     : widget.symptom == Symptoms.symptom_3
//                         ? S.of(context).symptom_3
//                         : widget.symptom == Symptoms.symptom_4
//                             ? S.of(context).symptom_4
//                             : widget.symptom == Symptoms.heat
//                                 ? S.of(context).heat
//                                 : widget.symptom == Symptoms.electricity
//                                     ? S.of(context).electricity
//                                     : widget.symptom == Symptoms.chemical
//                                         ? S.of(context).chemical
//                                         : widget.symptom ==
//                                                 Symptoms.radioactive
//                                             ? S.of(context).radioactive
//                                             : '',
//             style: TextStyle(
//               color: selectedSymptom == widget.symptom
//                   ? const Color.fromARGB(255, 29, 49, 78) // Selected color
//                   : Colors.black, // Default color
//               fontSize: 18,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
