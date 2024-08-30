import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/util/app_constants.dart';

import '../../controller/rules/rule_controller.dart';
import '../../layout/error/error_screen.dart';
import '../../model/rules.dart';
import '../../widget/loading.dart';

class RulesScreen extends StatefulWidget {
  final bool isFromHome;
  const RulesScreen({super.key, required this.isFromHome});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final RulesController rulesController = Get.put(RulesController());

  Future<void> _refreshData() async {
    await rulesController.fetchRules();
  }
  bool hasConnection = true;
  bool checkingConnection = true;


  @override
  void initState() {
    checkConnection();
  }
  Future<void> checkConnection() async {
    setState(() {
      checkingConnection = true;
    });
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      _refreshData();
      setState(() {
        hasConnection = true;
        checkingConnection = false;
      });
    } else {
      setState(() {
        hasConnection = false;
        checkingConnection = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);
    if(checkingConnection == true){
      return SafeArea(
        child: Scaffold(
          body: Center(
              child: Loading()
          ),
        ),
      );
    }
    if (hasConnection == false) {
      return ErrorScreen(onPress: checkConnection);
    }
    return SafeArea(
      child: Obx(() {
        if (rulesController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Group rules by cityName
        final rulesByCity = <String, List<Rules>>{};
        for (var rule in rulesController.faqList) {
          String cityName = rule.cityName;
          if (rulesByCity.containsKey(cityName)) {
            rulesByCity[cityName]!.add(rule);
          } else {
            rulesByCity[cityName] = [rule];
          }
        }

        final cities = rulesByCity.keys.toList();

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: DefaultTabController(
            length: cities.length,
            child: Scaffold(
              appBar: widget.isFromHome
                  ? AppBar(
                title: Text("Rules"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
                  : AppBar(title: Text("Rules")),
              body: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    indicatorColor: theme.primary,
                    indicator: BoxDecoration(
                      color: theme.primary,
                    ),
                    unselectedLabelStyle:
                    theme.typography.titleSmall.copyWith(color: theme.primary),
                    labelStyle:
                    theme.typography.titleSmall.copyWith(color: Colors.white),
                    labelColor: Colors.white,
                    unselectedLabelColor: theme.primary,
                    tabs: cities
                        .map(
                          (city) => Tab(
                        child: Container(
                          height: 30,
                          child: Center(
                            child: Text(city, style: theme.typography.titleSmall),
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: cities.map((city) {
                        final rules = rulesByCity[city]!;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 24.h),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: rules.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Sub City: ${rules[index].subCityName}'),
                                    Text('Country: ${rules[index].countryName}'),
                                    Text('Description: ${rules[index].description}'),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
