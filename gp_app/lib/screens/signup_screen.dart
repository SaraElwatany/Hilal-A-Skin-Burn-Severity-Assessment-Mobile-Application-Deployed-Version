
import 'package:flutter/material.dart';
import 'package:gp_app/classes/language.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/main.dart';
import 'package:gp_app/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
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
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 150) ,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  S.of(context).signup,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 30)
                      ,
                  ),
                  ),
               const SizedBox(height: 20,),
               Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                     vertical: 16
                     ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                         Expanded(
                           child: TextFormField(   
                            maxLength: 50,
                              decoration:  InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200  ,       
                             focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:  BorderSide(
                                width: 2.0,
                                 color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            enabledBorder:OutlineInputBorder(
                                             borderRadius: BorderRadius.circular(25.0),
                                             borderSide: BorderSide(
                                               color: Theme.of(context).colorScheme.surface,
                                             ),
                                           ),
                            label:  Text(S.of(context).fistName,
                            style:  TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade500
                            ),
                            ),
                           ),
                           validator: (value) {
                           if(value==null ||
                            value.isEmpty ||
                            value.trim().length <= 1 
                           ){
                             return 'Must be between 1 and 50 characters.';
                           }
                           return null;
                           }                                            
                          ),
                         ),
                      const SizedBox(width: 10,),
                     Expanded(
                          child: TextFormField(   
                          maxLength: 50,
                          decoration:  InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200  ,       
                             focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:  BorderSide(
                                width: 2.0,
                                 color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            enabledBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                            label:  Text(S.of(context).lastName,
                            style:  TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade500
                            ),
                            ),
                           ),
                           validator: (value) {
                           if(value==null ||
                            value.isEmpty ||
                            value.trim().length <= 1 
                           ){
                             return 'Must be between 1 and 50 characters.';
                           }
                           return null;
                           }                 
                        ),
              ),
                        ]
                      ),
                      const SizedBox(height: 10,),
                        TextFormField(   
                        maxLength: 50,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200  ,       
                           focusedBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide:  BorderSide(
                              width: 2.0,
                               color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          enabledBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                          label:  Text(S.of(context).mail,
                          style:  TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade500
                          ),
                          ),
                         ),
                         validator: (value){
                      if(value!.isEmpty)
                      {
                        return 'Please a Enter';
                      }
                      if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                        return 'Please a valid Email';
                      }
                      return null;
                    },
        
                      ),
                      const SizedBox(height: 10,),
                        TextFormField(  
                          keyboardType: TextInputType.number,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200  ,       
                           focusedBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide:  BorderSide(
                              width: 2.0,
                               color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          enabledBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                          label:  Text(S.of(context).password,
                          style:  TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade500
                          ),
                          ),
                         ),
                        validator: (value){
                      if(value!.isEmpty)
                      {
                        return 'Please a Enter Password';
                      }
                      return null;
                    },
        
                      ),
                      
                      const SizedBox(height: 5,),
        
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text(S.of(context).haveAcc),
                         const SizedBox(width: 10,),
                         TextButton(
                          onPressed: (){Navigator.pop(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );}, 
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            textStyle: const TextStyle(
                              fontSize: 15,
                            )
        
                          ),
                          child: Text(
                            S.of(context).loginNw),
                            ),
        
        
        
                       ],
                     )
                     ,
                         const SizedBox(height: 10,) ,

               ElevatedButton(
                onPressed: () {
                 
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    fixedSize: const Size(130, 69)),
                child: Text(
                  S.of(context).next,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 255, 251, 251),
                  ),
                )),
                    ],
                
                  ),
                ),
                ),
        
            ],
          ),
        ),
      ),
          
      
    );
  }
}