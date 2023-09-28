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
    convertMessageStatus(requestMessage);
    showModalBottomSheet(
      useSafeArea: true,
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

  convertMessageStatus(RequestMessages requestMessage) async {
    await FirebaseDatabase.instance
        .ref()
        .child('messages/${currentUser!.uid}/${requestMessage.key}')
        .update({'viewed': 'true'});
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
            
            Coordinates coordinates = Coordinates(
              latitude: messageData['coordinates']['lat'].toString(),
              longitude: messageData['coordinates']['lng'].toString(),
            );

            RequestMessages currentMessage = RequestMessages(
                key: messageKey,
                description: messageData['desc'].toString(),
                category: messageData['radioOptions'].toString(),
                contactNumber: messageData['contactValue'].toString(),
                timeStamp:
                    DateTime.fromMillisecondsSinceEpoch(messageData['time']),
                isCallRequested: messageData['requestCall'].toString(),
                isRead: messageData['viewed'].toString(),
                coordinates: coordinates);
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
