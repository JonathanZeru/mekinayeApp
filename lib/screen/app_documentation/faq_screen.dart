import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import '../../controller/docs/faq_controller.dart';
import '../../widget/loading.dart';

class FaqScreen extends StatelessWidget {
  final FAQController faqController = Get.put(FAQController()); // Initialize the controller

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ"),
      ),
      body: Obx(() {
        if (faqController.isLoading.value) {
          return Center(child: Loading());
        }

        if (faqController.faqList.isEmpty) {
          return Center(child: Text("No FAQs available"));
        }

        return ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: faqController.faqList.length,
          itemBuilder: (context, index) {
            final faq = faqController.faqList[index];
            return ExpansionTile(
              title: Text(faq.title,
                  style: theme.typography.titleMedium
                      .copyWith(color: theme.primaryText, fontWeight: FontWeight.bold)),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(faq.description,
                      style: theme.typography.titleMedium
                          .copyWith(color: theme.primaryText, fontSize: 14)),
                )
              ],
            );
          },
        );
      }),
    );
  }
}
