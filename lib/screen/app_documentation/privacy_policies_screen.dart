import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:get/get.dart';
import '../../controller/docs/privacy_policy_controller.dart';
import '../../widget/loading.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final PrivacyPolicyController _controller =
      Get.put(PrivacyPolicyController());

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: Loading());
        }

        return Padding(
          padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _controller.privacyPolicies.length,
            itemBuilder: (context, index) {
              final policy = _controller.privacyPolicies[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${policy.title}",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: theme.typography.titleMedium.copyWith(
                        color: theme.primaryText, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "${policy.description}",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: theme.typography.titleMedium
                        .copyWith(color: theme.primaryText, fontSize: 14),
                  ),
                  if (policy.sections != [])
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: policy.sections.length,
                        itemBuilder: (context, index2) {
                          final section = policy.sections[index2];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${section.title}",
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: theme.typography.titleMedium.copyWith(
                                    color: theme.primaryText,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "${section.description}",
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: theme.typography.titleMedium.copyWith(
                                    color: theme.primaryText, fontSize: 14),
                              )
                            ],
                          );
                        }),
                  Divider()
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
