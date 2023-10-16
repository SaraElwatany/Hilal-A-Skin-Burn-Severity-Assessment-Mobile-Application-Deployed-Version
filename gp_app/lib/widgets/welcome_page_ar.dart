

import 'package:flutter/material.dart';

class WelcomePageAR extends StatelessWidget{
  const WelcomePageAR({super.key});

  @override
  Widget build(BuildContext context) {
   return  Align(
  alignment: Alignment.centerRight,
  child: Container(
    padding: const EdgeInsets.only(right: 20,top: 80), // Adjust the left padding
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '!  أهلا ',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 50,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          ".أنا هلال, رفيق صحتك ",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        const Text(
          "!أولًا, محتاج أعرف لغتك المفضلة ",
          style: TextStyle(fontSize: 18),
        ),

      ],
    ),
  ),
);
  }
}
          
 

   