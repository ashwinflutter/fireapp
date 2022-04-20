import 'dart:io';
import 'dart:math';
import 'package:fireapp/listpage.dart';
import 'package:fireapp/shimmer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dd.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: listpage(),
  ));

}

class fireapp extends StatefulWidget {
  const fireapp({Key? key}) : super(key: key);

  @override
  State<fireapp> createState() => _fireappState();
}

class _fireappState extends State<fireapp> {

  final ImagePicker _picker = ImagePicker();
  String str = "";
  double? _ratingValue;
  String imgurl = "";

  // final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: () async {
                  // Pick an image
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    str = image!.path;
                  });
                },
                child: Container(
                  height: 170,
                  width: 170,
                  child: str != ""
                      ? CircleAvatar(
                          backgroundImage: FileImage(File(str)),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(File(str)),
                        ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                    labelText: "Application Name",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextField(
                controller: ad,
                // controller: name,
                decoration: InputDecoration(
                    labelText: "AD",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextField(
                controller: detail,
                // controller: name,
                decoration: InputDecoration(
                    labelText: "DETAILS",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RatingBar(
                initialRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: Colors.orange),
                    half: const Icon(
                      Icons.star_half,
                      color: Colors.orange,
                    ),
                    empty: const Icon(
                      Icons.star_outline,
                      color: Colors.orange,
                    )),
                onRatingUpdate: (value) {
                  setState(() {
                    _ratingValue = value;
                    print(value);
                  });
                }),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () async {
                  final storageRef = FirebaseStorage.instance.ref();

                  String imagename = "${name.text}${Random().nextInt(50)}";

                  final spaceRef = storageRef.child("fireapp/$imagename");
                  await spaceRef.putFile(File(str));

                  spaceRef.getDownloadURL().then((value) async {
                    print(value);
                    DatabaseReference rrr = FirebaseDatabase.instance.ref("Realtime").push();

                    String? aa = rrr.key;
                    print(aa);

                    await rrr.set({
                      "name": name.text,
                      "id": aa,
                      "ad": ad.text,
                      "detail": detail.text,
                      "imageurl": value,
                      "rating": _ratingValue,
                    });
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return listpage();
                      },
                    ));
                  });
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }

  TextEditingController name = TextEditingController();
  TextEditingController ad = TextEditingController();
  TextEditingController detail = TextEditingController();
  TextEditingController rating = TextEditingController();
}
