import 'package:google_maps_flutter/google_maps_flutter.dart';

class Config {
  final String appName = 'Travellookup';
  final String mapAPIKey = '';
  final String countryName = 'Viet Nam';
  final String splashIcon = 'assets/images/flight.png';
  final String supportEmail = 'phamhobinhan03062003@gmail.com';
  final String privacyPolicyUrl = 'https://www.freeprivacypolicy.com/pri************';
  final String ourWebsiteUrl = 'https://Travellookup.com';
  final String iOSAppId = '000000000';

  final String specialState1 = 'Hồ Chí Minh';
  final String specialState2 = 'Hà Nội';

  

  // your country lattidtue & logitude
  final CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(23.777176,90.399452),
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
  final String admobAppId = 'ca-app-pub-3940256099942544~3347511713';
  final String admobInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';

  //fb ads
  final String fbInterstitalAdIDAndroid = '193186341991913_351138***********';
  //final String fbInterstitalAdIDiOS = '193186341991913_351139692863243';

  

  
}