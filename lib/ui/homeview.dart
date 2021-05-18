import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/net/api_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'addView.dart';
import 'package:crypto_wallet/net/flutterfire.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double bitcoin = 0.0;
  double tether = 0.0;
  double ethereum = 0.0;

  @override
  void initState() {
    getValues();
  }

  getValues() async {
    bitcoin = await getPrice('bitcoin');
    tether = await getPrice('tether');
    ethereum = await getPrice('ethereum');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getValues(String id, double amount) {
      if (id == 'bitcoin') {
        return bitcoin * amount;
      } else if (id == 'tether') {
        return tether * amount;
      } else if (id == 'ethereum') {
        return ethereum * amount;
      }
    }

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .collection('Coins')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  children: snapshot.data.docs.map((document) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.money, color: Colors.white),
                          Column(
                            children: [
                              Text(
                                'Coin Name',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${document.id}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Amount Owned",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${getValues(document.id, document['Amount']).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await removeCoin(document.id);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddView()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
