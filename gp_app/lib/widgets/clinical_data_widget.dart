import 'package:gp_app/screens/clinical_data.dart';
import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';

class ClinicalData extends StatefulWidget {
  const ClinicalData({
    Key? key,
    required this.symptom,
    required this.selectedSymptoms,
    required this.onSymptomSelected,
  }) : super(key: key);

  final Symptoms symptom;
  final List<Symptoms> selectedSymptoms;
  final void Function(Symptoms) onSymptomSelected;

  @override
  _ClinicalDataState createState() => _ClinicalDataState();
}

class _ClinicalDataState extends State<ClinicalData> {
  @override
  Widget build(BuildContext context) {
    bool isSecondGroup = widget.symptom.index >= 4;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.black,
            ),
            child: Checkbox(
              value: widget.selectedSymptoms.contains(widget.symptom),
              onChanged: (checked) {
                widget.onSymptomSelected(widget.symptom);
              },
              activeColor: const Color.fromARGB(255, 29, 49, 78),
            ),
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
                                        : widget.symptom == Symptoms.radioactive
                                            ? S.of(context).radioactive
                                            : '',
            style: TextStyle(
              color: widget.selectedSymptoms.contains(widget.symptom)
                  ? const Color.fromARGB(255, 29, 49, 78) // Selected color
                  : Colors.black, // Default color
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
