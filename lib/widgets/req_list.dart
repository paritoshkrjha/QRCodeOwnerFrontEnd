import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:owner_front/models/request_message.dart';
import 'package:owner_front/widgets/req_card.dart';
import 'package:owner_front/widgets/req_overlay.dart';

class RequestList extends StatefulWidget {
  const RequestList({super.key});

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  final dbRef = FirebaseDatabase.instance.ref().child('messages');
  final currentUser = FirebaseAuth.instance.currentUser;

  List<RequestMessages> messages = [];

  openDetailOverlay(RequestMessages requestMessage) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: RequestDetailsOverlay(
            requestMessage: requestMessage,
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
            String desc = messageData['desc'].toString();
            String category = messageData['radioOptions'].toString();
            String requestCall = messageData['requestCall'].toString();
            String contactValue = messageData['contactValue'].toString();
            DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(messageData['time']);
            RequestMessages currentMessage = RequestMessages(messageKey, desc,
                category, contactValue, dateTime, requestCall);
            messages.add(currentMessage);
          });
        }

        if (messages.isEmpty) {
          return const Center(
            child: Text("No new requests for you..."),
          );
        }

        messages.sort((a, b) => b.key.compareTo(a.key));

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return RequestCard(
              requestMessage: messages[index],
              openDetailOverlay: () => openDetailOverlay(messages[index]),
            );
          },
        );
      },
    );
  }
}
