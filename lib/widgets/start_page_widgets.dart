import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/util/Translations.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100, bottom: 60),
      child: Column(
        children: [
          Icon(Icons.home, color: Colors.amber, size: 40,),
          Text('House.Inventory'.toUpperCase(), style: TextStyle(
              fontSize: 30,
              color: Colors.amber
          ),),
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
                color: Colors.white24,
                height: 36,
                thickness: 0.7,
              )),
        ),
        Text(Translations.of(context).text("start_or"), style: TextStyle(color: Colors.white24, fontSize: 14),),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Divider(
                color: Colors.white24,
                height: 36,
                thickness: 0.7,
              )),
        ),
      ]),
    );
  }
}

class HuaweiButton extends StatelessWidget {
  final Function onPressed;

  const HuaweiButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      height: 36,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(color: Colors.red)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/hw_24x24_logo.png', width: 26, height: 26,),
            SizedBox(width: 10,),
            Text(Translations.of(context).text("start_btn_sign_huawei"), style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),),
            //SizedBox(width: 0,),
          ],
        ),
        color: Color(0xffef484b),
        onPressed: () {
          this.onPressed();
        },
      ),
    );
  }
}


