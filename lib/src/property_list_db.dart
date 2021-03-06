import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:guestapptest/src/Reservation.dart';
import 'package:guestapptest/src/property_edit.dart';
import 'package:guestapptest/src/reservation_list_db.dart';

import 'Address_screen.dart';

class PropertyListdbScreen extends StatefulWidget {
 final String email;

  // List list;
 PropertyListdbScreen({this.email});
  @override
  _PropertyListdbScreenState createState() =>
      new _PropertyListdbScreenState();
}

class _PropertyListdbScreenState extends State<PropertyListdbScreen> {
  List host = List();
    Future<QuerySnapshot> _listFuture;
  Future<QuerySnapshot> future;
    void refresh() {
    print("inside refresh");
       Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (contex)=> PropertyListdbScreen(
                          email: "${widget.email}",
                        )
                      ));
  }
   Future<QuerySnapshot> getproperty() async {
     var email = "${widget.email}";
     print("emailllllll" + email);
         final FirebaseAuth auth = FirebaseAuth.instance;

    final FirebaseUser user1 = await auth.currentUser();
    final email1 = user1.email;
     final uid = user1.uid;
    print(" user1.email"+email1);
      print(" user1.uid"+uid);
     Future<QuerySnapshot> user =  Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments();

return user;
 //});
     
  }

  var email;
  void initState()  {
    super.initState();
   future= getproperty(); 
    //getproperty();
    email = "${widget.email}";
    print("${widget.email}");
      _listFuture = getproperty();
 
  }
  void refreshList() {
    // reload
    setState(() {
       _listFuture = getproperty();
    
    });
  }
  void dispose() {
    super.dispose();
  }

  @override
 
   Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: new Container(
          height: 1000.0,
          child: new Center(
              // height: 100.0,
              //width: 150.0,
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Padding(
              //padding: const EdgeInsets.all(8.0),
              Expanded(
                child: FutureBuilder(
                  future: _listFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new Container(
                            child: new Column(
                              children: <Widget>[
                                ItemList(
                                  list: snapshot.data.documents[0].data['host'],
                                  //email: "${widget.email}",
                                  email: email,
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new RaisedButton(
                                      child: new Text(
                                        "Add Property",
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      color: Colors.lightBlue,
                                      onPressed: () {
                                          Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return FirstScreen(
                                        email: "${widget.email}");
                                  },
                                ),
                              );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //),
                          )
                        : new Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ),
            ],
          ))),
    );
  }
}

class ItemList extends StatefulWidget {
  final List list;
  final String email;
  ItemList({this.list, this.email});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
 
  void initState() {
 
    super.initState();
        print("emmmmmmmmmmmmmmmmmmmmmmmmmmmmmaaaaaaaaaaaaailllllllllll"+"${widget.email}");
    print("LIStttttttttttt" + "${widget.list}".toString());
 
  }
 
