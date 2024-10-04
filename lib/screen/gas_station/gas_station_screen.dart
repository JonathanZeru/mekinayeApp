import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mekinaye/controller/gas-station/gas_station_controller.dart';
import 'package:mekinaye/layout/gas_station/gas_station_description_screen.dart';

import '../../config/themes/data/app_theme.dart';
import '../../controller/car_brand/car_brand_controller.dart';
import '../../generated/assets.dart';

import '../../layout/workshop/spare_part_by_id.dart';
import '../../widget/api_call_widget.dart';
import '../../widget/leading.dart';
import '../../widget/custom_divider.dart';

class GasStationMapScreen extends GetView<CarBrandsController> {
  const GasStationMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    final controller = Get.put(GasStationController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gas Stations",
          style: theme.typography.titleLarge.copyWith(
            color: theme.primaryText,
            fontSize: 20.0,
          ),
        ),
        leading: leadingIcon(context),
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.h),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by city, gas station names, sefers etc.',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                controller.filterGasStations(value);
              }
            )
          )
        )
      ),
      body: Obx(() {
        return ApiCallWidget(
            status: controller.apiCallStatus.value,
            exception: controller.apiException.value,
            retry: () => controller.filteredGasStations(),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: controller.filteredGasStations.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final gasStation = controller.filteredGasStations[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(()=>GasStationDetailScreen(gasStation: gasStation));
                          },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                color: theme.cardBackground,
                                borderRadius: BorderRadius.all(Radius.circular(20))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: gasStation.image!,
                                  height: 100.h,
                                  placeholder: (context, url) =>Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Image.asset(
                                    'assets/images/logo.png',
                                    height: 100.h,
                                  ),
                                ),
                                Text(
                                  gasStation.name,
                                  style: theme.typography.titleMedium.copyWith(
                                      color: theme.primaryText,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10.h,),
                                RatingBar.builder(
                                  initialRating: gasStation.overAllRating != null
                                      ? gasStation.overAllRating.round().toDouble()
                                      : 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                                  itemSize: 20.sp,
                                  ignoreGestures: true,
                                  itemBuilder: (context, _) => Icon(
                                    CupertinoIcons.star_fill,
                                    color: theme.primary,
                                  ),
                                  onRatingUpdate: (rating) {

                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                )
            )
        );
      }),
    );
  }
}
