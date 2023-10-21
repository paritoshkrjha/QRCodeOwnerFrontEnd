import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:owner_front/constants/auth_error.dart';
import 'package:owner_front/screens/splash_screen.dart';

import 'forgot_pass.dart';

final _firebase = FirebaseAuth.instance;
FirebaseFirestore database = FirebaseFirestore.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  bool loading = false;

  late UserCredential userCredentials;

  var _enteredEmail = "";
  var _enteredPassword = "";
  var _enteredName = "";
  var _enteredVehicleNum = "";
  var _enteredEmergencyNum1 = "";
  var _enteredEmergencyNum2 = "";

  _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      if (_isLogin) {
        setState(() {
          loading = true;
        });
        userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        CollectionReference users = database.collection('users');
        await users.doc(userCredentials.user!.uid).set(
          {
            "name": _enteredName,
            "email": _enteredEmail,
            "vehicle_number": _enteredVehicleNum,
            "emergency_contact1": _enteredEmergencyNum1,
            "emergency_contact2": _enteredEmergencyNum2,
          },
        );
      }
    } on FirebaseAuthException catch (err) {
      // print('Error: $err');
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(kErrorMessages[err.code]!),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: loading
            ? const SplashScreen()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 30,
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        width: 200,
                        child: Text(
                          _isLogin ? "Sign In" : "Sign Up",
                          style: const TextStyle(
                            fontSize: 36,
                            color: Color(0xff0f2138),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Card(
                      color: const Color(0xfff8f8f8),
                      surfaceTintColor: Colors.grey,
                      margin: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _isLogin
                                    ? const SizedBox()
                                    : TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Full Name',
                                        ),
                                        autocorrect: false,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Please enter a valid name';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _enteredName = value!;
                                        },
                                      ),
                                _isLogin
                                    ? const SizedBox()
                                    : TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Vehicle Number',
                                        ),
                                        autocorrect: false,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Please enter a valid name';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _enteredVehicleNum = value!;
                                        },
                                      ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Email Address',
                                  ),
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  textCapitalization: TextCapitalization.none,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty ||
                                        !value.contains('@')) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredEmail = value!;
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().length < 6) {
                                      return 'Password must be atleast 6 characters long';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredPassword = value!;
                                  },
                                ),
                                _isLogin
                                    ? const SizedBox()
                                    : TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Emergency Contact 1',
                                        ),
                                        autocorrect: false,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty ||
                                              value.length < 10 ||
                                              value.length > 10) {
                                            return 'Please enter a valid number';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _enteredEmergencyNum1 = value!;
                                        },
                                      ),
                                _isLogin
                                    ? const SizedBox()
                                    : TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Emergency Contact 2',
                                        ),
                                        autocorrect: false,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty ||
                                              value.length < 10 ||
                                              value.length > 10) {
                                            return 'Please enter a valid number';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _enteredEmergencyNum2 = value!;
                                        },
                                      ),
                                const SizedBox(
                                  height: 12,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _submit();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff0f2138)),
                                  child: Text(
                                    _isLogin ? 'Log In' : 'Sign Up',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(_isLogin
                                      ? 'Create an account'
                                      : 'I already have an account'),
                                ),
                                _isLogin
                                    ? TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ForgotPassword()));
                                        },
                                        child: const Text(
                                          'Forgot password ?',
                                          textAlign: TextAlign.end,
                                        ))
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
