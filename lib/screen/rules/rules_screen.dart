import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/util/app_constants.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);
return SafeArea(
  child: DefaultTabController(
    length: 3,
    child: Scaffold(
      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: theme.primary,
            indicator: BoxDecoration(
                color: theme.primary,

            ),
            unselectedLabelStyle: theme.typography.titleSmall.copyWith(
              color: theme.primary
            ),
            labelStyle: theme.typography.titleSmall.copyWith(
                color: Colors.white
            ),
            labelColor: Colors.white,
            unselectedLabelColor: theme.primary,

            tabs: [
              Tab(
                child: Container(
                  height: 30,
                  child: Center(
                    child: Text(
                      'Addis Ababa',
                      style: theme.typography.titleSmall
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  height: 30,
                  child: Center(
                    child: Text(
                      'Welo Sefer',
                      style: theme.typography.titleSmall
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  height: 30,
                  child: Center(
                    child: Text(
                      'Wengelawit',
                      style: theme.typography.titleSmall
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: AppConstants.trafficRules.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        title: Text(AppConstants.trafficRules[index]['name']),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(AppConstants.trafficRules[index]['description']),
                          )
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: AppConstants.trafficRules.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        title: Text(AppConstants.trafficRules[index]['name']),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(AppConstants.trafficRules[index]['description']),
                          )
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: AppConstants.trafficRules.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        title: Text(AppConstants.trafficRules[index]['name']),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(AppConstants.trafficRules[index]['description']),
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10,)
        ],
      ),
    ),
  ),
);

  }
}
