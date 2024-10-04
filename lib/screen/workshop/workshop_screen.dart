import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/themes/data/app_theme.dart';
import '../../controller/car_brand/car_brand_controller.dart';
import '../../generated/assets.dart';

import '../../layout/workshop/spare_part_by_id.dart';
import '../../widget/api_call_widget.dart';
import '../../widget/leading.dart';
import '../../widget/custom_divider.dart';

class WorkshopScreen extends GetView<CarBrandsController> {
  const WorkshopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    final controller = Get.put(CarBrandsController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ethio Spare",
          style: theme.typography.titleLarge.copyWith(
            color: theme.primaryText,
            fontSize: 20.0,
          ),
        ),
        leading: leadingIcon(context),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        return ApiCallWidget(
          status: controller.apiCallStatus.value,
          exception: controller.apiException.value,
          retry: () => controller.fetchCarBrands(),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemCount: controller.carBrands.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final carBrand = controller.carBrands[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => SingleSparePartScreen(
                            brandName: carBrand.name!,
                            carBrandId: carBrand.id!,
                            ownerId: carBrand.ownerId!,
                            spareParts: carBrand.spareParts!,
                            owner: carBrand.owner!));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: theme.cardBackground,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: carBrand.image!, // Image URL
                                height: 100.h,
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/images/logo.png',
                                  height: 100.h,
                                ),
                              ),
                              Text(
                                carBrand.name!,
                                style: theme.typography.titleMedium.copyWith(
                                    color: theme.primaryText,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
        );
      }),
    );
  }
}
