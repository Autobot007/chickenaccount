import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:chickenaccount/screens/billscreen.dart';
import 'package:chickenaccount/screens/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OldBillScreen extends StatefulWidget {
  final DocumentSnapshot billDocumentSnapshot;

  const OldBillScreen({super.key, required this.billDocumentSnapshot});

  @override
  State<OldBillScreen> createState() => _OldBillScreenState();
}

class _OldBillScreenState extends State<OldBillScreen> {
  late DocumentSnapshot billDocumentsnapShot;
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore editBillSnapshot = FirebaseFirestore.instance;
  bool edit = false;
  String? tradersName = '';
  String? mobile = '';
  List<dynamic> entries = [];
  String grandTotal = '0';
  double balance = 0;
  double total = 0;
  String documentID = '';
  TextEditingController _balanceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getDetails();
    billDocumentsnapShot = widget.billDocumentSnapshot;
    documentID = billDocumentsnapShot.id;
    entries = billDocumentsnapShot['Entries'];
    grandTotal = billDocumentsnapShot['GrandTotal'];
    balance = double.tryParse(billDocumentsnapShot['Balance']) ?? 0;
    total = billDocumentsnapShot['Total'];
    setState(() {});
  }

  void updateBills(String documentID, String balance, String grandTotal) {
    try {
      editBillSnapshot
          .collection('users')
          .doc(user?.uid)
          .collection('bill')
          .doc(documentID)
          .update({'Balance': balance, 'GrandTotal': grandTotal});
      edit = false;
      setState(() {});
    } catch (e) {}
  }

  Future<void> getDetails() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    tradersName = localData.getString('FirmName');
    mobile = localData.getString('Mobile');
    setState(() {});
  }

  ScreenshotController _screenshotController = ScreenshotController();
  void saveToGallery(BuildContext context) {
    _screenshotController.capture().then((Uint8List? image) {
      //it will capture the ss
      if (image != null) {
        saveAndShareImage(image); // to save image to gallery ...
      } else {
        print('Error: Captured image is null.');
      }
    }).catchError((e) => print('Error capturing screenshot: $e'));
  }

  Future<void> saveAndShareImage(Uint8List bytes) async {
    await requestPermission(Permission
        .storage); //to save we need permission for that i asked for permission
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${DateTime.now()}.png';
    await File(filePath).writeAsBytes(bytes);
    final shareData = ShareData(text: 'Bill', file: File(filePath));
    await Share.shareFiles([shareData.filePath]);
    print('Image Saved');
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          InkWell(
              child: Icon(Icons.edit),
              onTap: () {
                edit = true;
                setState(() {});
              })
        ],
      ),
      drawer: const Drawer1(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 1.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    ////**screenshot widhget**
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(border: Border.all(width: 2)),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            '$tradersName', // FirmName
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            '($mobile)' //FirmName Mobile number
                            ,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.01,
                                horizontal:
                                    MediaQuery.of(context).size.height * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "ShopName :   ",
                                        ),
                                        Text(
                                          //ShopName
                                          '${billDocumentsnapShot['ShopName']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Customer Name :   ",
                                        ),
                                        Text(
                                            '${billDocumentsnapShot['CustomerName']}', //Customer Name
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold))
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Date : ',
                                        ),
                                        Text(
                                          '${billDocumentsnapShot['Date']}', //Date from snapshot
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Phone No:",
                                        ),
                                        Text(
                                            '${billDocumentsnapShot['ContactNo']}', //customer conatct number
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ))
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20, //Nos 52 57.4
                            width: 400,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 1.5,
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.height * 0.03,
                                MediaQuery.of(context).size.height * 0.01,
                                MediaQuery.of(context).size.height * 0.03,
                                MediaQuery.of(context).size.height * 0.0),
                            child: Table(
                                border: TableBorder.all(color: Colors.black),
                                children: <TableRow>[
                                  TableRow(
                                      // Header row
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300]),
                                      children: const <Widget>[
                                        Text(
                                          'Date',
                                          style: TextStyle(
                                            height: 2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Nos',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: 2),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Kg',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: 2),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Rate',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: 2),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Amount',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: 2),
                                          textAlign: TextAlign.center,
                                        ),
                                      ]),
                                  for (int i = 0; i < entries.length; i++)
                                    //total =double.tryParse(getEntries[i]['Total'])

                                    TableRow(
                                      children: <Widget>[
                                        Text(
                                          entries[i]['Date'],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(height: 2),
                                        ),
                                        Text(entries[i]['Nos'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(height: 2)),
                                        Text(entries[i]['Weight'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(height: 2)),
                                        Text(entries[i]['Rate'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(height: 2)),
                                        Text(entries[i]['Total'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(height: 2)),
                                      ],
                                    ),

                                  //TableRow(),
                                ]),
                          ),
                          Container(
                            //CONATINER 1

                            width: MediaQuery.of(context).size.width * 1.5,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.height * 0.03,
                                MediaQuery.of(context).size.height * 0.0,
                                MediaQuery.of(context).size.height * 0.03,
                                MediaQuery.of(context).size.height * 0.0),
                            child: Container(
                              alignment: Alignment.topRight,
                              width: MediaQuery.of(context).size.width * 1.5,
                              decoration: const BoxDecoration(
                                  border: Border.symmetric(
                                vertical: BorderSide(width: 1),
                              )),
                              child: Text(
                                style: const TextStyle(
                                  wordSpacing: 10,
                                  height: 2,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                'Total :  ${billDocumentsnapShot['Total']}',
                              ),
                            ),
                          ),
                          Container(
                            //CONATINER 1

                            width: MediaQuery.of(context).size.width * 1.5,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.height * 0.03,
                                MediaQuery.of(context).size.height * 0.0,
                                MediaQuery.of(context).size.height * 0.03,
                                MediaQuery.of(context).size.height * 0.0),
                            child: Container(
                              alignment: Alignment.topRight,
                              width: MediaQuery.of(context).size.width * 1.5,
                              decoration: const BoxDecoration(
                                  border: Border.symmetric(
                                      vertical: BorderSide(width: 1),
                                      horizontal: BorderSide(width: 1))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    style: TextStyle(
                                      wordSpacing: 10,
                                      height: 2,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    'Balance :  ',
                                  ),
                                  edit
                                      ? Container(
                                          decoration: BoxDecoration(
                                              border: Border.all()),
                                          height: 36.4,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.5,
                                          child: TextField(
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            onChanged: (totalbalance) {
                                              double totalbalance =
                                                  double.tryParse(
                                                          _balanceController
                                                              .text) ??
                                                      0;
                                              setState(() {
                                                balance = double.parse(
                                                    totalbalance
                                                        .toStringAsFixed(1));
                                                grandTotal =
                                                    (total + totalbalance)
                                                        .toStringAsFixed(1);
                                              });
                                            },
                                            textAlign: TextAlign.end,
                                            controller: _balanceController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.0)),
                                            ),
                                            textInputAction:
                                                TextInputAction.done,
                                          ),
                                        )
                                      : Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          alignment: Alignment.centerRight,
                                          height: 36.4,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.5,
                                          child: Text(
                                            balance.toStringAsFixed(1),
                                            style: TextStyle(
                                              wordSpacing: 10,
                                              height: 2,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            //CONATINER 1
                            width: MediaQuery.of(context).size.width * 1.5,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.height * 0.03,
                                MediaQuery.of(context).size.height * 0.0,
                                MediaQuery.of(context).size.height * 0.03,
                                MediaQuery.of(context).size.height * 0.0),
                            margin: EdgeInsets.fromLTRB(0, 0, 0,
                                MediaQuery.of(context).size.height * 0.1),
                            child: Container(
                              alignment: Alignment.topRight,
                              width: MediaQuery.of(context).size.width * 1.5,
                              decoration: const BoxDecoration(
                                  border: Border.symmetric(
                                      vertical: BorderSide(width: 1),
                                      horizontal: BorderSide(width: 1))),
                              child: Text(
                                style: const TextStyle(
                                  wordSpacing: 2,
                                  height: 2,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                'Total Bill Amount : $grandTotal',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    edit
                        ? ElevatedButton(
                            onPressed: () async {
                              updateBills(documentID,
                                  balance.toStringAsFixed(1), grandTotal);
                            },
                            child: const Text('Update Bill'))
                        : ElevatedButton(
                            onPressed: () async {
                              saveToGallery(context);
                            },
                            child: const Text('Share'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
