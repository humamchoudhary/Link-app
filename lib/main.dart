import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:link_app/test.dart';
import 'package:localstore/localstore.dart';
import 'common/color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/test": (context) => FadingListViewWidget(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Main(title: 'Link App'),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key, required this.title});
  final String title;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  List LinkName = [];
  List Links = [];
  List Cat = ["Cat1", "Cat2", "Cat3", "Cat4", "Cat5", "Cat6"];
  int _selectedIndex = 0;
  final db = Localstore.instance;
  GetData() async {
    setState(() {
      LinkName = [];
      Links = [];
    });
    final items = await db.collection('Links').get();
    print(items);
    setState(() {
      if(items != null){
    items.forEach((key, value) {
      LinkName.add(value["linkname"]);
      Links.add(value["link"]);
    });
      }
    });
    print(Links);
    print(LinkName);
  }

  AddData(String linkname, String link, String cat) {
    db
        .collection('Links')
        .doc(linkname)
        .set({"linkname": linkname, "link": link, "cat": cat});
  }
  Delete() async {
    final items = await db.collection('Links').get();
    if(items != null){
    items.forEach((key, value) {
      LinkName.add(value["linkname"]);
      Links.add(value["link"]);
    });
      }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // print("on $_selectedIndex");
  }

  @override
  void initState() {
    GetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        GetData();
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 350,
                  child: AppBar(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    centerTitle: true,
                    leading: IconButton(icon: Icon(Icons.refresh), onPressed: () {GetData();},),
                    flexibleSpace: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            gradient: LinearGradient(
                              colors: [
                                HexColor("014da1"),
                                HexColor("0079fb"),
                              ],
                              // begin: Alignment.bottomLeft,
                              // end: Alignment.topRight,
                            ))),
                    title: Text(widget.title),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recent Link",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(color: Colors.white),
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 4,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Card(
                                elevation: 0,
                                child: SizedBox(
                                    height: 260,
                                    child:LinkName.isEmpty?Center(child:Text(
                        "No links found",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(color: Colors.grey),
                            fontSize: 15),
                      ),) : ListView.builder(
                                      padding: EdgeInsets.only(top: 10),
                                      shrinkWrap: true,
                                      itemCount: LinkName.length,
                                      itemBuilder: (context, index) {
                                        return _buildLinkItem(index);
                                      },
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              LinkName.isEmpty? Container():ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black)),
                                onPressed: () {
                                  print("Show All");
                                },
                                child: const Text("Show All"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
              child: Text("Categories",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      fontSize: 20)),
            ),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 10, right: 10),
                itemCount: Cat.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildCatItem(index);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          activeChild: Container(
            width: 60,
            height: 60,
            child: Icon(Icons.close),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  HexColor("014da1"),
                  HexColor("0079fb"),
                ])),
          ),
          direction: SpeedDialDirection.left,
          gradient: LinearGradient(colors: [Colors.black, Colors.red]),
          gradientBoxShape: BoxShape.circle,
          children: [
            SpeedDialChild(
              label: "Add Link",
              child: Icon(Icons.link_rounded),
              onTap: () {
                AddData("youtube3", "www.youtube.com", "test");
                GetData();
                Toast("Add Link");
              },
            ),
            SpeedDialChild(
              label: "Add Category",
              child: Icon(Icons.category),
              onTap: () {
                GetData();
                Toast("Add Category");
              },
            )
          ],
          child: Container(
            width: 60,
            height: 60,
            child: Icon(Icons.add),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 21, 101, 192),
                  Color.fromARGB(255, 66, 170, 255)
                ])),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //     child: Container(
        //       width: 60,
        //       height: 60,
        //       child: Icon(Icons.add),
        //       decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           gradient: LinearGradient(colors: [
        //                         Color.fromARGB(255, 21, 101, 192),
        //                         Color.fromARGB(255, 66, 170, 255)
        //                       ])),
        //     ),
        //     onPressed: () {},
        //   ),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 20,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.link),
                label: 'LinkName',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Categories',
              ),
            ]),
      ),
    );
  }

  Future Toast(String msg) async {
    return Fluttertoast.showToast(msg: msg);
  }

  Widget _buildLinkItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          // horizontalTitleGap: 5.0,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          tileColor: HexColor("0b1921"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Center(
            child: Text("${LinkName[index]}",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(color: Colors.white),
                    fontSize: 15)),
          ),
        ),
      ),
    );
  }

  Widget _buildCatItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 100,
        child: Card(
          elevation: 5,
          child: InkWell(
            onTap: (() {}),
            child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                horizontalTitleGap: 5.0,
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Column(
                  children: [
                    Icon(
                      Icons.category,
                      color: HexColor("0b1921"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text("${Cat[index]}",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(color: Colors.black),
                              fontSize: 14)),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
