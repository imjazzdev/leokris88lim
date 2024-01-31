import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/utils.dart';
import 'widget/carousel_banner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(flex: 2, child: CarouselBanner()),
          SizedBox(
            height: 50,
          ),
          Expanded(
              flex: 4,
              child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('LINK').snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.data!.docs.length == 0 ||
                            snapshot.data!.docs == null
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            children: snapshot.data!.docs
                                .map((e) => InkWell(
                                      onTap: () {
                                        try {
                                          launchUrl(Uri.parse(e['url']));
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text('Link sedang bermasalah'),
                                            backgroundColor:
                                                Colors.orange.shade400,
                                          ));
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsetsDirectional.symmetric(
                                            vertical: 25, horizontal: 30),
                                        height: 49,
                                        width: 500,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.asset(
                                              Utils.img[int.parse(e['id'])],
                                            )),
                                        decoration: BoxDecoration(
                                          // color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          );
                  })),
        ],
      )),
    );
  }
}
