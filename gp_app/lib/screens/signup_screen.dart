import 'package:flutter/material.dart';
// import 'package:gp_app/classes/language.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/models/new_user.dart';
// import 'package:gp_app/main.dart';
import 'package:gp_app/screens/login_screen.dart';
import 'package:gp_app/screens/main_page.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/apis/apis.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredFirstName = '';
  var _enteredLastName = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  final List<NewUser> _userInfoList = [];

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (isValidEmail(_enteredEmail)) {
        NewUser userInfo = NewUser(_enteredFirstName, _enteredLastName,
            _enteredEmail, _enteredPassword);

        _userInfoList.add(userInfo);
        signup(userInfo);
        // printUserInfoList();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => const MainPageScreen()));
      } else {
        // Invalid email, show an error message to the user
        print('Invalid email address');
      }
    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid Input'),
                content: const Text(
                  'Please fill in all required fields correctly',
                ),
                backgroundColor: Colors.white,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text(
                      'Okay',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ));
    }
  }

  void printUserInfoList() {
    for (NewUser userInfo in _userInfoList) {
      print(
          'Firstname: ${userInfo.firstName},Lastname: ${userInfo.lastName},Email: ${userInfo.email} ,Password: ${userInfo.password}');
      print(_userInfoList.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LocalizationIcon(),
      body: Container(
        padding: const EdgeInsets.only(top: 150),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  S.of(context).signup,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 30),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  child: Column(
                    children: [
                      Row(children: [
                        Expanded(
                          child: TextFormField(
                            maxLength: 50,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                              label: Text(
                                S.of(context).firstName,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey.shade500),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length <= 1) {
                                return 'Must be between 1 and 50 characters.';
                              }
                              return null;
                            },
                            onSaved: (value) => _enteredFirstName = value!,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            maxLength: 50,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                              label: Text(
                                S.of(context).lastName,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey.shade500),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length <= 1) {
                                return 'Must be between 1 and 50 characters.';
                              }
                              return null;
                            },
                            onSaved: (value) => _enteredLastName = value!,
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLength: 50,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          label: Text(
                            S.of(context).mail,
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade500),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]") 
                              .hasMatch(value)) {
                            return 'Please enter a valid Email';
                          }
                          return null;
                        },
                        onSaved: (value) => _enteredEmail = value!,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          label: Text(
                            S.of(context).password,
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade500),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter a Password';
                          }
                          return null;
                        },
                        onSaved: (value) => _enteredPassword = value!,

                        ///
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(S.of(context).haveAcc),
                          const SizedBox(
                            width: 10,
                          ),
                          // Backend:Button to go to Login page
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                )),
                            child: Text(S.of(context).loginNw),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Backend:Button to go to Main page
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
