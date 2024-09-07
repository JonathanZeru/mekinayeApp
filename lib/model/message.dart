import 'package:intl/intl.dart';
import 'package:mekinaye/model/spare_part.dart';
import 'package:mekinaye/util/app_constants.dart'; // For date formatting, optional

class Message {
  final int? id;
  final String? imageUrl;
  final String? audioUrl; // Added audioUrl field
  final String? text;
  final int? senderId;
  final int? receiverId;
  final String? senderUsername;
  final String? receiverUsername;
  final int? sparePartId;
  final SparePart? sparePart;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Message(
      {this.id,
      this.imageUrl,
      this.audioUrl, // Initialize audioUrl in the constructor
      this.text,
      this.senderId,
      this.receiverId,
      this.senderUsername,
      this.receiverUsername,
      this.createdAt,
      this.updatedAt,
      this.sparePart,
      this.sparePartId});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': imageUrl,
      'audio': audioUrl,
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderUsername': senderUsername,
      'receiverUsername': receiverUsername,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    String image = 'null';
    String audio = 'null';
    if (json['imageUrl'] != null) {
      image = '${AppConstants.imageUrl}${json['imageUrl']}';
    }
    if (json['audioUrl'] != null) {
      audio = '${AppConstants.imageUrl}${json['audioUrl']}';
    }
    return Message(
      id: json['id'],
      imageUrl: image,
      audioUrl: audio,
      text: json['text'] ?? 'null',
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      senderUsername: json['senderUsername'],
      receiverUsername: json['receiverUsername'],
      createdAt:
          DateTime.parse(json['createdAt']), // Parse DateTime from string
    );
  }
}
