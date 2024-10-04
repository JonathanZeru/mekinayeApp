import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mekinaye/controller/gas-station/gas_station_controller.dart';
import 'package:mekinaye/model/gas_station.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/config_preference.dart';
import '../../config/themes/data/app_theme.dart';
import '../../screen/auth/login_screen.dart';
import '../../service/api_service.dart';
import '../../service/authorization_service.dart';
import '../../util/api_call_status.dart';
import '../../util/app_constants.dart';
import '../../util/date.dart';
import '../../util/validator.dart';
import '../../widget/custom_input_field.dart';
import '../../widget/loading.dart';


class GasStationDetailScreen extends StatefulWidget {
  final GasStation gasStation;

  GasStationDetailScreen({required this.gasStation, Key? key}) : super(key: key);

  @override
  State<GasStationDetailScreen> createState() => _GasStationDetailScreenState();
}

class _GasStationDetailScreenState extends State<GasStationDetailScreen> {
  int ratingController = 3;
  // AIzaSyCcgUJR0ydF-EoRepY5XODc6diNqI4MHgc
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  bool isLoading = true;

  bool isLoggedIn = false;

  late Map<String, dynamic> user;

  Future<void> checkLogin() async {
    setState(() {
      isLoading = true;
    });
    isLoggedIn = await AuthService.isUserLoggedIn();
    if (isLoggedIn) {
      final userProfile = ConfigPreference.getUserProfile();
      setState(() {
        user = userProfile;
      });
      print(user['id']);
    } else {
      user = {"login": "Please Login or Sign up"};
    }
    setState(() {
      isLoading = false;
    });
  }

  final controller = Get.put(GasStationController());

  // Parse the latitude and longitude from the map URL
  late GoogleMapController mapController;

