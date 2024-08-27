import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controller/ads/ads_controller.dart';
import '../../widget/cached_image.dart';


class AdsCarousel extends StatefulWidget {
  // final List<Promotion> promotion;
  const AdsCarousel({super.key, });

  @override
  State<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<AdsCarousel> {
  bool? fetched;
  @override
  void initState() {
    //fetchImages();;
    super.initState;
  }

  // List<PhotosModel> images = [];


  List imageList = [
    {"id": 1, "image_path": 'assets/images/welcome.png'},
    {"id": 2, "image_path": 'assets/images/welcome.png'},
    {"id": 3, "image_path": 'assets/images/welcome.png'}
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AdsController adsController = Get.put(AdsController());

    final ThemeData theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: ()async{
        adsController.fetchAds();
      },
      child: Obx(() {
      if (adsController.isLoading.value) {
        return Center(child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: SizedBox(
                height: 8,
                width: 8,
                child: CircularProgressIndicator())));
      }

      return Container(
        color: theme.colorScheme.primary,
        child: Column(children: [
          Stack(
            children: [
              CarouselSlider(
                items: adsController.adsList.map((ad) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: CachedNetworkImage(
                              imageUrl: ad.image,
                              placeholder: (context, url) => Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  child: Center(child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.center,
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.primary.withOpacity(0.0),
                                  ],
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: SizedBox(),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
                carouselController: carouselController,
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: true,
                  aspectRatio: 2,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
              Positioned(
                  bottom: 10,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: adsController.adsList.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => carouselController.animateToPage(entry.key),
                              child: Container(
                                width: currentIndex == entry.key ? 17 : 7,
                                height: 7.0,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3.0,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: currentIndex == entry.key
                                        ? theme.colorScheme.surface
                                        : theme.colorScheme.primaryContainer),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ))
            ],
          )
        ]),
      );
    }),);
  }

}
