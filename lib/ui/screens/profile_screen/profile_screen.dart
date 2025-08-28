import 'package:delivery_app/ui/screens/order_screen/orderScreen_desktop.dart';
import 'package:delivery_app/ui/screens/order_screen/orderScreen_mobile.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/ui/screens/address_screen/address_desktop.dart';
import 'package:delivery_app/ui/screens/favorite_screen/favorite_screen_mobile.dart';

class ProfileScreen extends StatelessWidget {
  final Function? toggleProfile;

  const ProfileScreen({Key? key, this.toggleProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double profileWidth = MediaQuery.of(context).size.width * 0.30;

    return Positioned(
      top: 0,
      right: 0,
      bottom: 0,
      width: profileWidth,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text('Profile'),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    if (toggleProfile != null) {
                      toggleProfile!();
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              size: 66,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 11),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const[
                              Text(
                                "Ali Khan",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "+92 3190347308",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      ListTile(
                        leading: Icon(
                          Icons.notification_important_outlined,
                          size: 33,
                        ),
                        title: Text(
                          'Orders',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderScreenDesktop(),
                            ),
                          );
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.home,
                          size: 33,
                        ),
                        title: Text(
                          'Addresses',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddressScreenDesktop(),
                            ),
                          );
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.favorite_border,
                          size: 33,
                        ),
                        title: Text(
                          'Favorite',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoriteScreenMobile(),
                            ),
                          );
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          size: 33,
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {},
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.person_outline,
                          size: 33,
                          color: Colors.red,
                        ),
                        title: Text(
                          'Request Account Deletion',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
