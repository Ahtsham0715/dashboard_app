import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dashboard_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:window_size/window_size.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("App Name");
    setWindowMinSize(const Size(1100, 720));
    setWindowMaxSize(Size.infinite);
  }
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Api',
      darkTheme:
          ThemeData(primarySwatch: Colors.purple, brightness: Brightness.dark),
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final List<TextEditingController> _userName =
      List.generate(12, (index) => TextEditingController());
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final addressBox = GetStorage('address_box');

  Widget _customButton(title, _onPressed) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black)),
          onPressed: _onPressed,
          child: Text(title)),
    );
  }

  Future<void> login_func() async {
    Map data = {"password": _password.text};

    Map body = {"message": data};

    var response = await http.post(
      Uri.parse('http://localhost:8000/api/v1/auth/login'),
      body: jsonEncode(data),
      headers: {'Content-type': 'application/json'},
    ); //login url here

    if (response.statusCode == 200) {
      Get.snackbar('Login Successful', '');
      // jsonDecode(response.body);
      addressBox.erase();
      Get.to(() => const MyHomePage(), arguments: jsonDecode(response.body)
        
          );
      //successful operation
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
  }

  Future<void> signup_func() async {
    Map data = {
      "word1": _userName[0].text,
      "word2": _userName[1].text,
      "word3": _userName[2].text,
      "word4": _userName[3].text,
      "word5": _userName[4].text,
      "word6": _userName[5].text,
      "word7": _userName[6].text,
      "word8": _userName[7].text,
      "word9": _userName[8].text,
      "word10": _userName[9].text,
      "word11": _userName[10].text,
      "word12": _userName[11].text,
      'password': _password.text,
    };

    print(data);

    // Map body = {"message": data};

    var response = await http.post(
      Uri.parse('http://localhost:8000/api/v1/auth/signup'), //singup url here
      body: jsonEncode(data),
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Get.snackbar('Singup Successful', '');
      // response.body;
      // jsonDecode(response.body);
      addressBox.erase();
      Get.to(() => MyHomePage(), arguments: jsonDecode(response.body)
        
          );
      //successful operation
    } else if (response.statusCode == 404) {
      // print('not found');
      Get.snackbar('Not Found', '');
    } else if (response.statusCode == 422) {
    
      var error_details = jsonDecode(response.body);
      print(error_details);
      Get.snackbar("422 ${error_details['details']?[0]['type']}",
          "${error_details['details']?[0]['msg']} \n ${error_details['details']?[0]['loc']}");
    } else if (response.statusCode == 500) {
      // print('Internal Error');
      Get.snackbar('Internal Error', '');
    } else {
      // print('Error Occured. Try Again');
      Get.snackbar('Error Occured. Try Again', '');
    }
  }

  Future<void> showSignupDiaglog(_userNameValidatorFunc, _passValidatorFunc) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
              backgroundColor: const Color.fromARGB(255, 181, 144, 187),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 450,
                width: 550,
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 110,
                              childAspectRatio: 1.3,
                              crossAxisSpacing: 50,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: 12,
                            itemBuilder: (context, index) {
                              return TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _userName[index],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  focusColor: Colors.black,
                                  hintText: "Word ${index + 1}",
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 218, 184, 223),
                                ),
                                validator: _userNameValidatorFunc,
                                onSaved: (value) {
                                  _userName[index].text = value!;
                                },
                              );
                            }),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _password,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    contentPadding: const EdgeInsets.all(8),
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        255, 218, 184, 223),
                                  ),
                                  validator: _passValidatorFunc,
                                  onSaved: (value) {
                                    _password.text = value!;
                                  }),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Expanded(
                                child: _customButton("Submit", () {
                              if (_formKey.currentState!.validate()) {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => const LoginPage()));
                                signup_func();
                              }
                            }))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget showLoginDiaglog(_validatorFunc) {
    final TextEditingController _password = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: const Color.fromARGB(255, 181, 144, 187),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 450,
          width: 550,
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _password,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4)),
                      contentPadding: const EdgeInsets.all(8),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 218, 184, 223),
                    ),
                    validator: _validatorFunc,
                    onSaved: (value) {
                      _password.text = value!;
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: _customButton("Login", () {
                      if (_formKey.currentState!.validate()) {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const MyHomePage()));
                        login_func();
                        addressBox.erase();
                        //                    Get.to(() => MyHomePage(), arguments: {
                        //   "addressList": [
                        //     {
                        //       "address": "0xf8b4dFbEEeaffF2E317FFE502d439F174CF7B11a",
                        //       "balance": 3.5678,
                        //       "transactions": 12,
                        //       "tasklist": [
                        //         {
                        //           "id": "6d80ccef-fd63-40f1-909a-d318ae2d7452",
                        //           "contract": "0x84d6dfAa9d915fD675D075e91a27f484215Ad345",
                        //           "called": "notify",
                        //           "price": 0.1,
                        //           "option": false,
                        //           "time": "2022-03-26T14:21:26.939Z",
                        //           "status": "active"
                        //         }
                        //       ]
                        //     }
                        //   ],
                        //   "license_info": {
                        //     "license_address": "0xf8b4dFbEEeaffF2E317FFE502d439F174CF7B11a",
                        //     "expiration_time": "2022-03-26T14:21:26.939Z",
                        //     "image": "string"
                        //   }
                        // });
                      }
                    })),
                    const SizedBox(
                      width: 50,
                    ),
                    Expanded(
                        child: _customButton("Signup", () {
                      showSignupDiaglog((val) {
                        if (val!.isEmpty) {
                          return "Required*";
                        }
                      }, (val) {
                        if (val!.isEmpty) {
                          return "Please Must Enter Your Password";
                        }
                      });
                    }))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: showLoginDiaglog((val) {
      if (val!.isEmpty) {
        return "Please Must Enter Your Password";
      }
    }));
  }
}
