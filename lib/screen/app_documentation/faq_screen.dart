import 'package:flutter/material.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';

import '../../util/app_constants.dart';


class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  // List<FAQ> faqs = [];
  // bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // fetchFaqs();
  }

  // Future<void> fetchFaqs() async {
  //   faqs = await AppDocServices().fetchFaqs();
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ"),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: AppConstants.faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(AppConstants.faqs[index]['title'],
                style: theme.typography.titleMedium
                .copyWith(color: theme.primaryText, fontWeight: FontWeight.bold)),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(AppConstants.faqs[index]['description'],
                    style: theme.typography.titleMedium
                        .copyWith(color: theme.primaryText, fontSize: 14)),
              )
            ],
          );
        },
      ),
    );
  }
}
