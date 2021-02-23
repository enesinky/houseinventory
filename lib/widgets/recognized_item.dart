import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houseinventory/model/recognized_object.dart';

class RecognizedItemWidget extends StatefulWidget {
  final RecognizedObject object;
  RecognizedItemWidget(this.object);

  @override
  _RecognizedItemWidgetState createState() => _RecognizedItemWidgetState();

}

class _RecognizedItemWidgetState extends State<RecognizedItemWidget> {

  @override
  Widget build(BuildContext context) {

    double possibilityAmplified = widget.object.possibility * 10;
    //double opacityFactor = (index == 0 || index == 1) ? 1.0 : possibilityAmplified.roundToDouble() / 10;
    double opacityFactor = possibilityAmplified.roundToDouble() / 10;
    Color color = Colors.blueAccent.withOpacity(opacityFactor);

    return InkWell(
      child: Container(
        child: Text(widget.object.name, style: TextStyle(
            color: widget.object.isSelected ? Colors.white : Colors.black.withOpacity(0.25),
            fontSize: 16),),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
        decoration: BoxDecoration(
            color: widget.object.isSelected ? color : Colors.black26,
            borderRadius: BorderRadius.circular(12)
        ),
      ),
      onTap: ()  {
        setState(() {
          widget.object.isSelected = !widget.object.isSelected;
        });
      },
    );
  }
}
