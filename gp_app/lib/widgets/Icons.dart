import 'package:flutter/material.dart';
// import 'package:gp_app/generated/l10n.dart';
// import 'package:gp_app/screens/camera.dart';
// import 'package:gp_app/widgets/localization_icon.dart';

// class MainIcons extends StatelessWidget {
//   final Function onTap;
//   final String imagePath;
//   final String text;
//   final double height;
//   final double width;
//   final double textSize;
//   const MainIcons({
//     required this.onTap,
//     required this.imagePath,
//     required this.text,
//     this.height = 160,
//     this.width = 160,
//     this.textSize = 35,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: () => onTap(),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surface,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           height: height,
//           width: width,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: 10),
//               Image.asset(imagePath,),
//               Text(
//                 text,
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleLarge!
//                     .copyWith(color: Colors.white, fontSize: textSize),
                    
                    
//               )
//             ],
//           ),
//         ),
      
//     );
//   }
// }
class MainIcons extends StatelessWidget {
  final Function onTap;
  final String imagePath;
  final String text;
  final double height;
  final double width;
  final double textSize;
  final double? imageHeight;
  final double? imageWidth;

  const MainIcons({
    required this.onTap,
    required this.imagePath,
    required this.text,
    this.height = 160,
    this.width = 160,
    this.textSize = 35,
    this.imageHeight,
    this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Image.asset(
              imagePath,
              height: imageHeight,
              width: imageWidth,
            ),
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white, fontSize: textSize),
            ),
          ],
        ),
      ),
    );
  }
}