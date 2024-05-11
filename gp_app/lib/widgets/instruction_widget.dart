


import 'package:flutter/material.dart';


class InstructionsWidget extends StatelessWidget {

  final String title;
  final String text;


  const InstructionsWidget({
    Key? key,
    required this.title,
    required this.text,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
        title,
        style:
            Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
        ),
        const SizedBox(height: 10,),
         Text(
        text,
        // textAlign: TextAlign.center,
        style:
            Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
        ),
      ],

    );
  }
}
