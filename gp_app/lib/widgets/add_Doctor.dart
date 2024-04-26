import 'package:flutter/material.dart';
import 'package:gp_app/generated/l10n.dart';
import 'package:gp_app/models/new_user.dart';
import 'package:gp_app/widgets/localization_icon.dart';

class AddDoctors extends StatefulWidget {
  const AddDoctors({super.key});

  @override
  State<AddDoctors> createState() {
    return _AddDoctorsState();
  }
}

class _AddDoctorsState extends State<AddDoctors> {
  final _formKey = GlobalKey<FormState>();
  var _enteredFirstName = '';
  var _enteredLastName = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  var output = '';
  final List<NewUser> _userInfoList = [];




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
                  S.of(context).doctorInfo,
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
                          const SizedBox(height: 30,)
                          ,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: (){},
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  fixedSize: const Size(130, 69)),
                              child: Text(
                                S.of(context).save,
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 255, 251, 251),
                                ),
                              )),
                        ],
                      ),
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
