import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/util/dateTimeUtil.dart';

class DateTimePicker extends StatefulWidget {
  final double height;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool timeEnabled;
  final ValueChanged<DateTime> onValueChanged;
  DateTime value;

  DateTimePicker({this.height, this.width, @required this.value, this.padding, this.margin, this.timeEnabled, this.onValueChanged});

  @override
  DateTimePickerState createState() {
    return new DateTimePickerState();
  }
}

class DateTimePickerState extends State<DateTimePicker> {
  var txt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    txt.text =DateTimeUtil.format(widget.value);

    return Container(
        padding: widget.padding ?? EdgeInsets.all(5),
        margin: widget.margin ?? EdgeInsets.all(0),
        color: Colors.white,
        height: widget.height,
        width: widget.width ?? double.infinity,
        child: InkWell(
          child: TextField(

            controller: txt,
            enabled: false,
          ),
          onTap: () => _showDateTimePicker(context),
        ));
  }

  _showDateTimePicker(BuildContext context) {
    showDatePicker(context: context, initialDate: widget.value, firstDate: widget.value, lastDate: DateTime.now().add(Duration(days: 1000))).then((d) => _onDateSelected(d, context));
  }

  _onDateSelected(DateTime dateTime, BuildContext context) {
    if (dateTime == null) {
      return;
    }
    if (widget.timeEnabled ?? true) {
      showTimePicker(context: context, initialTime: TimeOfDay(hour: 0, minute: 0)).then(_onTimeSelected);
    }else{
      setState(() {
        widget.value = dateTime;
      });
      notifyOnValueChanged();
    }


  }

  void notifyOnValueChanged() {
    if (widget.onValueChanged != null) {
      widget.onValueChanged(widget.value);
    }
  }

  _onTimeSelected(TimeOfDay time) {
    if (time == null) {
      return;
    }
    setState(() {
      widget.value = DateTime(widget.value.year, widget.value.month, widget.value.day, time.hour, time.minute);
    });
    notifyOnValueChanged();
  }
}
