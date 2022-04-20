import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class shimmer extends StatefulWidget {
  const shimmer({Key? key}) : super(key: key);

  @override
  State<shimmer> createState() => _shimmerState();
}

class _shimmerState extends State<shimmer> {
  int _value = 1;
  List list = [];
  bool status = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    DatabaseReference rrr = FirebaseDatabase.instance.ref("Realtime");
    DatabaseEvent de = await rrr.once();
    Map mm = de.snapshot.value as Map;
    mm.forEach((key, mayur) {
      setState(() {
        list.add(mayur);

        Future.delayed(Duration(seconds: 10)).then((value) {
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
      body: status
          ? ListView.builder(
        itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  title: Text("${list[index]['name']}"),
                  subtitle: Text(
                    "${list[index]['detail']}",
                    style: TextStyle(fontSize: 15),
                  ),
                  leading: Image.network("${list[index]['imageurl']}"),
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
                                onTap: () {

                                },
                                child: Text('Delete'),
                                value: 'Delete'),
                          ]),
                );
              },
            )
          : Shimmer.fromColors(
              enabled: status,
              child: Expanded(
                  child: Container(
                height: 350,
                width: 450,
              )),
              baseColor: Colors.black,
              highlightColor: Colors.green),
    );
  }
}
