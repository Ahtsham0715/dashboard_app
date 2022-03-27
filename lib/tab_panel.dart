import 'dart:convert';

import 'package:dashboard_app/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;

class TabPanel extends StatefulWidget {
  const TabPanel({Key? key}) : super(key: key);

  @override
  State<TabPanel> createState() => _TabPanelState();
}

class _TabPanelState extends State<TabPanel>
    with SingleTickerProviderStateMixin {
  var args = Get.arguments;

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey<FormState>> _activeformKey = [];
  final List<GlobalKey<FormState>> _inactiveformKey = [];
  final GlobalKey<FormState> _createformKey = GlobalKey();
  final List<TextEditingController> _activeaddressController = [];
  final List<TextEditingController> _inactiveaddressController = [];
  final TextEditingController _createaddressController =
      TextEditingController();
  final List<TextEditingController> _activepriceController = [];
  final List<TextEditingController> _inactivepriceController = [];
  final TextEditingController _createpriceController = TextEditingController();
  final List<TextEditingController> _activefunctionController = [];
  final List<TextEditingController> _inactivefunctionController = [];
  final TextEditingController _createfunctionController =
      TextEditingController();
  final TextEditingController _createidController = TextEditingController();
  final TextEditingController _createcontractController =
      TextEditingController();
  final TextEditingController _createoptionController = TextEditingController();
  late TabController _tabController;

  // int totalTask = 0;
  // late List<bool> buttonsIndex = [];
  String address = 'Address 1';
  double price = 2340;
  String function = 'Function Data';
  DateTime date = DateTime.now();
  late Map tasks = {};
  late List activetasks = [];
  late List inactivetasks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _gettasks();
  }

  Future<void> _createtask() async {
    Map data = {
      "address": "0xf8b4dFbEEeaffF2E317FFE502d439F174CF7B11a",
      "task": {
        "id": "6d80ccef-fd63-40f1-909a-d318ae2d7452",
        "contract": "0x84d6dfAa9d915fD675D075e91a27f484215Ad345",
        "called": "notify",
        "price": 0.1,
        "option": false,
        "time": "2022-03-27T06:50:47.984Z"
      }
    };

    Map body = {"message": data};

    var response = await http.post(
      Uri.parse(''),
      body: jsonEncode(body),
      headers: {'Content-type': 'application/json'},
    ); //create task url here

    if (response.statusCode == 200) {
      Get.snackbar('Task Created', '');
      // jsonDecode(response.body);
      //successful operation
    } else if (response.statusCode == 404) {
      // print('not found');
      Get.snackbar('Not Found', '');
    } else if (response.statusCode == 422) {
      // print('Validation error');

      var error_details = {
        "detail": [
          {
            "loc": ["string"],
            "msg": "string",
            "type": "string"
          }
        ]
      };
      // var error_details = jsonDecode(response.body);
      Get.snackbar("${error_details['details']?[0]['type']}",
          "${error_details['details']?[0]['msg']} \n ${error_details['details']?[0]['loc']}");
    } else if (response.statusCode == 500) {
      // print('Internal Error');
      Get.snackbar('Internal Error', '');
    } else {
      // print('Error Occured. Try Again');
      Get.snackbar('Error Occured. Try Again', '');
    }
  }

  Future<void> _gettasks() async {
    // var response = await http.get(
    //   Uri.parse(''),
    // ); //tasks url here

    tasks = {
      "address": "0xf8b4dFbEEeaffF2E317FFE502d439F174CF7B11a",
      "balance": 3.5678,
      "transactions": 12,
      "tasklist": [
        {
          "id": "6d80ccef-fd63-40f1-909a-d318ae2d7452",
          "contract": "0x84d6dfAa9d915fD675D075e91a27f484215Ad345",
          "called": "notify",
          "price": 0.1,
          "option": false,
          "time": "2022-03-27T07:23:04.080Z",
          "status": "active"
        },
        {
          "id": "6d80ccef-fd63-40f1-909a24f85dsae2d7452",
          "contract": "0x84d6dfAa9d9531489875D075e91a27f484215Ad345",
          "called": "notify",
          "price": 0.15,
          "option": true,
          "time": "2021-04-20T07:23:04.080Z",
          "status": "inactive"
        }
      ]
    };
    List totalTasks = tasks['tasklist'];
    for (var task in totalTasks) {
      if (task['status'] == "active") {
        activetasks.add(task);
        _activeformKey.add(GlobalKey<FormState>());
        _activeaddressController
            .add(TextEditingController(text: task['id'].toString()));
        _activepriceController
            .add(TextEditingController(text: task['price'].toString()));
        _activefunctionController
            .add(TextEditingController(text: task['called'].toString()));
      } else {
        inactivetasks.add(task);
        _inactiveformKey.add(GlobalKey<FormState>());
        _inactiveaddressController
            .add(TextEditingController(text: task['id'].toString()));
        _inactivepriceController
            .add(TextEditingController(text: task['price'].toString()));
        _inactivefunctionController
            .add(TextEditingController(text: task['called'].toString()));
      }
    }
    print(activetasks);
    print(inactivetasks);

    // if (response.statusCode == 200) {
    //   // tasks = jsonDecode(response.body);
    //   //successful operation
    // } else if (response.statusCode == 404) {
    //   // print('not found');
    //   Get.snackbar('Not Found', '');
    // } else if (response.statusCode == 422) {
    //   // print('Validation error');

    //   var error_details = {
    //     "detail": [
    //       {
    //         "loc": ["string"],
    //         "msg": "string",
    //         "type": "string"
    //       }
    //     ]
    //   };
    //   // var error_details = jsonDecode(response.body);
    //   Get.snackbar("${error_details['details']?[0]['type']}",
    //       "${error_details['details']?[0]['msg']} \n ${error_details['details']?[0]['loc']}");
    // } else if (response.statusCode == 500) {
    //   // print('Internal Error');
    //   Get.snackbar('Internal Error', '');
    // } else {
    //   // print('Error Occured. Try Again');
    //   Get.snackbar('Error Occured. Try Again', '');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 218, 184, 223),
                              borderRadius: BorderRadius.circular(10)),
                          child: TabBar(
                            indicatorColor: Colors.black,
                            tabs: const [
                              Tab(text: "Active"),
                              Tab(text: "Passed")
                            ],
                            controller: _tabController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Active Tab
                      activetasks.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: activetasks.length,
                              itemBuilder: (context, index) {
                                // final pressedButton = buttonsIndex[index];
                                // var buttonState = "Active";
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.23,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 218, 184, 223),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Form(
                                      key: _activeformKey[index],
                                      child: Stack(
                                        children: [
                                          Positioned(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              left: 20,
                                              top: 5,
                                              child: customTextFormField(
                                                  context,
                                                  "Address",
                                                  _activeaddressController[
                                                      index], (value) {
                                                if (value!.isEmpty) {
                                                  return "Please Enter Address";
                                                }
                                              }, (value) {
                                                _activeaddressController[index]
                                                    .text = value;
                                              })),
                                          Positioned(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              left: 20,
                                              top: 75,
                                              child: customTextFormField(
                                                  context,
                                                  "Price",
                                                  _activepriceController[index],
                                                  (value) {
                                                if (value!.isEmpty) {
                                                  return "Please Enter Price";
                                                }
                                              }, (value) {
                                                _activepriceController[index]
                                                    .text = value;
                                              })),
                                          Positioned(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            left: 320,
                                            top: 5,
                                            child: customTextFormField(
                                                context,
                                                "Function",
                                                _activefunctionController[
                                                    index], (value) {
                                              if (value!.isEmpty) {
                                                return "Please Enter Its Function";
                                              }
                                            }, (value) {
                                              _activefunctionController[index]
                                                  .text = value;
                                            }),
                                          ),
                                          Positioned(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            left: 320,
                                            top: 75,
                                            child: customTextField(
                                                context,
                                                "Date",
                                                activetasks[index][
                                                    'time']), // intl.DateFormat.yMd().format(date)
                                          ),
                                          Positioned(
                                            right: 20,
                                            bottom: 15,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: activetasks[
                                                                  index]
                                                              ['status'] ==
                                                          'active'
                                                      ? MaterialStateProperty
                                                          .all(Colors.black)
                                                      : MaterialStateProperty
                                                          .all(
                                                              Colors.grey[400]),
                                                ),
                                                child: const Text('Active'),
                                                onPressed: () {
                                                  setState(() {
                                                    if (_activeformKey[index]
                                                        .currentState!
                                                        .validate()) {
                                                      // buttonsIndex[index] =
                                                      //     !pressedButton;
                                                    }
                                                  });
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                      // Passed Tab
                      inactivetasks.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: inactivetasks.length,
                              itemBuilder: (context, index) {
                                // final pressedButton = buttonsIndex[index];
                                // var buttonState = "Active";
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.23,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 218, 184, 223),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Form(
                                      key: _inactiveformKey[index],
                                      child: Stack(
                                        children: [
                                          Positioned(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              left: 20,
                                              top: 5,
                                              child: customTextFormField(
                                                  context,
                                                  "Address",
                                                  _inactiveaddressController[
                                                      index], (value) {
                                                if (value!.isEmpty) {
                                                  return "Please Enter Address";
                                                }
                                              }, (value) {
                                                _inactiveaddressController[
                                                        index]
                                                    .text = value;
                                              })),
                                          Positioned(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              left: 20,
                                              top: 75,
                                              child: customTextFormField(
                                                  context,
                                                  "Price",
                                                  _inactivepriceController[
                                                      index], (value) {
                                                if (value!.isEmpty) {
                                                  return "Please Enter Price";
                                                }
                                              }, (value) {
                                                _inactivepriceController[index]
                                                    .text = value;
                                              })),
                                          Positioned(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            left: 320,
                                            top: 5,
                                            child: customTextFormField(
                                                context,
                                                "Function",
                                                _inactivefunctionController[
                                                    index], (value) {
                                              if (value!.isEmpty) {
                                                return "Please Enter Its Function";
                                              }
                                            }, (value) {
                                              _inactivefunctionController[index]
                                                  .text = value;
                                            }),
                                          ),
                                          Positioned(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            left: 320,
                                            top: 75,
                                            child: customTextField(
                                                context,
                                                "Date",
                                                inactivetasks[index]['time']
                                                // intl.DateFormat.yMd().format(date)
                                                ),
                                          ),
                                          Positioned(
                                            right: 20,
                                            bottom: 15,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: inactivetasks[
                                                                  index]
                                                              ['status'] ==
                                                          'inactive'
                                                      ? MaterialStateProperty
                                                          .all(Colors.grey)
                                                      : MaterialStateProperty
                                                          .all(Colors.black),
                                                ),
                                                child: const Text("In-Active"),
                                                onPressed: () {
                                                  setState(() {
                                                    if (_inactiveformKey[index]
                                                        .currentState!
                                                        .validate()) {
                                                      // buttonsIndex[index] =
                                                      //     !pressedButton;
                                                    }
                                                  });
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Stack(children: [
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: FloatingActionButton(
                          backgroundColor: args['license_info'] != null
                              ? Colors.black
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          onPressed: args['license_info'] != null
                              ? () {
                                  _createtaskDialog();
                                }
                              : null,
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _createtaskDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 218, 184, 223),
                      borderRadius: BorderRadius.circular(10)),
                  child: Form(
                    key: _createformKey,
                    child: Stack(
                      children: [
                        Positioned(
                            width: MediaQuery.of(context).size.width * 0.2,
                            left: 20,
                            top: 5,
                            child: customTextFormField(
                                context, "Address", _createaddressController,
                                (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Address";
                              }
                            }, (value) {
                              _createaddressController.text = value;
                            })),
                        Positioned(
                            width: MediaQuery.of(context).size.width * 0.2,
                            left: 20,
                            top: 75,
                            child: customTextFormField(
                                context, "Price", _createpriceController,
                                (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Price";
                              }
                            }, (value) {
                              _createpriceController.text = value;
                            })),
                        Positioned(
                          width: MediaQuery.of(context).size.width * 0.2,
                          left: 320,
                          top: 5,
                          child: customTextFormField(
                              context, "Function", _createfunctionController,
                              (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Its Function";
                            }
                          }, (value) {
                            _createfunctionController.text = value;
                          }),
                        ),
                        Positioned(
                          width: MediaQuery.of(context).size.width * 0.2,
                          left: 320,
                          top: 75,
                          child: customTextField(
                            context,
                            "Date",
                            intl.DateFormat.yMd().format(date),
                          ),
                        ),
                        Positioned(
                          width: MediaQuery.of(context).size.width * 0.2,
                          left: 20,
                          top: 145,
                          child: customTextFormField(
                              context, "Id", _createidController,
                              (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Id";
                            }
                          }, (value) {
                            _createidController.text = value;
                          }),
                        ),
                        Positioned(
                          width: MediaQuery.of(context).size.width * 0.2,
                          left: 320,
                          top: 145,
                          child: customTextFormField(
                              context, "Contract", _createcontractController,
                              (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Contract";
                            }
                          }, (value) {
                            _createcontractController.text = value;
                          }),
                        ),
                        Positioned(
                          width: MediaQuery.of(context).size.width * 0.2,
                          left: 20,
                          top: 215,
                          child: customTextFormField(
                              context, "Option", _createoptionController,
                              (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Option";
                            }
                          }, (value) {
                            _createoptionController.text = value;
                          }),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 15,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty
                                        .all(
                                            Colors.black),
                              ),
                              child: const Text("Submit"),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
