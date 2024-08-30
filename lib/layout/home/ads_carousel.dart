import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/ads/ads_controller.dart';
import '../../controller/connection/internet_connection_controller.dart';
import '../../widget/loading.dart';
import '../error/error_screen.dart';

class AdsCarousel extends StatefulWidget {
  const AdsCarousel({super.key});

  @override
  State<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<AdsCarousel> {
  bool? fetched;

  @override
  void initState() {
    super.initState();
  }

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AdsController adsController = Get.put(AdsController());
    final ThemeData theme = Theme.of(context);

    final internetController = Get.put(InternetController());
    return RefreshIndicator(
      onRefresh: () async {
        adsController.fetchAds();
      },
      child: Obx(() {
        if (internetController.hasConnection.value == false &&
            internetController.checkingConnection.value == false) {
          return ErrorScreen(onPress: internetController.checkingConnection);
        }
        if (adsController.isLoading.value) {
          return Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: Loading(),
            ),
          );
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
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Loading(),
                                  ),
                                ),
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
                                      : theme.colorScheme.primaryContainer,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ]),
        );
      }),
    );
  }
}
