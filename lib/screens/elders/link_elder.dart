import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderlycompanion/models/elder.dart';
import 'package:elderlycompanion/models/user.dart';
import 'package:elderlycompanion/widgets/app_default.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinkElder extends StatefulWidget {
  @override
  _LinkElderState createState() => _LinkElderState();
}

class _LinkElderState extends State<LinkElder> {
  Relative relative;
  String userID;
  Elder elder;
  TextEditingController controller;
  getCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        userID = user.uid;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    relative = Relative();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElderlyAppBar(),
      drawer: AppDrawer(),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('relatives')
              .document(userID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              relative.getData(snapshot.data);
              if (relative.elderUID == '' ||
                  relative.elderUID.isEmpty ||
                  relative.elderUID == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Relative Not Linked'),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            hintText: 'Enter code received from Elderly Care',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () async {
                        relative.elderUID = controller.text;
                        Map<String, dynamic> data = relative.toMap();
                        await linkAccount(data);
                      },
                      child: Text('Link Account'),
                    )
                  ],
                );
              }
              return StreamBuilder(
                  stream: Firestore.instance
                      .collection('profile')
                      .document(relative.elderUID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      elder = Elder(relative.elderUID);
                      elder.setData(snapshot.data.data);
                      return ListView(
                        children: <Widget>[
                          Center(
                            child: Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(elder.picture))),
                                child: SizedBox(
                                  height: 150,
                                  width: 150,
                                )),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              subtitle: Text('Name'),
                              title: Text(elder.userName),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              subtitle: Text('Phone Number'),
                              title: Text(elder.phoneNumber),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              subtitle: Text('Email Address'),
                              title: Text(elder.email),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              subtitle: Text('Age'),
                              title: Text(elder.age),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              subtitle: Text('Gender'),
                              title: Text(elder.gender),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              subtitle: Text('Blood Group'),
                              title: Text(elder.bloodGroup),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              subtitle: Text('Blood Sugar'),
                              title: Text(elder.bloodSugar),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              subtitle: Text('Blood Pressure'),
                              title: Text(elder.bloodPressure),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              subtitle: Text('Allergies'),
                              title: Text(elder.allergies),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              subtitle: Text('Height'),
                              title: Text(elder.height),
                            ),
                          ),
                          Card(
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              subtitle: Text('Weight'),
                              title: Text(elder.weight),
                            ),
                          ),
                          FutureBuilder(
                              future: getRelativeDataMap(),
                              builder: (context, future) {
                                if (future.hasData) {
                                  return Container(
                                    width: 50,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: RaisedButton(
                                      color: Colors.orangeAccent,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      onPressed: () async {
                                        if (future.hasData) {
                                          Map<String, dynamic> mapData =
                                              future.data;
                                          mapData['elderUID'] = '';
                                          await Firestore.instance
                                              .collection('relatives')
                                              .document(userID)
                                              .updateData(mapData);
                                        }
                                      },
                                      child: Text('Unlink'),
                                    ),
                                  );
                                } else
                                  return SizedBox();
                              }),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      );
                    } else
                      return CircularProgressIndicator();
                  });
            } else
              return CircularProgressIndicator();
          }),
    );
  }

  linkAccount(Map<String, dynamic> map) async {
    await Firestore.instance
        .collection('relatives')
        .document(userID)
        .updateData(map);
  }

  getRelativeDataMap() async {
    DocumentSnapshot data =
        await Firestore.instance.collection('relatives').document(userID).get();
    Map<String, dynamic> mapData = data.data;
    return mapData;
  }
}
