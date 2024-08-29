import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import '../../controller/docs/terms-controller.dart';
import '../../widget/loading.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final TermsAndConditionsController termsController = Get.put(TermsAndConditionsController()); // Initialize the controller

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Conditions"),
      ),
      body: Obx(() {
        if (termsController.isLoading.value) {
          return Center(child: Loading());
        }

        if (termsController.termsAndConditionsList.isEmpty) {
          return Center(child: Text("No Terms and Conditions available"));
        }

        return Padding(
          padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: termsController.termsAndConditionsList.length,
            itemBuilder: (context, index) {
              final terms = termsController.termsAndConditionsList[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${terms.title}. ",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: theme.typography.titleMedium
                        .copyWith(color: theme.primaryText, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "${terms.description}",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: theme.typography.titleMedium
                        .copyWith(color: theme.primaryText, fontSize: 14),
                  ),
                  Divider(),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
