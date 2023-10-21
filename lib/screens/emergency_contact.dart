import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:owner_front/models/current_user.dart';
import 'package:owner_front/screens/splash_screen.dart';

FirebaseFirestore database = FirebaseFirestore.instance;

class EmergencyContactsScreen extends StatefulWidget {
  final CurrentUser currentUser;
  const EmergencyContactsScreen({super.key, required this.currentUser});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final _firstFormKey = GlobalKey<FormState>();
  final _secondFormKey = GlobalKey<FormState>();
  bool firstUpdateToggle = true;
  bool secondUpdateToggle = true;
  var _firstNewEmergencyContact = '';
  var _secondNewEmergencyContact = '';
  bool isUserDetailsReady = false;
  CurrentUser user = CurrentUser(
      userName: '',
      emergencyContact1: '',
      emergencyContact2: '',
      email: '',
      vehicleNum: '');

  @override
  void initState() {
    super.initState();
    getUpdatedUserDetails();
  }

  void getUpdatedUserDetails() async {
    setState(() {
      isUserDetailsReady = false;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (DocumentSnapshot doc) {
        Map<String, dynamic> userDetails = doc.data() as Map<String, dynamic>;
        CurrentUser temp = CurrentUser(
          emergencyContact1: userDetails['emergency_contact1'],
          emergencyContact2: userDetails['emergency_contact2'],
          userName: userDetails['name'],
          email: userDetails['email'],
          vehicleNum: userDetails['vehicle_number'],
        );

        setState(() {
          isUserDetailsReady = true;
          user = temp;
        });
      },
      // onError: (e) => print('Error : $e'),
    );
  }

  void _firstContactToggleHandler() {
    setState(() {
      firstUpdateToggle = !firstUpdateToggle;
    });
  }

  void _secondContactToggleHandler() {
    setState(() {
      secondUpdateToggle = !secondUpdateToggle;
    });
  }

  void firstContactUpdateHandler() async {
    final isValid = _firstFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _firstFormKey.currentState!.save();

    try {
      await database
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'emergency_contact1': _firstNewEmergencyContact},
              SetOptions(merge: true));
      _firstFormKey.currentState?.reset();
      _firstContactToggleHandler();
      getUpdatedUserDetails();
    } catch (e) {
      print(e);
    }
  }

  void secondContactUpdateHandler() async {
    final isValid = _secondFormKey.currentState!.validate();

    if (!isValid) {
      return;
    }
    _secondFormKey.currentState!.save();

    try {
      await database
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'emergency_contact2': _secondNewEmergencyContact},
              SetOptions(merge: true));
      _secondFormKey.currentState?.reset();
      _secondContactToggleHandler();
      getUpdatedUserDetails();
    } catch (e) {
      print(e);
    }
  }

  Widget customDetailItem(String label, String value, toggleHandler) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            IconButton(onPressed: toggleHandler, icon: const Icon(Icons.edit))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
      ),
      body: !isUserDetailsReady
          ? const SplashScreen()
          : Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                customDetailItem('First contact', user.emergencyContact1,
                    _firstContactToggleHandler),
                const SizedBox(
                  height: 10,
                ),
                !firstUpdateToggle
                    ? Form(
                        key: _firstFormKey,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'New emergency contact',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          width: 2,
                                        ))),
                                autocorrect: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.length < 10 ||
                                      value.length > 10) {
                                    return 'Please enter a valid contact';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _firstNewEmergencyContact = value!;
                                },
                              ),
                            ),
                            ButtonBar(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      _firstContactToggleHandler();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(fontSize: 18),
                                    )),
                                TextButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green)),
                                  onPressed: firstContactUpdateHandler,
                                  child: const Text(
                                    'Update',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: 10,
                      ),
                customDetailItem('Second contact', user.emergencyContact2,
                    _secondContactToggleHandler),
                const SizedBox(
                  height: 10,
                ),
                !secondUpdateToggle
                    ? Form(
                        key: _secondFormKey,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'New emergency contact',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          width: 2,
                                        ))),
                                autocorrect: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.length < 10 ||
                                      value.length > 10) {
                                    return 'Please enter a valid contact';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _secondNewEmergencyContact = value!;
                                },
                              ),
                            ),
                            ButtonBar(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      _secondContactToggleHandler();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(fontSize: 18),
                                    )),
                                TextButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green)),
                                  onPressed: secondContactUpdateHandler,
                                  child: const Text(
                                    'Update',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: 10,
                      ),
              ],
            ),
    );
  }
}
