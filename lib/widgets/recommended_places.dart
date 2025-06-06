import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '/blocs/recommanded_places_bloc.dart';
import '/models/place.dart';
import '/pages/more_places.dart';
import '/pages/place_details.dart';
import '/core/utils/next_screen.dart';
import '/widgets/custom_cache_image.dart';
import 'package:easy_localization/easy_localization.dart';

class RecommendedPlaces extends StatelessWidget {
  RecommendedPlaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RecommandedPlacesBloc rpb =
    Provider.of<RecommandedPlacesBloc>(context);

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: 15,
            top: 10,
            right: 15,
          ),
          child: Row(
            children: <Widget>[
              Text(
                'recommended places',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800]),
              ).tr(),
              Spacer(),
              IconButton(icon: Icon(Icons.arrow_forward), onPressed: () => nextScreen(context, MorePlacesPage(
                title: 'recommended',
                color: Colors.green,)),)
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: ListView.separated(
            padding: EdgeInsets.only(top: 10, bottom: 30, left: 15, right: 15),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: rpb.data.length,
            separatorBuilder: (context, index) => SizedBox(height: 10,),
            itemBuilder: (BuildContext context, int index) {
              if (rpb.data.isEmpty) return Container();
              return _ListItem(d: rpb.data[index]);
            },
          ),
        )
      ],
    );
  }
}





class _ListItem extends StatelessWidget {
  final Place d;
  const _ListItem({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: <Widget>[
          Hero(
            tag: 'recommended${d.timestamp}',
            child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CustomCacheImage(imageUrl: d.imageUrl1))),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(top: 10, right: 15),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Colors.grey[600],
                ),
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  d.loves.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                onPressed: () {},
              ),
            ),
          ),



          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              height: 90,
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    d.name,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.location_city_rounded,
                          size: 15, color: Colors.grey[400]),
                      Expanded(
                        child: Text(
                          d.location,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

        ],
      ),
      onTap: ()=> nextScreen(context, PlaceDetails(data: d, tag: 'recommended${d.timestamp}')),
    );
  }
}
