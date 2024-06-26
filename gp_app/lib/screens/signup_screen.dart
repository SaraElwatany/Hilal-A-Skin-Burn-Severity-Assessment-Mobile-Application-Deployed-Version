import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/apis/apis.dart';
// import 'package:gp_app/models/my_state.dart';
import 'package:gp_app/models/global.dart';
// import 'package:provider/provider.dart';

import 'package:gp_app/models/new_user.dart';
import 'package:gp_app/screens/login_screen.dart';
import 'package:gp_app/screens/main_page.dart';

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
  var output = '';
  final List<NewUser> _userInfoList = [];
  bool flag = Global.adminPassword;

  void _saveItem() async {
    NewUser userInfo = NewUser(
      firstName: _enteredFirstName,
      lastName: _enteredLastName,
      email: _enteredEmail,
      password: _enteredPassword,
      userId: Global.userId,
    );
    _userInfoList.add(userInfo);
    // Get the User Profession
    String user_profession;
    user_profession = (await SessionManager.getUserProfession()) ?? '';

    output = await signUp(userInfo, user_profession);

    if ((_formKey.currentState!.validate()) && (output == 'Sign up Allowed')) {
      _formKey.currentState!.save();

      // printUserInfoList();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => const MainPageScreen(),
      ));
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
                  (flag) ? S.of(context).doctorInfo : S.of(context).signup,
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
                            onChanged: (value) {
                              _enteredFirstName = value.toString();
                            },
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
                            onChanged: (value) {
                              _enteredLastName = value.toString();
                            },
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
                                    fontSize: 17, color: Colors.grey.shade500),
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
                        onChanged: (value) {
                          _enteredEmail = value.toString();
                        },
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
                          if (output == 'Sign up Denied due to email') {
                            return 'Please enter a valid Email';
                          }
                          if (output ==
                              'Sign up Denied due to password & email') {
                            return 'Please enter a valid Email';
                          }
                          if (output ==
                              'Sign up Denied due to duplicate email') {
                            return 'An account with this Email already exist';
                          }
                          return null;
                        },
                        onSaved: (value) => _enteredEmail = value!,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          _enteredPassword = value.toString();
                        },
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

                          if (output == 'Sign up Denied due to password') {
                            return 'Please Enter a Valid Password Format';
                          }

                          if (output ==
                              'Sign up Denied due to password & email') {
                            return 'Please Enter a Valid Password Format';
                          }
                          return null;
                        },
                        onSaved: (value) => _enteredPassword = value!,

                        ///
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      if (flag)
                        TextFormField(
                          onChanged: (value) {
                            _enteredLastName = value.toString();
                          },
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
                              S.of(context).degree,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey.shade500),
                            ),
                          ),
                        ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (flag) ? Container() : Text(S.of(context).haveAcc),
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
                            child: (flag)
                                ? Container()
                                : Text(S.of(context).loginNw),
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
                            (!flag) ? S.of(context).next : S.of(context).save,
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
