
import 'package:delivery_app/ui/custom_widgets/counter_widget.dart';
import 'package:flutter/material.dart';

class ContainerList extends StatelessWidget {
  final List<Map<String, String>> items = [
    {
      'imageUrl': 'assets/images/wings.png.png',
      'name': 'Item 1',
      'description': 'Description 1'
    },
    {
      'imageUrl': 'assets/images/wings.png.png',
      'name': 'Item 2',
      'description': 'Description 2'
    },
    {
      'imageUrl': 'assets/images/wings.png.png',
      'name': 'Item 3',
      'description': 'Description 3'
    },
    {
      'imageUrl': 'assets/images/wings.png.png',
      'name': 'Item 4',
      'description': 'Description 4'
    },
    {
      'imageUrl': 'assets/images/wings.png.png',
      'name': 'Item 5',
      'description': 'Description 5'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Number of containers
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      items[index]['imageUrl']!,
                      scale: 1.5,
                    ),
                  ),
                  // Text Section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[index]['name']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            items[index]['description']!,
                            style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rs 580.00',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              CounterWidget(), SizedBox(width: 1,),
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 8.0),
                              //   child: OutlinedButton(
                              //     onPressed: () {
                              //       // Add functionality for the + Add button
                              //       print('Add button pressed');
                              //     },
                              //     style: OutlinedButton.styleFrom(
                              //       side: BorderSide(
                              //         color: Colors.black38, // Border color
                              //         width: 1.0, // Border width
                              //       ),
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius
                              //             .all(Radius.circular(8)), // Sharp rectangular corners
                              //       ),
                              //     ),
                              //     child: Text(
                              //       '+ Add',
                              //       style: TextStyle(
                              //         color: Colors.orange,
                              //         fontSize: 14, // Text size
                              //         fontWeight: FontWeight.bold, // Bold text
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],

                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}