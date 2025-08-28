import 'package:flutter/material.dart';

import '../../../core/constant/color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor, // Footer background color
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Section: Logo, Subscribe, Social Media
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/Frame 1261155164.png', // Replace with your logo URL
                    height: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  // Newsletter subscription
                  Text(
                    'Subscribe to our newsletter to get latest updates',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      // Email input
                      Container(
                        width: 200,
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Your email address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Subscribe button
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text('Subscribe'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Social media icons
                  Row(
                    children: [
                      Icon(Icons.facebook, color: Colors.white),
                      SizedBox(width: 10),
                      // Icon(Icons.instagram, color: Colors.white),
                      // SizedBox(width: 10),
                      FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
                      SizedBox(width: 10),
                      FaIcon(FontAwesomeIcons.youtube, color: Colors.white),
                    ],
                  ),
                ],
              ),

              // Middle Section: Useful Links
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Useful Links',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Cookies Policy', style: TextStyle(color: Colors.white)),
                  Text('About Us', style: TextStyle(color: Colors.white)),
                  Text('Contact Us', style: TextStyle(color: Colors.white)),
                ],
              ),

              // Right Section: Contact Info and App Download
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Download Buttons
                  Text(
                    'Download Our Apps',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/download (1).png', // Google Play Store Badge
                        height: 40,
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        'assets/images/playbtn.png', // App Store Badge
                        height: 40,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Contact Info
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.white),
                      SizedBox(width: 10),
                      Text('info@inilabs.net',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.white),
                      SizedBox(width: 10),
                      Text('+13333846282',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(color: Colors.white54),
          SizedBox(height: 10),
          Center(
            child: Text(
              '© kabir by IniLabs 2024, All Rights Reserved',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
