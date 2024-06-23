import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/models/user_info.dart';
import 'package:gp_app/screens/doctor_profile.dart';
import 'package:gp_app/screens/main_page.dart';
import 'package:gp_app/screens/signup_screen.dart';
import 'package:gp_app/widgets/localization_icon.dart';
import 'package:gp_app/apis/apis.dart';
import 'package:gp_app/models/my_state.dart';
import 'package:gp_app/models/global.dart';
import 'package:provider/provider.dart';

String url = '';
String username = '';
String password = '';

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
  var _enteredPassword = '';
  final List<UserInfo> _userInfoList = [];

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final myState = Provider.of<MyState>(context, listen: false);
      String userId = myState.userId;

      // loginUser(_enteredName, _enteredPassword);

      UserInfo userInfo = UserInfo(_enteredName, _enteredPassword, userId);
      _userInfoList.add(userInfo);

      // Send data & then wait for the response either to go to main page or try again
      String response = await sendData(username, password, context);
      //  printUserInfoList();
      if (response == 'Access Allowed') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => const MainPageScreen()));
        // if (UserProfession == 'patient') {
        //   Navigator.of(context).push(
        //       MaterialPageRoute(builder: (ctx) => const MainPageScreen()));
        // } else {
        //   Navigator.of(context)
        //       .push(MaterialPageRoute(builder: (ctx) => const DocterProfile()));
        // }
      } else if (response == 'Access Denied') {
        login_warning(context);
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
    for (UserInfo userInfo in _userInfoList) {
      print('Username: ${userInfo.username}, Password: ${userInfo.password}');
      // print(_userInfoList.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LocalizationIcon(),
      body: Container(
        padding: const EdgeInsets.only(top: 200),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  S.of(context).login,
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
                      TextFormField(
                        // Monitor any change in the username field
                        onChanged: (value) {
                          //url = 'http://10.0.2.2:19999/api?query=' + value.toString(); // When launching the app 127.0.0.1
                          username = value.toString();
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
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 50) {
                            return 'Must be between 1 and 50 characters.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredName = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Monitor any change in the password field
                      TextFormField(
                        onChanged: (value) {
                          // url = 'http://10.0.2.2:19999/api?query=' + value.toString(); // When launching the app 127.0.0.1
                          password = value.toString();
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
                          return null;
                        },
                        onSaved: (value) {
                          _enteredPassword = value!;
                        },
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(S.of(context).nothaveAcc),
                          const SizedBox(
                            width: 10,
                          ),
                          // Backend:Button to go to SignUp page

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
                              );
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                )),
                            child: Text(S.of(context).signNw),
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
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Global.adminPassword = true;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => const DocterProfile()));

                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            fixedSize: const Size(210, 60)),
                        child: Text(
                          S.of(context).asadmin,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 255, 251, 251),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
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
