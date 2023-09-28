class Coordinates {
  final String latitude;
  final String longitude;

  Coordinates({required this.latitude, required this.longitude});
}

class RequestMessages {
  final String key;
  final String description;
  final String category;
  final String isCallRequested;
  final String contactNumber;
  final DateTime timeStamp;
  final String isRead;
  final Coordinates coordinates;

  RequestMessages(
      {required this.key,
      required this.description,
      required this.category,
      required this.contactNumber,
      required this.timeStamp,
      required this.isCallRequested,
      required this.isRead,
      required this.coordinates});
}
