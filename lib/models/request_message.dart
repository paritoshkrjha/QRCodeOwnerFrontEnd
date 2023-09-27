class RequestMessages {
  final String key;
  final String description;
  final String category;
  final String isCallRequested;
  final String contactNumber;
  final DateTime timeStamp;
  final String isRead;

  RequestMessages(this.key, this.description, this.category, this.contactNumber,
      this.timeStamp, this.isCallRequested, this.isRead);
}
