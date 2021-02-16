import 'package:houseinventory/model/location.dart';
import 'package:houseinventory/pages/inventory/location_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LocationCard extends StatefulWidget {

  final Location location;
  final Function(int) onLongPress;
  Function refresh;

  LocationCard({
    @required this.location,
    @required this.onLongPress,
  });

  @override
  _LocationCardState createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {

  refreshWidget() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    widget.refresh = refreshWidget;
    var boxSize = (MediaQuery.of(context).size.width * 0.9 - 32) / 2;
    return Container(
      width: boxSize,
      height: boxSize,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(boxSize)),
        splashColor: Colors.amber,
        hoverColor: Colors.yellow,
        onLongPress: () {
          widget.onLongPress(widget.location.pid);
        },
        onTap: () {
          var navigateUrl = LocationViewPage.route + '/' + widget.location.pid.toString();
          Navigator.pushNamed(context, navigateUrl);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color:Colors.white.withOpacity(0.5), width: 1),
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.blueGrey.shade300, Colors.blueGrey.shade300.withOpacity(0.7)],),
              borderRadius: BorderRadius.all(Radius.circular(boxSize))
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Flexible(
                          child: Text(
                            widget.location.name,
                            overflow: TextOverflow.fade,
                            maxLines: 3,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                      ),

                    )
                  ]),
              SizedBox(height: 4,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Flexible(
                          child: Text(
                            widget.location.itemCount.toString() + (widget.location.itemCount < 2 ? ' item' : ' items.'),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.black38, fontSize: 14),
                          )
                      ),

                    )
                  ])
            ],
          ),
        ),
      ),
    );
  }

}



