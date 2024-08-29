import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/util/app_constants.dart';



class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  // List<TermsAndConditions> termsAndConditions = [];
  // bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchTermsAndConditions();
  }

  // Future<void> fetchTermsAndConditions() async {
  //   termsAndConditions = await AppDocServices().fetchTermsAndConditions();
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Terms and Conditions"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 12,right: 12),
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: AppConstants.termsAndConditions.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${AppConstants.termsAndConditions[index]['title']}. ",
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: theme.typography.titleMedium
                            .copyWith(color: theme.primaryText, fontWeight: FontWeight.bold)
                    ),
                    SizedBox(width: 5,)
                    ,Text(
                        "${AppConstants.termsAndConditions[index]['description']}",
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: theme.typography.titleMedium
                            .copyWith(color: theme.primaryText, fontSize: 14)
                    ),
                    Divider()
                  ],);
              })
        )
    );
  }
}