  // Parse the latitude and longitude from the map URL
  LatLng getLatLngFromUrl(String mapUrl) {
    return LatLng(double.parse(widget.gasStation.latitude),
        double.parse(widget.gasStation.longitude));
  }
  // Function to open Google Maps app with the location
  // Function to open Google Maps app with the location
  Future<void> _launchMapsUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    LatLng gasStationLatLng = getLatLngFromUrl(widget.gasStation.mapUrl);
    AppTheme theme = AppTheme.of(
        context); // Use your app theme for consistent styling

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gasStation.name,
          style: theme.typography.titleLarge.copyWith(color: theme.primaryText),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Garage Image
              Center(
                child: CachedNetworkImage(
                  imageUrl: widget.gasStation.image ??
                      'assets/images/default_garage.png',
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      SizedBox(height: 50, width: 50, child: Loading()),
                  errorWidget: (context, url, error) =>
                      Image.asset(
                        'assets/images/logo.png',
                        height: 200.h,
                        fit: BoxFit.cover,
                      ),
                ),
              ),
              SizedBox(height: 16.h),
              // Garage Details
              Text(
                "Garage Information",
                style: theme.typography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              buildDetailItem("Description", widget.gasStation.description),

              RatingBar.builder(
                initialRating: widget.gasStation.overAllRating != null
                    ? widget.gasStation.overAllRating.round().toDouble()
                    : 3,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                itemSize: 15.sp,
                ignoreGestures: true,
                itemBuilder: (context, _) =>
                    Icon(
                      CupertinoIcons.star_fill,
                      color: theme.primary,
                    ),
                onRatingUpdate: (rating) {

                },
              ),
              GestureDetector(
                onTap: () {
                  print(widget.gasStation
                      .mapUrl);
                  _launchMapsUrl(widget.gasStation
                      .mapUrl); // Launch Google Maps with the URL
                },
                child: Column(
                  children: [
                    buildDetailItem("Location",
                        "${widget.gasStation.city}, ${widget.gasStation
                            .subCity}, Wereda ${widget.gasStation
                            .wereda}, Kebele ${widget.gasStation.kebele}"),
                    Row(
                      children: [
                        Text('Directions on google map'),
                        Icon(Icons.map,color: theme.primary,size: 30.sp)
                      ]
                    )
                  ],
                )
              ), GestureDetector(
                onTap: () {
                  _launchMapsUrl(widget.gasStation.mapUrl); // Launch Google Maps with the URL
                },
                child: Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: GoogleMap(
                    buildingsEnabled: true,
                    compassEnabled: true,
                    mapToolbarEnabled: true,
                    myLocationEnabled: true,
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    trafficEnabled: true,
                    tiltGesturesEnabled: true,
                    indoorViewEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: gasStationLatLng, // Coordinates from the parsed URL
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('gas_station'),
                        position: gasStationLatLng,
                        infoWindow: InfoWindow(title: widget.gasStation.name),
                      ),
                    },
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    onTap: (_) {
                      // _launchMapsUrl(widget.gasStation.mapUrl);
                    },
                  ),
                ),
              ),
              // Emails
              SizedBox(height: 20.h),
              Text(
                "Contact Information",
                style: theme.typography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              buildEmailsSection(widget.gasStation.emails, theme),
              buildPhonesSection(widget.gasStation.phones, theme),

              // Ratings and Comments
              SizedBox(height: 24.h),
              buildRatingsSection(widget.gasStation.ratings, theme),

              // Add Rating and Comment Section
              SizedBox(height: 32.h),
              Text(
                "Leave a Review",
                style: theme.typography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              _buildRatingBar(),
              SizedBox(height: 20.h),
              _buildCommentForm(theme),
              SizedBox(height: 20.h),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build detail item
  Widget buildDetailItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmailsSection(List<Email> emails, AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: emails.map((email) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Text(
            email.emailAddress,
            style: theme.typography.bodyMedium,
          ),
        );
      }).toList(),
    );
  }

  Widget buildPhonesSection(List<Phone> phones, AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: phones.map((phone) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Text(
                phone.phoneNumber,
                style: theme.typography.bodyMedium,
              ),
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Colors.transparent),
                    elevation: MaterialStatePropertyAll(0),
                    side: MaterialStatePropertyAll(BorderSide.none)
                ),
                onPressed: () {
                  _handleTelUrl(phone.phoneNumber);
                }, child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Call ${widget.gasStation.name}",
                    style: theme.typography.titleSmall.copyWith(
                        fontSize: 15
                    )),
                SizedBox(width: 10.w,),
                Icon(
                  CupertinoIcons.phone_solid,
                  color: theme.primary,
                  size: 20.sp,
                )

              ],
            )),

          ],
        );
      }).toList(),
    );
  }

  void _handleTelUrl(String url) async {
    print(url);
    await launchUrl(Uri.parse(url));
  }

  // Ratings Section
  Widget buildRatingsSection(List<Rating> ratings, AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "User Reviews",
          style: theme.typography.titleLarge.copyWith(
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        ...ratings.map((rating) => buildRatingItem(rating, theme)).toList(),
      ],
    );
  }

  // Build individual rating item
  Widget buildRatingItem(Rating rating, AppTheme theme) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rating.commentTitle,
                style: theme.typography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold),
              ),
              RatingBar.builder(
                initialRating: rating.stars.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                itemSize: 15.sp,
                ignoreGestures: true,
                itemBuilder: (context, _) =>
                    Icon(CupertinoIcons.star_fill, color: theme.primary),
                onRatingUpdate: (ratingValue) {},
              )
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            duTimeLineFormat(rating.createdAt!),
            style: TextStyle(color: Colors.black, fontSize: 10),
          ),
          SizedBox(height: 5.h),
          Text(
            rating.commentDescription,
            style: theme.typography.bodyMedium,
          ),
          SizedBox(height: 5.h),
          Text(
            "- ${rating.user.firstName} ${rating.user.lastName}",
            style: theme.typography.bodySmall.copyWith(color: Colors.grey),
          ),
          isLoading
              ? Center(child: Loading()) :
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if(isLoggedIn)
                if(rating.user.id == user['id'])
                  TextButton(
                    onPressed: () {
                      print("delete");
                      controller.deleteRating(
                          ratingId: rating.id
                      );
                      if (controller.apiCallStatus.value ==
                          ApiCallStatus.success) {
                        setState(() {
                          widget.gasStation.ratings.remove(rating);
                        });
                      }
                    },
                    child: Text('Delete',
                        style: theme.typography.titleSmall.copyWith(
                            color: Colors.red)),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.transparent,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        textStyle: TextStyle(color: Colors.red),
                        side: BorderSide.none
                    ),
                  ),
              SizedBox(width: 10.w),
              if(isLoggedIn)
                if(rating.user.id == user['id'])
                  TextButton(
                    onPressed: () {
                      final commentTitle = TextEditingController();
                      final commentDescription = TextEditingController();
                      int ratingController = rating.stars;
                      commentTitle.text = rating.commentTitle;
                      commentDescription.text = rating.commentDescription;
                      Get.defaultDialog(
                          title: 'Update Review',
                          content: Form(
                            key: controller.formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RatingBar.builder(
                                      initialRating: rating.stars.toDouble(),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      itemSize: 25.sp,
                                      itemBuilder: (context, _) =>
                                          Icon(CupertinoIcons.star_fill,
                                              color: theme.primary),
                                      onRatingUpdate: (ratingValue) {
                                        ratingController = ratingValue.toInt();
                                      }
                                  ),
                                  Text("Comment Title"),
                                  SizedBox(height: 5.h,),
                                  CustomInputField(
                                    label: "Comment Title",
                                    textEditingController: commentTitle,
                                    hint: "Comment Title",
                                    obscureText: false,
                                    type: TextInputType.text,
                                    isDense: true,
                                    prefixIcon: Icon(
                                      Icons.title,
                                      size: 20.sp,
                                      color: theme.primaryText.withOpacity(
                                          0.50),
                                    ),
                                    validator: (value) =>
                                        Validator.validateWord(value),
                                  ),
                                  Text("Comment Description"),
                                  SizedBox(height: 5.h,),
                                  CustomInputField(
                                    maxLines: 20,
                                    label: "Comment Description",
                                    textEditingController: commentDescription,
                                    hint: "Comment Description",
                                    obscureText: false,
                                    type: TextInputType.text,
                                    isDense: true,
                                    prefixIcon: Icon(
                                      Icons.comment,
                                      size: 20.sp,
                                      color: theme.primaryText.withOpacity(
                                          0.50),
                                    ),
                                    validator: (value) =>
                                        Validator.validateWord(value),
                                  ), ElevatedButton(
                                    onPressed: () async {
                                      print("pressed");
                                      print(controller.formKey.currentState
                                          ?.validate());
                                      if (controller.formKey.currentState
                                          ?.validate() ??
                                          false) {
                                        controller.updateRating(
                                            ratingId: rating.id,
                                            title: commentTitle.text,
                                            description: commentDescription
                                                .text,
                                            rating: ratingController
                                        );
                                        if (controller.apiCallStatus.value ==
                                            ApiCallStatus.success) {
                                          setState(() {
                                            rating.commentTitle =
                                                commentTitle.text;
                                            rating.commentDescription =
                                                commentDescription.text;
                                            rating.stars = ratingController;
                                          });
                                        }
                                        controller.isUpdatingLoading.value ==
                                            false;
                                        Get.back();
                                      }
                                    },
                                    child:
                                    controller.isUpdatingLoading.value == true ?
                                    CircularProgressIndicator() : Text(
                                        'Update Review'),
                                  )
                                ],
                              ),
                            ),
                          )
                      );
                    },
                    child:
                    controller.isUpdatingLoading.value == true ?
                    CircularProgressIndicator() : Text('Update',
                        style: theme.typography.titleSmall.copyWith(
                            color: Colors.white)),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.transparent,
                        elevation: 0,
                        backgroundColor: theme.primary,
                        side: BorderSide.none
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar() {
    return RatingBar.builder(
      initialRating: controller.ratingController.value.toDouble(),
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemSize: 30.sp,
      itemBuilder: (context, _) =>
          Icon(
            CupertinoIcons.star_fill,
            color: Colors.amber,
          ),
      onRatingUpdate: (rating) {
        controller.ratingController.value = rating.toInt();
      },
    );
  }

  // Form for adding comment
  Widget _buildCommentForm(AppTheme theme) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Comment Title"),
          SizedBox(height: 5.h,),
          CustomInputField(
            label: "Comment Title",
            textEditingController: controller.commentTitle,
            hint: "Comment Title",
            obscureText: false,
            type: TextInputType.text,
            isDense: true,
            prefixIcon: Icon(
              Icons.title,
              size: 20.sp,
              color: theme.primaryText.withOpacity(0.50),
            ),
            validator: (value) => Validator.validateWord(value),
          ),
          Text("Comment Description"),
          SizedBox(height: 5.h,),
          CustomInputField(
            maxLines: 20,
            label: "Comment Description",
            textEditingController: controller.commentDescription,
            hint: "Comment Description",
            obscureText: false,
            type: TextInputType.text,
            isDense: true,
            prefixIcon: Icon(
              Icons.comment,
              size: 20.sp,
              color: theme.primaryText.withOpacity(0.50),
            ),
            validator: (value) => Validator.validateWord(value),
          )
        ],
      ),
    );
  }

  _buildSubmitButton(BuildContext context) {
    return isLoading
        ? Center(child: Loading())
        : isLoggedIn
        ? Center(
      child: Obx(() {
        return ElevatedButton(
          onPressed: () async {
            if (controller.formKey.currentState?.validate() ?? false) {
              controller.formKey.currentState?.save();
              controller.isCreatingLoading.value = true;
              String accessToken = await ConfigPreference.getAccessToken() ??
                  '';

              final body = {
                "stars": controller.ratingController.value,
                "commentTitle": controller.commentTitle.text,
                "commentDescription": controller.commentDescription.text,
                "gasStationId": widget.gasStation.id,
              };

              controller.apiCallStatus.value = ApiCallStatus.loading;

              ApiService.safeApiCall(
                "${AppConstants.url}/gas-station/rating",
                headers: {
                  'Authorization': 'Bearer $accessToken',
                },
                RequestType.post,
                data: body,
                onSuccess: (response) {
                  controller.isCreatingLoading.value = false;
                  controller.apiCallStatus.value = ApiCallStatus.success;
                  Get.snackbar("Success", "Review submitted successfully");

                  // Clear form fields after successful submission
                  controller.commentTitle.text = "";
                  controller.commentDescription.text = "";
                  controller.ratingController.value = 3;

                  // Add new rating to list
                  Map<String, dynamic> rating = response.data['data'];
                  rating.addAll({"user": user});
                  Rating _newRating = Rating.fromJson(rating);
                  setState(() {
                    widget.gasStation.ratings.add(_newRating);
                  });

                  controller.fetchGasStations();
                },
                onError: (error) {
                  controller.isCreatingLoading.value = false;
                  controller.apiCallStatus.value = ApiCallStatus.error;
                  Get.snackbar(
                      "Error", "Failed to submit review: ${error.message}");
                },
              );
            }
          },
          child: controller.isCreatingLoading.value
              ? CircularProgressIndicator()
              : Text('Submit Review'),
        );
      }),
    )
        : ElevatedButton(
      onPressed: () {
        Get.snackbar("Error", "Login to add review!");
        Get.to(() => LoginScreen());
      },
      child: Text('Login'),
    );
  }
}