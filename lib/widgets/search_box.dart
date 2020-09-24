import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.white10,
              style: BorderStyle.solid,
              width: 1),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: MediaQuery.of(context).size.width - 140,
              child: TextField(
                maxLines: 1,
                textAlignVertical: TextAlignVertical.bottom,
                textAlign: TextAlign.start,
                autofocus: false,
                cursorColor: Colors.blue,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16
                ),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search Item",
                  enabled: true,
                  icon: Icon(Icons.view_module,
                      size: 25, color: Colors.black87),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: 0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: 0),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: 0),
                  ),
                ),
              )),
          GestureDetector(
              onTap: () => print('Tapped Search Button'),
              child:
              Container(
                child: Icon(Icons.search, size: 30, color: Colors.black87),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.white70, Color(0xffA8BCBD)]),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              )),
        ],
      ),
    );
  }
}
