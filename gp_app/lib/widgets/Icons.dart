import 'package:flutter/material.dart';
// import 'package:gp_app/generated/l10n.dart';
// import 'package:gp_app/screens/camera.dart';
// import 'package:gp_app/widgets/localization_icon.dart';

class MainIcons extends StatelessWidget {
  final Function onTap;
  final String imagePath;
  final String text;

  const MainIcons({
    required this.onTap,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 187,
          width: 187,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Image.asset(imagePath),
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
