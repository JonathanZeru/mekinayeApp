import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/message/message_controller.dart';
import '../../widget/message/chat_left.dart';
import '../../widget/message/chat_right.dart';
import '../../util/date.dart';  // Import your date utility for formatting dates

class ChatList extends GetView<MessageController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        padding: EdgeInsets.only(bottom: 60),
        child: CustomScrollView(
          reverse: true,
          controller: controller.msgScrolling,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    var item = controller.messages[index];
                    var previousItem = index > 0 ? controller.messages[index - 1] : null;
                    bool showDateSeparator = false;

                    if (previousItem == null ||
                        !isSameDate(item.createdAt!, previousItem.createdAt!)) {
                      showDateSeparator = true;
                    }

                    return Column(
                      children: [
                        if (showDateSeparator)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Center(
                              child: Container(
                                color: Colors.grey.withOpacity(0.2),
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                width: double.infinity,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      formatMessageDate(item.createdAt!),
                                      style: const TextStyle(color: Colors.black, fontSize: 12.0),
                                    ),
                                  ),
                                )
                              )
                            ),
                          ),
                        controller.userId.value == item.senderId.toString()
                            ? ChatRightItem(item)
                            : ChatLeftItem(item),
                      ],
                    );
                  },
                  childCount: controller.messages.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated formatMessageDate function
  String formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final justNow = now.subtract(const Duration(minutes: 1));

    if (date.isAfter(justNow)) {
      return 'Just now (${_formatMonthAndDay(date)})';
    }

    final relativeTime = duTimeLineFormat(date);

    final monthAndDay = _formatMonthAndDay(date);

    return '$relativeTime ($monthAndDay)';
  }

  String _formatMonthAndDay(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}';
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
