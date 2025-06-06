import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '/models/place.dart';
import '/pages/comments.dart';
import '/pages/guide.dart';
//import '/pages/hotel.dart';
//import '/pages/restaurant.dart';
import '/core/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class TodoWidget extends StatelessWidget {
  final Place placeData;
  const TodoWidget({Key? key, required this.placeData}) : super(key: key);
  void openGoogleMaps({required Place placeData, required String placeType}) async {
    String query;

    switch (placeType) {
      case 'restaurant':
        query = 'Restaurants near';
        break;
      case 'hotel':
        query = 'Hotels near';
        break;
      case 'transport':
        query = 'nearby transport';
        break;
      default:
        query = '';
        break;
    }

    final String googleMapsUrl =
      'https://www.google.com/maps/search/$query+${placeData.name}/';
    if (await canLaunchUrlString(googleMapsUrl)) {
      await launchUrlString(googleMapsUrl);
    } else {
      // Use a logging framework instead of invoking 'print' in production code
      debugPrint('Could not launch $googleMapsUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('todo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            )).tr(),
        Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          height: 3,
          width: 50,

          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(40)),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: GridView.count(
            padding: EdgeInsets.all(0),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              InkWell(
                child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.blue,
                                      offset: Offset(5, 5),
                                      blurRadius: 2)
                                ]),
                            child: Icon(
                              LineIcons.arrowLeft,
                              size: 30,
                            ),
                          ),

                          Text(
                            'Directions',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ).tr(),

                        ])),
                onTap: () async {
                  nextScreen(context, GuidePage(d: placeData));
                  final String googleMapsUrl =
                    'https://www.google.com/maps/dir//${placeData.name}/';
                  if(await canLaunchUrlString(googleMapsUrl)){
                    await launchUrlString(googleMapsUrl);
                  }
                },
              ),
              InkWell(
                child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.orangeAccent,
                                      offset: Offset(5, 5),
                                      blurRadius: 2)
                                ]),
                            child: Icon(
                              LineIcons.hotel,
                              size: 30,
                            ),
                          ),
                          Text(
                            'nearby hotels',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ).tr(),
                        ])),
                onTap: () {
                   //nextScreen(context, HotelPage(placeData: placeData,))
                   openGoogleMaps(placeData: placeData, placeType: 'hotel');
                },
              ),
              InkWell(
                child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.pinkAccent,
                                      offset: Offset(5, 5),
                                      blurRadius: 2)
                                ]),
                            child: Icon(
                              Icons.restaurant_menu,
                              size: 30,
                            ),
                          ),
                          Text(
                            'nearby restaurants',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ).tr(),

                        ])),
                onTap: () {
                  //nextScreen(context, RestaurantPage(placeData: placeData,))
                  openGoogleMaps(placeData: placeData, placeType: 'restaurant');
                },
              ),
              InkWell(
                child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.indigoAccent,
                                      offset: Offset(5, 5),
                                      blurRadius: 2)
                                ]),
                            child: Icon(
                              LineIcons.comments,
                              size: 30,
                            ),
                          ),
                          Text(
                            'user reviews',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ).tr(),
                        ])),
                onTap: () {
                  nextScreen(context, CommentsPage(collectionName: 'places', timestamp: placeData.timestamp,));
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
