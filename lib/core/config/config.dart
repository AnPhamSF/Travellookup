import 'package:google_maps_flutter/google_maps_flutter.dart';

class Config {
  final String appName = 'Travellookup';
  final String mapAPIKey = 'AIzaSyArA534clRnR6Qwg_Oamsdrbfl0VSREqQ8';
  final String countryName = 'Viet Nam';
  final String splashIcon = 'assets/images/flight.png';
  final String supportEmail = 'phamhobinhan03062003@gmail.com';
  final String privacyPolicyUrl = '';
  final String ourWebsiteUrl = 'https://www.tiktok.com/@anphamsfox';
  final String iOSAppId = '000000000';

  final String specialState1 = 'Hồ Chí Minh';
  final String specialState2 = 'Hà Nội';

  

  // your country lattidtue & logitude
  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(10.762622, 106.660172),
    zoom: 10,
  );

  
  //google maps marker icons
  final String hotelIcon = 'assets/images/hotel.png';
  final String restaurantIcon = 'assets/images/restaurant.png';
  final String hotelPinIcon = 'assets/images/hotel_pin.png';
  final String restaurantPinIcon = 'assets/images/restaurant_pin.png';
  final String drivingMarkerIcon = 'assets/images/driving_pin.png';
  final String destinationMarkerIcon = 'assets/images/destination_map_marker.png';

  
  
  //Intro images
  final String introImage1 = 'assets/images/travel6.png';
  final String introImage2 = 'assets/images/travel1.png';
  final String introImage3 = 'assets/images/travel5.png';

  
  //Language Setup

  final List<String> languages = [
    'English',
    'Vienamese'
  ];

  
  // Ads Setup
  final int userClicksAmountsToShowEachAd  = 5;

   //-- admob ads --
  final String admobAppId = 'ca-app-pub-1200000760984247~4892017374';
  final String admobInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';

  //fb ads
  final String fbInterstitalAdIDAndroid = '193186341991913_351138***********';
  //final String fbInterstitalAdIDiOS = '193186341991913_351139692863243';

  

  
}