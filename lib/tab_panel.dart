import 'package:dashboard_app/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class TabPanel extends StatefulWidget {
  const TabPanel({Key? key}) : super(key: key);

  @override
  State<TabPanel> createState() => _TabPanelState();
}

class _TabPanelState extends State<TabPanel>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey<FormState>> _formKey = [];
  final List<TextEditingController> _addressController = [];
  final List<TextEditingController> _priceController = [];
  final List<TextEditingController> _functionController = [];
  late TabController _tabController;

  int totalTask = 0;
  late List<bool> buttonsIndex = [];
  String address = 'Address 1';
  double price = 2340;
  String function = 'Function Data';
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
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
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: totalTask,
                        itemBuilder: (context, index) {
                          final pressedButton = buttonsIndex[index];
                          var buttonState = "Active";
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.23,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 218, 184, 223),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Form(
                                key: _formKey[index],
                                child: Stack(
                                  children: [
                                    Positioned(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        left: 20,
                                        top: 5,
                                        child: customTextFormField(
                                            context,
                                            "Address",
                                            _addressController[index], (value) {
                                          if (value!.isEmpty) {
                                            return "Please Enter Address";
                                          }
                                        }, (value) {
                                          _addressController[index].text =
                                              value;
                                        })),
                                    Positioned(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        left: 20,
                                        top: 75,
                                        child: customTextFormField(
                                            context,
                                            "Price",
                                            _priceController[index], (value) {
                                          if (value!.isEmpty) {
                                            return "Please Enter Price";
                                          }
                                        }, (value) {
                                          _priceController[index].text = value;
                                        })),
                                    Positioned(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      left: 320,
                                      top: 5,
                                      child: customTextFormField(
                                          context,
                                          "Function",
                                          _functionController[index], (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Its Function";
                                        }
                                      }, (value) {
                                        _functionController[index].text = value;
                                      }),
                                    ),
                                    Positioned(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      left: 320,
                                      top: 75,
                                      child: customTextField(context, "Date",
                                          intl.DateFormat.yMd().format(date)),
                                    ),
                                    Positioned(
                                      right: 20,
                                      bottom: 15,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: pressedButton
                                                ? MaterialStateProperty.all(
                                                    Colors.black)
                                                : MaterialStateProperty.all(
                                                    Colors.grey[400]),
                                          ),
                                          child: pressedButton
                                              ? Text(buttonState)
                                              : const Text("In-Active"),
                                          onPressed: () {
                                            setState(() {
                                              if (_formKey[index]
                                                  .currentState!
                                                  .validate()) {
                                                buttonsIndex[index] =
                                                    !pressedButton;
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
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: totalTask,
                        itemBuilder: (context, index) {
                          final pressedButton = buttonsIndex[index];
                          var buttonState = "Active";
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.23,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 218, 184, 223),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Form(
                                key: _formKey[index],
                                child: Stack(
                                  children: [
                                    Positioned(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        left: 20,
                                        top: 5,
                                        child: customTextFormField(
                                            context,
                                            "Address",
                                            _addressController[index], (value) {
                                          if (value!.isEmpty) {
                                            return "Please Enter Address";
                                          }
                                        }, (value) {
                                          _addressController[index].text =
                                              value;
                                        })),
                                    Positioned(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        left: 20,
                                        top: 75,
                                        child: customTextFormField(
                                            context,
                                            "Price",
                                            _priceController[index], (value) {
                                          if (value!.isEmpty) {
                                            return "Please Enter Price";
                                          }
                                        }, (value) {
                                          _priceController[index].text = value;
                                        })),
                                    Positioned(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      left: 320,
                                      top: 5,
                                      child: customTextFormField(
                                          context,
                                          "Function",
                                          _functionController[index], (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Its Function";
                                        }
                                      }, (value) {
                                        _functionController[index].text = value;
                                      }),
                                    ),
                                    Positioned(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      left: 320,
                                      top: 75,
                                      child: customTextField(context, "Date",
                                          intl.DateFormat.yMd().format(date)),
                                    ),
                                    Positioned(
                                      right: 20,
                                      bottom: 15,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: pressedButton
                                                ? MaterialStateProperty.all(
                                                    Colors.black)
                                                : MaterialStateProperty.all(
                                                    Colors.grey[400]),
                                          ),
                                          child: pressedButton
                                              ? Text(buttonState)
                                              : const Text("In-Active"),
                                          onPressed: () {
                                            setState(() {
                                              if (_formKey[index]
                                                  .currentState!
                                                  .validate()) {
                                                buttonsIndex[index] =
                                                    !pressedButton;
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
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              totalTask = totalTask + 1;
                              buttonsIndex.add(true);
                              _formKey.add(GlobalKey<FormState>());
                              _addressController.add(TextEditingController());
                              _priceController.add(TextEditingController());
                              _functionController.add(TextEditingController());
                            });
                          },
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
}
