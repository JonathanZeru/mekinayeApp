import 'package:intl/intl.dart';

String duTimeLineFormat(DateTime createdAt) {
  final now = DateTime.now();
  final difference = now.difference(createdAt);

  if (difference.inMinutes < 1) {
    return 'just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24 && now.day == createdAt.day) {
    return DateFormat('h:mm a').format(createdAt); // Today at 9:03 AM
  } else if (difference.inDays == 1 || (difference.inHours < 48 && now.day != createdAt.day)) {
    return 'yesterday at ${DateFormat('h:mm a').format(createdAt)}'; // Yesterday at 9:03 AM
  } else if (difference.inDays < 7) {
    return DateFormat('EEEE at h:mm a').format(createdAt); // Monday at 9:03 AM
  } else if (difference.inDays < 365) {
    return DateFormat('MMM d at h:mm a').format(createdAt); // Aug 23 at 9:03 AM
  } else {
    return DateFormat('MMM d, yyyy at h:mm a').format(createdAt); // Aug 23, 2024 at 9:03 AM
  }
}