import 'package:flutter/material.dart';
// import 'package:gp_app/classes/language.dart';
import 'package:gp_app/generated/l10n.dart';
// import 'package:gp_app/main.dart';
import 'package:gp_app/screens/main_page.dart';
import 'package:gp_app/screens/signup_screen.dart';
import 'package:gp_app/widgets/localization_icon.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
    final _formKey = GlobalKey<FormState>();
    var _enteredName = '';
    var _enteredPassword;


     void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    Navigator.of(context).
    push(MaterialPageRoute(
      builder: (ctx)=>const  MainPageScreen()
    ));
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar:const LocalizationIcon(), 
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
                             validator: (value){
                             if (value == null ||
                                value.isEmpty ||
                                value.trim().length <= 1 ||
                                 value.trim().length > 50) {
                            return 'Must be between 1 and 50 characters.';
                                      }
                                   return null;
                             },
                             onSaved: (value) {
                             _enteredName=value!;
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
