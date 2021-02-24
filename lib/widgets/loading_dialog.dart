import 'package:flutter/material.dart';
import 'package:houseinventory/util/Translations.dart';

class CustomLoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Center(
        heightFactor: 1.6,
        widthFactor: 1,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            SizedBox(height: 24,),
            new Text(Translations.of(context).text("loading"), style: TextStyle(
                color: Colors.black54,
                fontSize: 15
            ),),
          ],
        ),
      ),
    );
  }
}
