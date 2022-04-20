import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class listpage extends StatefulWidget {
  const listpage({Key? key}) : super(key: key);

  @override
  State<listpage> createState() => _listpageState();
}

class _listpageState extends State<listpage> {
  int _value = 1;
  bool status = false;
  bool isshimmer = true;

  List list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    Future.delayed(Duration(seconds: 5)).then((value) {
      isshimmer = false;
      setState(() {});
      print("===$status");
    });
    DatabaseReference rrr = FirebaseDatabase.instance.ref("Realtime");
    DatabaseEvent de = await rrr.once();

    Map mm = de.snapshot.value as Map;

    mm.forEach((key, mayur) {
      setState(() {
        list.add(mayur);

        Future.delayed(Duration(seconds: 5)).then((value) {
          status = true;

          setState(() {});
          print("===$status");
        });
      });
    });
    print(de.snapshot.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade200,
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return status
              ? Card(
                  child: ListTile(
                    onTap: () {},
                    title: Text("${list[index]['name']}"),
                    subtitle: Text(
                        "${list[index]['detail']}       rating: ${list[index]['rating']} *          "
                            "               ad:-${list[index]['ad']}"),
                    leading: Expanded(
                      child: ClipRect(
                          child: Image.network("${list[index]['imageurl']}",fit: BoxFit.fill,height: 120,width: 80,)),
                    ),
                    trailing: PopupMenuButton(
                        onSelected: (selectedValue) {
                          print(selectedValue);
                        },
                        itemBuilder: (BuildContext ctx) => [
                              PopupMenuItem(
                                  onTap: () {},
                                  child: Text('Edit'),
                                  value: 'Edit'),
                              PopupMenuItem(
                                  onTap: () {},
                                  child: Text('Delete'),
                                  value: 'Delete'),
                            ]),
                  ),
                )
              : Shimmer.fromColors(
                  baseColor: Colors.green,
                  highlightColor: Colors.red,
                  enabled: isshimmer,
                  child: ListView.builder(
                    itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48.0,
                            height: 48.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: 40.0,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    itemCount: 6,
                  ),
                );
        },
      ),
    );
  }
}
