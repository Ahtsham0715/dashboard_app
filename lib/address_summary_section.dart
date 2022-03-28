import 'package:dashboard_app/custom_textfield.dart';
import 'package:dashboard_app/service_summary_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddressSummarySection extends StatefulWidget {
  const AddressSummarySection({Key? key}) : super(key: key);

  @override
  State<AddressSummarySection> createState() => _AddressSummarySectionState();
}

class _AddressSummarySectionState extends State<AddressSummarySection> {

  var args = Get.arguments;
  final addressBox = GetStorage('address_box');
  double balance = 2500;
  int transactions = 5;
  List? _registeredAddresses ;
 
  String? _selectedAddress;
  Map? _selectedAddressdata;

  final TextStyle _textStyle =
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 15);
  final BoxDecoration _boxDecoration = BoxDecoration(
      color: const Color.fromARGB(255, 181, 144, 187),
      borderRadius: BorderRadius.circular(10));

  @override
  Widget build(BuildContext context) {
    _registeredAddresses = args['addressList'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            decoration: _boxDecoration,
            child: addressSummary(context),
          ),
        ),
        // Service Summary Section
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              decoration: _boxDecoration,
              child: ServiceSummarySection(selectedAddress: _selectedAddress),
            ),
          ),
        )
      ],
    );
  }

// Address Summary Section
  Padding addressSummary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          Container(
            decoration: boxDecoration,
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  hint: Text(
                    "Select Your Account Address",
                    style: _textStyle,
                  ),
                  value: _selectedAddress,
                  isExpanded: true,
                  items: _registeredAddresses?.map(
                    (e) {
                      return DropdownMenuItem(
                        value: e['address'],
                        child: Text(
                          e['address'],
                          style: _textStyle,
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAddress = newValue as String;
                      addressBox.write('selected_address', _selectedAddress);
                      _registeredAddresses?.forEach((address) {
                        if(address['address'] == _selectedAddress){
                          _selectedAddressdata = address;
                        }
                        addressBox.write('address_data', address);
                      });
                      setState(() {
                        
                      });
                    });
                  },
                ),
              ),
            ),
          ),
          (_selectedAddress == null)
              ? const Spacer()
              : Expanded(
                  child: ListView(
                    children: [
                      customTextField(context, "Balance", "${_selectedAddressdata?['balance']}\$"),
                      customTextField(
                          context, "Number Of Transaction", _selectedAddressdata?['transactions']),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
