import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:owner_front/screens/splash_screen.dart';

final _auth = FirebaseAuth.instance;
FirebaseFirestore database = FirebaseFirestore.instance;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  late UserCredential userCredentials;

  var _enteredEmail = "";

  _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      loading = true;
    });

    await _auth.sendPasswordResetEmail(email: _enteredEmail).then((value) {
      setState(() {
        loading = false;
      });
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Successful'),
                content: const Text(
                    'Reset link has been sent to your mail. Update your password and sign in.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text('Ok'))
                ],
              ));
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Something went wrong'),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok'))
                ],
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
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
                        child: const Text(
                          "Forgot Password ?",
                          style: TextStyle(
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
                                const SizedBox(
                                  height: 12,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _submit();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff0f2138)),
                                  child: loading
                                      ? const SizedBox(
                                          child: CircularProgressIndicator())
                                      : const Text(
                                          'Reset Password',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
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
