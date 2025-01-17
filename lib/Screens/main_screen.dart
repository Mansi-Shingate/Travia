// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/accessories/circular_background.dart';
import 'package:final_project/accessories/list_card.dart';
import 'package:final_project/accessories/logout_button.dart';
import 'package:final_project/accessories/text_field.dart';
import 'package:final_project/constants.dart';
import 'package:final_project/networking/firestore_getinfo.dart';
import 'package:final_project/reusablewidgets/custom_navbar.dart';
import 'package:final_project/reusablewidgets/tab_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class MainScreen extends StatefulWidget {
  static String id = 'mainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    FirestorInfo.dataStream();
  }

  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height / 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: CircleBackground(
                        onPressed: () {
                        },
                        widget: Icon(
                          Icons.person,
                          color: Color(0xFFCE6730),
                        ),
                        height1: 50,
                        height2: 40,
                        width1: 50,
                        width2: 40,
                      ),
                    ),
                    SizedBox(
                      width: size.width / 20,
                    ),
                    Text(
                      "Hello, There!",
                      style: kMainScreenText,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: LogOutBackground(
                    auth: _auth,
                    widget: Icon(
                      Icons.settings_outlined,
                      color: Color(0xFFCE6730),
                    ),
                    height1: 50,
                    height2: 40,
                    width1: 50,
                    width2: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: RichText(
                  text: TextSpan(
                    text: "What's next \non your",
                    style: kMainScreenDarkText,
                    children: const <TextSpan>[
                      TextSpan(
                          text: " wishlist",
                          style: TextStyle(color: Color(0xFFCE6730))),
                      TextSpan(
                        text: " ?",
                      ),
                    ],
                  ),
                )),
            const SizedBox(
              height: 30,
            ),
            Center(child: MyTextField()),
            const SizedBox(
              height: 8,
            ),
            RowTabWidget(),
            SizedBox(
              height: size.height / 50,
            ),
            MyListView(size: size),
            Flexible(child: CustomNavBar())
          ],
        ),
      ),
    );
  }
}

class MyListView extends StatelessWidget {
  const MyListView({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: size.height / 3 + 50,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirestorInfo.firestore.collection('Destination').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              );
            } else {
              return ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListCard(
                    imageUrl: data['imageUrl'].toString(),
                    title: data['title'].toString(),
                    subtitle: data['subTitle'].toString(),
                    about: data['about'].toString(),
                    rating: data['rating'].toString(),
                    latitude: data['latitude'],
                    longitude: data['longitude'],
                  );
                }).toList(),
              );
            }
          }),
    );
  }
}


