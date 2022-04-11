import 'dart:convert';

import 'package:dashboard_app/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  // final TextEditingController _createdateController = TextEditingController();
  late TabController _tabController;

  // int totalTask = 0;
  // late List<bool> buttonsIndex = [];
  var option = 'false';
  String address = 'Address 1';
  double price = 2340;
  String function = 'Function Data';
  DateTime date = DateTime.now();
  late Map tasks = {};
  late List activetasks = [];
  late List inactivetasks = [];
  final addressBox = GetStorage('address_box');
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _boxlistener();
    _gettasks();
  }

  Future<void> _boxlistener() async {
    addressBox.listen(() {
      _gettasks();
    });
  }

  Future<void> _createtask() async {
    Map data = {
      "address": addressBox.read('selected_address').toString(),
      "task": {
        // "id": _createidController.text.toString(),
        "contract": _createcontractController.text.toString(),
        "called": _createfunctionController.text.toString(),
        "price": double.parse(_createpriceController.text.toString()),
        "option": _createoptionController.text,
        "time": date.toString()
      }
    };

    // Map body = {"message": data};

    var response = await http.post(
      Uri.parse('http://localhost:8000/api/v1/tasks/create'),
      body: jsonEncode(data),
      headers: {'Content-type': 'application/json'},
    ); //create task url here

    if (response.statusCode == 200) {
      Get.snackbar('Task Created', '');
      Navigator.pop(context);
      // jsonDecode(response.body);
      //successful operation
      tasks = jsonDecode(response.body);
      List totalTasks = tasks['tasklist'];
      for (var task in totalTasks) {
        if (task['status'] == "active") {
          activetasks.add(task);
          _activeformKey.add(GlobalKey<FormState>());
          _activeaddressController
              .add(TextEditingController(text: tasks['address'].toString()));
          _activepriceController
              .add(TextEditingController(text: task['price'].toString()));
          _activefunctionController
              .add(TextEditingController(text: task['called'].toString()));
        } else {
          inactivetasks.add(task);
          _inactiveformKey.add(GlobalKey<FormState>());
          _inactiveaddressController
              .add(TextEditingController(text: tasks['address'].toString()));
          _inactivepriceController
              .add(TextEditingController(text: task['price'].toString()));
          _inactivefunctionController
              .add(TextEditingController(text: task['called'].toString()));
        }
      }
    } else if (response.statusCode == 404) {
      // print('not found');
      Get.snackbar('Not Found', '');
    } else if (response.statusCode == 422) {
      // print('Validation error');
      var error_details = jsonDecode(response.body);
      print(error_details);
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

  Future<void> _updatetask(id, status) async {
//     Map data ={
//   "id": id,
//   "status": status
// };
    // print(id);
    // print(status);
   var address = addressBox.read('selected_address');
print(address);
    var response = await http.post(
      Uri.parse(
          'http://localhost:8000/api/v1/tasks/${address.toString()}/update-task'),
      body: jsonEncode({"id": id.toString(), "status": status.toString()}),
      headers: {'Content-type': 'application/json'},
    ); //update task url here

    if (response.statusCode == 200) {
      Get.snackbar('Task Updated', '');
      // jsonDecode(response.body);
      // successful operation
      tasks = jsonDecode(response.body);
      List totalTasks = tasks['tasklist'];
      for (var task in totalTasks) {
        if (task['status'] == "active") {
          activetasks.add(task);
          _activeformKey.add(GlobalKey<FormState>());
          _activeaddressController
              .add(TextEditingController(text: tasks['address'].toString()));
          _activepriceController
              .add(TextEditingController(text: task['price'].toString()));
          _activefunctionController
              .add(TextEditingController(text: task['called'].toString()));
        } else {
          inactivetasks.add(task);
          _inactiveformKey.add(GlobalKey<FormState>());
          _inactiveaddressController
              .add(TextEditingController(text: tasks['address'].toString()));
          _inactivepriceController
              .add(TextEditingController(text: task['price'].toString()));
          _inactivefunctionController
              .add(TextEditingController(text: task['called'].toString()));
        }
      }
    } else if (response.statusCode == 404) {
      // print('not found');
      Get.snackbar('Not Found', '');
    } else if (response.statusCode == 422) {
      // print('Validation error');
      var error_details = jsonDecode(response.body);
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

  Future _gettasks() async {
    var address = addressBox.read('selected_address');
    // print(addressBox.read('selected_address'));
    print(address);
    var response = await http.get(
      Uri.parse(
          'http://localhost:8000/api/v1/tasks/${address.toString()}/get-tasks-info'),
    ); //tasks url here

    if (response.statusCode == 200) {
      tasks.clear();
      activetasks.clear();
      inactivetasks.clear();
      print('gettasks');
      _activeformKey.clear();
      _activeaddressController.clear();
      _activepriceController.clear();
      _activefunctionController.clear();
      _inactiveformKey.clear();
      _inactiveaddressController.clear();
      _inactivepriceController.clear();
      _inactivefunctionController.clear();
      tasks = jsonDecode(response.body);
      //successful operation
      List totalTasks = tasks['tasklist'];
      for (var task in totalTasks) {
        if (task['status'] == "active") {
          activetasks.add(task);
          _activeformKey.add(GlobalKey<FormState>());
          _activeaddressController
              .add(TextEditingController(text: tasks['address'].toString()));
          _activepriceController
              .add(TextEditingController(text: task['price'].toString()));
          _activefunctionController
              .add(TextEditingController(text: task['called'].toString()));

        } else {
          inactivetasks.add(task);
          _inactiveformKey.add(GlobalKey<FormState>());
          _inactiveaddressController
              .add(TextEditingController(text: tasks['address'].toString()));
          _inactivepriceController
              .add(TextEditingController(text: task['price'].toString()));
          _inactivefunctionController
              .add(TextEditingController(text: task['called'].toString()));
        }
      }
     
    } else if (response.statusCode == 404) {
      // print('not found');
      Get.snackbar('Not Found', '');
    } else if (response.statusCode == 422) {
      var error_details = jsonDecode(response.body);
      Get.snackbar("${error_details['details']?[0]['type']}",
          "${error_details['details']?[0]['msg']} \n ${error_details['details']?[0]['loc']}");
    } else if (response.statusCode == 500) {
      // print('Internal Error');
      Get.snackbar('Internal Error', '');
    } else {
      // print('Error Occured. Try Again');
      Get.snackbar('Error Occured. Try Again', '');
    }
     setState(() {
       
     });
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
                              child: Text('No Task Available'),
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
                                                      _updatetask(
                                                          activetasks[index]
                                                                  ['id']
                                                              .toString(),
                                                          activetasks[index]
                                                                  ['status']
                                                              .toString());
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
                              child: Text('No Task Available'),
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
                                                      _updatetask(
                                                          inactivetasks[index]
                                                                  ['id']
                                                              .toString(),
                                                          inactivetasks[index]
                                                                  ['status']
                                                              .toString());
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
            backgroundColor: const Color.fromARGB(255, 218, 184, 223),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter dropDownState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  left: 20,
                                  top: 5,
                                  child: customTextFormField(context, "Address",
                                      _createaddressController, (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter Address";
                                    }
                                  }, (value) {
                                    _createaddressController.text = value;
                                  })),
                              Positioned(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
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
                                child: customTextFormField(context, "Function",
                                    _createfunctionController, (value) {
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
                                child: customTextFormField(context, "Contract",
                                    _createcontractController, (value) {
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
                                top: 235,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height *
                                      6 /
                                      100,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 181, 144, 187),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: DropdownButton(
                                    underline: Center(),
                                    isExpanded: true,
                                    borderRadius: BorderRadius.circular(4),
                                    dropdownColor: const Color.fromARGB(
                                        255, 181, 144, 187),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 181, 144, 187),
                                    ),
                                    hint: Text(option.toString()),
                                    items: [true, false].map((value) {
                                      return DropdownMenuItem(
                                        alignment: Alignment.center,
                                        enabled: true,
                                        value: value,
                                        child: Text(
                                          value.toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (_) {
                                      dropDownState(() {
                                        option = _.toString();
                                        _createoptionController.text =
                                            _.toString();
                                      });
                                      // print(_);
                                      print(_createoptionController.text);
                                    },
                                  ),
                                ),
                                // child: customTextFormField(
                                //     context, "Option", _createoptionController,
                                //     (value) {
                                //   if (value!.isEmpty) {
                                //     return "Please Enter Option";
                                //   }
                                // }, (value) {
                                //   _createoptionController.text = value;
                                // }),
                              ),
                              Positioned(
                                right: 20,
                                bottom: 15,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                    ),
                                    child: const Text("Submit"),
                                    onPressed: () {
                                      if (_createformKey.currentState!
                                          .validate()) {
                                        _createtask();
                                        // Navigator.pop(context);
                                      }
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }
}
