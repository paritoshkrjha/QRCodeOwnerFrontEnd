import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:owner_front/widgets/req_card.dart';
import 'package:owner_front/widgets/req_overlay.dart';

class NewRequestList extends StatefulWidget {
  const NewRequestList({super.key});

  @override
  State<NewRequestList> createState() => _NewRequestListState();
}

class _NewRequestListState extends State<NewRequestList> {
  final dbRef = FirebaseDatabase.instance.ref().child('messages');
  final currentUser = FirebaseAuth.instance.currentUser;

  List<Map<String, dynamic>> messages = [];

  openDetailOverlay(
    String category,
    String desc,
    String requestCall,
    String contactValue,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: RequestDetailsOverlay(
            category: category,
            desc: desc,
            requestCall: requestCall,
            contactValue: contactValue,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, messageSnapshots) {
        if (messageSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!messageSnapshots.hasData ||
            messageSnapshots.data!.snapshot.value == null) {
          return const Center(
            child: Text("No new requests..."),
          );
        }

        final messageData =
            messageSnapshots.data!.snapshot.value as Map<dynamic, dynamic>;

        messages.clear();

        if (messageData.containsKey(currentUser!.uid)) {
          final userMessages =
              messageData[currentUser!.uid] as Map<dynamic, dynamic>;

          userMessages.forEach((messageKey, messageData) {
            // Access message properties here
            String desc = messageData['desc'].toString();
            String category = messageData['radioOptions'].toString();
            String requestCall = messageData['requestCall'].toString();
            String contactValue = messageData['contactValue'].toString();
            messages.add({
              "key": messageKey,
              "desc": desc,
              "category": category,
              "requestCall": requestCall,
              "contactValue": contactValue,
            });
          });
        }

        if (messages.isEmpty) {
          return const Center(
            child: Text("No new requests for you..."),
          );
        }

        messages.sort((a, b) => b['key'].compareTo(a['key']));

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return RequestCard(
              desc: messages[index]['desc'],
              category: messages[index]['category'],
              requestCall: messages[index]['requestCall'],
              openDetailOverlay: () => openDetailOverlay(
                messages[index]['category'],
                messages[index]['desc'],
                messages[index]['requestCall'],
                messages[index]['contactValue'],
              ),
            );
          },
        );
      },
    );
  }
}
