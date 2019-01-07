import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  final double height;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  DateTime value;

  DateTimePicker({this.height, this.width, @required this.value, this.padding, this.margin});

  @override
  DateTimePickerState createState() {
    return new DateTimePickerState();
  }
}

class DateTimePickerState extends State<DateTimePicker> {

  var txt=TextEditingController();

  @override
  Widget build(BuildContext context) {
    txt.text=widget.value.toString();

    return Container(
      padding: widget.padding??EdgeInsets.all(0),
      margin: widget.margin??EdgeInsets.all(0),
      color: Colors.white,
        height: widget.height??double.infinity,
        width: widget.width??double.infinity,
        child: InkWell(
          child: TextField(controller: txt,enabled: false,),
          onTap: () => _showDateTimePicker(context),
        ));
  }

  _showDateTimePicker(BuildContext context) {
    showDatePicker(context: context, initialDate: widget.value, firstDate: widget.value, lastDate: DateTime.now().add(Duration(days: 1000))).then(_onDateSelected);
  }

  _onDateSelected(DateTime dateTime){
    setState(() {
      widget.value=dateTime;
    });
  }
}