  void refresh() {
    print("inside refresh");
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new PropertyListdbScreen(

      ),
    ));
  }

  void deleteproperty(propertyid,i) {
    print("inside delete_property function");
    print("propertyname" + propertyid);
    var propertyid1 = int.parse(propertyid);
    Firestore.instance
        .collection("Properties")
        .where("Propertyid", isEqualTo: propertyid1)
        .getDocuments()
        .then((string) {
      print('Firestore response: , ${string.documents.length}');
      string.documents.forEach(
        (doc) => Firestore.instance
            .collection("Properties")
            .document("${doc.documentID.toString()}")
            .delete()
            .whenComplete(() {
              /*  setState(() {
              widget.list.removeAt(i);
            });*/
       //     Navigator.pop(context);

                              Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (contex)=> PropertyListdbScreen(
                          email: "${widget.email}",
                        )
                      ));
                          
            
          print('Field Deleted in property table');
        }),
      );
    });
  }

  void deleteuserproperty(propertyname,city,role,propertyid) async {
    var email = "${widget.email}";
        var propertyid1 = int.parse(propertyid);
        print(propertyid1);
    print("inside delete_user_property function");
    print("propertyname" + propertyname);
    print("city" + city);
    print("role" + role);
    print("propertyid" + propertyid.toString());
    Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((string) {
      print('Firestore response111: , ${string.documents.length}');
      string.documents.forEach(
        (doc) => Firestore.instance
            .collection("users")
            .document("${doc.documentID.toString()}")
            .updateData({
          'host': FieldValue.arrayRemove([
            {
              'propertiesname': propertyname,
              'city': city,
              'role': role,
              'Propertyid': propertyid1,
            }
          ]),
        }).whenComplete(() {
          // refresh();
          print('Field Deleted');

        }),
      );
      //var string1 = string.documents[0].data;
        // print("String"+string1.toString());
    });
  }

  @override
    Widget build(BuildContext context) {
    return new Flexible(
        child: Column(
      children: <Widget>[
        Expanded(
            child: SizedBox(
          height: 500.0,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            //shrinkWrap: true,
            itemCount: widget.list == null ? 0 : widget.list.length,
            itemBuilder: (context, i) {
              return new Container(
                child: new SingleChildScrollView(
                  child: new GestureDetector(
                    child: Container(
                      height: 200.0,
                                          child: new Card(
                          semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 10,
                margin: EdgeInsets.all(15),
                      child: new Column(
                        children: <Widget>[
                              new ListTile(
                          title: Row(children: <Widget>[
                            new Text(
                              "Name :${widget.list[i]['propertiesname']}"
                                  .toString(),style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.black),),
     //new Text("Role: ${widget.list[i]['role']}".toString()),
                          ],) ,
                          subtitle:  new Text("City :${widget.list[i]['city']}".toString(),style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.black),),

                          leading: Column(
                            children: <Widget>[
                                                  new IconButton(
                            icon: new Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              //  setState(() {
  deleteuserproperty("${widget.list[i]['propertiesname']}","${widget.list[i]['city']}","${widget.list[i]['role']}","${widget.list[i]['Propertyid']}");
                             deleteproperty("${widget.list[i]['Propertyid']}",i);
                              // });
                            },
                          ),
                                                
                            ],
                          ),
                          trailing:  new IconButton(
                            icon: new Icon(Icons.edit),
                            color: Colors.black,
                            onPressed: () {
                               Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (BuildContext context) => new PropertyEdit(
                                            email: "${widget.email}",//Propertyid
                                            propertyid:"${widget.list[i]['Propertyid']}",
                                            )));
                            },
                          ),
      
                        ),
        Row(
                      children: <Widget>[
                        Flexible(
                            child: Card(
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                              Align(
                                alignment: Alignment(0, -.500),
                                child: new SizedBox(
                                  height: 60.0,
                                  child: new RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(12.0),
                                    ),
                                    child: const Text(
                                      'Add Reservation',
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0),
                                    ),
                                    color: Color(0xffEDE7FF),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return Reservation(
                                              
                                              propertyname:
                                                  "${widget.list[i]['propertiesname']}",
                                                      propertyid:"${widget.list[i]['Propertyid']}",
                                              email: "${widget.email}",
                                              

                                            );
                                          },
                                        ),
                                      );
                                      // });
                                    },
                                  ),
                                ),
                              ),
                          
                              SizedBox(width: 10.0,),
                                 Align(
                               // alignment: Alignment(0, -.500),
                                child: new SizedBox(
                                  height: 60.0,
                                  child: new RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(12.0),
                                    ),
                                    child: const Text(
                                      'View Reservation',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0),
                                    ),
                                    color: Color(0xff6839ed),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ReservationLisdbScreen(
                                                email:"${widget.email}",
                                propertyname : "${widget.list[i]['propertiesname']}",
                                propertyid: "${widget.list[i]['Propertyid']}",
                                                );
                                          },
                                        ),
                                      );
                                      // });
                                    },
                                  ),
                                ),
                              ),
                             
                            ])
                            
                            )
                            )
                      ],
                    ),
                        ],
                      )),
                    ),
                                       /*onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (BuildContext context) => new PropertyEdit(
                                            email: "${widget.email}",//Propertyid
                                            propertyid:"${widget.list[i]['Propertyid']}",
                                            )))*/
                  ),
                ),
              );
              // );
            },
          ),
        )),
      ],
    )
    );
  }
  
}