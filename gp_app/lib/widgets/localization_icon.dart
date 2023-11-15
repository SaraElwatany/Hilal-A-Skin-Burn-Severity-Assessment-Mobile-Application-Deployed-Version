
import 'package:flutter/material.dart';
import 'package:gp_app/classes/language.dart';
// import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/main.dart';


class LocalizationIcon extends StatelessWidget implements PreferredSizeWidget{
  const LocalizationIcon({super.key}) ;

 @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); 
  
  @override
  Widget build(BuildContext context) {
    
    return AppBar(
  actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Language>(
              underline: const SizedBox(),
              icon: const Icon(
                Icons.language,
                color: Colors.white,
              ),
              onChanged: (Language? language) {
                if (language != null) {
                  MyApp.setLocale(context, Locale(language.languageCode, ''));
                }
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.flag,
                            style: const TextStyle(fontSize: 30),
                          ),
                          Text(e.name,
                          style: const TextStyle(
                            color: Colors.white
                          ),)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      

    );
  }
}