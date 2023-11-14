import 'package:flutter/material.dart';
import 'package:gp_app/classes/language.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/main.dart';
import 'package:gp_app/screens/signup_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
    final _formKey = GlobalKey<FormState>();


     void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

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
        padding: const EdgeInsets.only(top: 200) ,
        child:  SingleChildScrollView(
          child: Column(
              children: [
                Center(
                  child: Text(
                    S.of(context).login,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 30)
                        ,
                    ),
                    ),
                 const SizedBox(height: 20,),
                 Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                       vertical: 16
                       ),
                    child:  Column(
                        children: [
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
                              label:  Text(S.of(context).fistName,
                              style:  TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade500
                              ),
                              ),
                             ),
                            
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
                            
                          ),
                            
                          const SizedBox(height: 5,),
                            
                         Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(S.of(context).nothaveAcc),
                             const SizedBox(width: 10,),
                             TextButton(
                              onPressed: (){
                                 Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                              }, 
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                )
                            
                              ),
                              child: Text(
                                S.of(context).signNw),
                                ),
                            
                            
                            
                           ],
                         ),
                         const SizedBox(height: 10,) ,

               ElevatedButton(
                onPressed: _saveItem,
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
