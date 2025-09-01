import 'package:delivery_app/core/constant/color.dart';
import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final int? count;
  final onChanged;
  CounterWidget({this.count, this.onChanged});
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 1; // Initial count

  // Method to increment the count
  void increment() {
    setState(() {
      count++;
    });
    widget.onChanged(count);
  }

  // Method to decrement the count
  void decrement() {
    setState(() {
      if (count > 0) {
        // Ensure the count doesn't go below 0
        count--;
      }
    });
    widget.onChanged(count);
  }

  @override
  Widget build(BuildContext context) {
    count = widget.count ?? 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Subtraction Button
        SizedBox(
          width: 25,
          height: 25,
          child: OutlinedButton(
            onPressed: decrement,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero, // Remove default padding
              side: BorderSide(
                color: primaryColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(4), // Optional: rounded edges
              ),
            ),
            child: Icon(
              Icons.remove, // Subtraction icon
              color: primaryColor,
              size: 20, // Icon size
              weight: 3,
            ),
          ),
        ),
        SizedBox(width: 10), // Space between buttons and text
        // Display Count
        Text(
          count.toString(),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10), // Space between text and addition button
        // Addition Button
        SizedBox(
          width: 25,
          height: 25,
          child: OutlinedButton(
            onPressed: increment,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero, // Remove default padding
              side: BorderSide(
                color: primaryColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(4), // Optional: rounded edges
              ),
            ),
            child: Icon(
              Icons.add, // Addition icon
              color: primaryColor,
              size: 16, // Icon size
            ),
          ),
        ),
      ],
    );
  }
}
