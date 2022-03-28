import 'package:dashboard_app/address_summary_section.dart';
import 'package:dashboard_app/tab_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import'package:get_storage/get_storage.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

      var args = Get.arguments;
      final addressBox = GetStorage('address_box');
      var _selectedAddress = '';

      @override
      void initState() {
        super.initState();
        _boxlistener();
      }

      Future<void> _boxlistener() async {
        addressBox.listen(() {
          setState(() {
            if(addressBox.read('selected_address') != null){
              _selectedAddress = addressBox.read('selected_address');
            }      
          });
        });
      }

  final BoxDecoration _boxDecoration = BoxDecoration(
      color: const Color.fromARGB(255, 181, 144, 187),
      borderRadius: BorderRadius.circular(10));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                //  Grid Layout
                const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: AddressSummarySection(),
                    )),
                Expanded(
                  flex: 6,
                  child: Container(
                      decoration: _boxDecoration, child: 
                      _selectedAddress.isEmpty?
                      const Center(
                        child: Text(
                          'No Address Selected',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                        ),
                      )
                      :
                      const TabPanel()
                      ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
