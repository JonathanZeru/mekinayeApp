import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/util/app_constants.dart';


class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  // List<PrivacyPolicy> privacyPolicies = [];
  // bool isLoading = true;


  @override
  void initState() {
    super.initState();
    // fetchPrivacyPolicies();
  }

  // Future<void> fetchPrivacyPolicies() async {
  //   privacyPolicies = await AppDocServices().fetchPrivacyPolicies();
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Privacy Policy"),
        ),
    body: Padding(
      padding: const EdgeInsets.only(top: 10, left: 12,right: 12),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: AppConstants.privacyPolicy.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${AppConstants.privacyPolicy[index]['title']}. ",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: theme.typography.titleMedium
                      .copyWith(color: theme.primaryText, fontWeight: FontWeight.bold)
                ),
                SizedBox(width: 5,)
                ,Text(
                  "${AppConstants.privacyPolicy[index]['description']}",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                    style: theme.typography.titleMedium
                        .copyWith(color: theme.primaryText, fontSize: 14)
                ),
                Divider()
              ],);
          }),
    )
    );
  }
}
