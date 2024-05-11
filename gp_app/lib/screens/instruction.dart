import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/widgets/instruction_widget.dart';
import 'package:gp_app/widgets/localization_icon.dart';

class Instructions extends StatelessWidget {
  const Instructions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LocalizationIcon(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
           decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                          const SizedBox(height: 20),
                           SizedBox(
                            height: 80,
                            width: 100,
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: InstructionsWidget(
                              title: S.of(context).goodLigthingTitle,
                               text: S.of(context).goodLigthingtext)
                          ),
                              const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: InstructionsWidget(
                              title: S.of(context).simpleBackgroundTitle,
                               text: S.of(context).simpleBackgroundText)
                          ),
                           const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: InstructionsWidget(
                              title: S.of(context).flashligthTitle,
                               text: S.of(context).flashligthText)
                          ),
                             const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: InstructionsWidget(
                              title: S.of(context).burnDetailsTitle,
                               text: S.of(context).burnDetailsText)
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: InstructionsWidget(
                              title: S.of(context).burnTouchTitle,
                               text: S.of(context).burnDetailsText)
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: InstructionsWidget(
                              title: S.of(context).privacyTitle,
                               text: S.of(context).privacyText)
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: InstructionsWidget(
                              title: S.of(context).areadetection,
                               text: S.of(context).areadetectionText)
                          ),
                          const SizedBox(height: 20),
                        ],
                      
                                
                            ),
                  ),
        ),
      ),
    );
  }
}
