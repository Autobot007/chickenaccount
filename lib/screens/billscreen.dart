import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:chickenaccount/screens/drawer.dart';
import 'package:chickenaccount/widgets/newbillwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

//import 'package:take_screenshot/take_screenshot.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  // ignore: no_leading_underscores_for_local_identifiers
  //BillScreen({super.key, required this.entries});

  // ignore: unused_field

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  // final TakeScreenshotController _takeScreenshotController =
  //     TakeScreenshotController();
  final _screenshotController = ScreenshotController();
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore billingFinalSnapshot = FirebaseFirestore.instance;
  final TextEditingController _balanceController = TextEditingController();
  Map<String, dynamic> customer = {};
  final NewBillWidget bill = NewBillWidget();
  bool _isLoading = false;
  String grandTotal = '0';
  double total = 0;
  double balance = 0;
  List<DocumentSnapshot> getEntries = [];
  List<Map<String, dynamic>> billEntries = [];
  bool billed = false;
  String? tradersName = '';
  String? mobile = '';

  Uint8List? imageData;

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

  Future<void> getDetails() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    tradersName = localData.getString('FirmName');
    mobile = localData.getString('Mobile');
  }

  //int numberofentries = 5;

  @override
  Widget build(BuildContext context) {
    getDetails();
    getEntries =
        ModalRoute.of(context)!.settings.arguments as List<DocumentSnapshot>;
    //combinedEntries = combinedEntriesFunction(getEntries);
    billEntries = billEntriestoMap(getEntries);

    Future<void> getCustomer() async {
      DocumentSnapshot<Map<String, dynamic>> customerSnapShot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('customers')
              .doc(getEntries[0]['ShopName'])
              .get();
      setState(() {
        customer.addAll(customerSnapShot.data()!);
      });
    }

    total = getSum(getEntries);

    getCustomer();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
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
                          // Image.asset("assets/example.jpg"),
                          const SizedBox(height: 30),
                          Text(
                            tradersName.toString(),
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            '(${mobile.toString()})',
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                                          "ShopName :",
                                        ),
                                        Text(
                                          '${customer["ShopName"]}',
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
                                          "Customer Name:",
                                        ),
                                        Text("${customer["CustomerName"]}",
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
                                          'Date:',
                                        ),
                                        Text(
                                          DateFormat('dd-MM-yyyy')
                                              .format(DateTime.now()),
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
                                        Text("${customer["ContactNo"]}",
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
                                  for (int i = 0; i < getEntries.length; i++)
                                    //total =double.tryParse(getEntries[i]['Total'])

                                    TableRow(
                                      children: <Widget>[
                                        Text(
                                          getEntries[i]['Date'],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(height: 2),
                                        ),
                                        Text(getEntries[i]['Nos'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(height: 2)),
                                        Text(getEntries[i]['Weight'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(height: 2)),
                                        Text(getEntries[i]['Rate'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(height: 2)),
                                        Text(getEntries[i]['Total'],
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
                                'Total : ${double.parse(total.toString()).toStringAsFixed(2)} ',
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
                                  Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    height: 36.4,
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    child: TextField(
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      onChanged: (totalbalance) {
                                        double totalbalance = double.tryParse(
                                                _balanceController.text) ??
                                            0;
                                        setState(() {
                                          balance = double.parse(
                                              total.toStringAsFixed(2));
                                          grandTotal = (total + totalbalance)
                                              .toStringAsFixed(2);
                                        });
                                      },
                                      textAlign: TextAlign.end,
                                      controller: _balanceController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(1.0)),
                                      ),
                                      textInputAction: TextInputAction.done,
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
                                'Total Bill Amount :    $grandTotal ',
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
                    billed
                        ? const SizedBox()
                        : ElevatedButton(
                            onPressed: () {
                              saveBillFunction();
                              //saveBillFunction();
                            },
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Save Bill',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    )),
                          ),
                    billed
                        ? ElevatedButton(
                            onPressed: () async {
                              saveToGallery(context);
                            },
                            child: const Text('Share'))
                        : const SizedBox()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  saveBillFunction() async {
    setState(() {
      _isLoading = true;
    });

    try {
      for (int i = 0; i < getEntries.length; i++) {
        billingFinalSnapshot
            .collection('users')
            .doc(user!.uid)
            .collection('entry')
            .doc(getEntries[i].id)
            .update({'Billed': true});
      }
      String res = await bill.newBill(
        shopName: customer['ShopName'],
        customerName: customer['CustomerName'],
        contactNo: customer['ContactNo'],
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        entry: billEntries,
        total: total,
        balance: _balanceController.text,
        grandTotal: grandTotal,
      );

      if (res == 'success') {
        billed = true;
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {}
  }
}

List<Map<String, dynamic>> billEntriestoMap(List<DocumentSnapshot> getEntries) {
  List<Map<String, dynamic>> billEntries = [];
  for (int i = 0; i < getEntries.length; i++) {
    Map<String, dynamic> singleEntry = {
      'Date': getEntries[i]['Date'],
      'Nos': getEntries[i]['Nos'],
      'Weight': getEntries[i]['Weight'],
      'Rate': getEntries[i]['Rate'],
      'Total': getEntries[i]['Total']
    };
    billEntries.add(singleEntry);
  }

  return billEntries;
}

class ShareData {
  final String text;
  final File? file;

  ShareData({required this.text, this.file});

  String get filePath => file!.path;
}

/*

*/
/*List<Map<String, dynamic>> combinedEntriesFunction(
    List<DocumentSnapshot> entries) {
  void bubblesort(List<Map<String, dynamic>> entries) {}
  void swap(List<Map<String, dynamic>> entrisEntries) {}
  List<Map<String, dynamic>> finalEntries = [];
  for (int i = 0; i < entries.length; i++) {
    int currentPosition = 0;
    if (i == 0) {
      finalEntries.add(entries[i].data() as Map<String, dynamic>);
    } else if (finalEntries[currentPosition]['Date'] == entries[i]['Date']) {
      finalEntries[currentPosition]['Nos'] =
          ((double.tryParse(finalEntries[currentPosition]['Nos']) ?? 0) +
                  (double.tryParse(entries[i]['Nos']) ?? 0))
              .toString();
      finalEntries[currentPosition]['Weight'] =
          ((double.tryParse(finalEntries[currentPosition]['Weight']) ?? 0) +
                  (double.tryParse(entries[i]['Weight']) ?? 0))
              .toStringAsFixed(2);

      finalEntries[currentPosition]['Total'] =
          ((double.tryParse(finalEntries[currentPosition]['Weight']) ?? 0) *
                  (double.tryParse(finalEntries[currentPosition]['Rate']) ?? 0))
              .toStringAsFixed(2);

      //finalEntries[currentPosition]['Total'] = finalEntries[currentPosition]
      //      ['Weight'] *
      //finalEntries[currentPosition]['Rate'];
    } else {
      currentPosition++;
      finalEntries.add(entries[i].data() as Map<String, dynamic>);
    }
  }

  return finalEntries;
}*/

double getSum(List<DocumentSnapshot> getEntries) {
  double total = 0;
  for (int i = 0; i < getEntries.length; i++) {
    total += double.tryParse(getEntries[i]['Total']) ?? 0;
  }
  return total;
}
