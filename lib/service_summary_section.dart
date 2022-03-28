import 'package:dashboard_app/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart' as intl;

class ServiceSummarySection extends StatefulWidget {
  final String? selectedAddress;
  const ServiceSummarySection({Key? key, @required this.selectedAddress})
      : super(key: key);

  @override
  State<ServiceSummarySection> createState() => _ServiceSummarySectionState();
}

class _ServiceSummarySectionState extends State<ServiceSummarySection> {
  bool license = true;
  int licenseNumber = 12345789;
  var args = Get.arguments;
  Map? license_data;
  final addressBox = GetStorage('address_box');
  @override
  Widget build(BuildContext context) {
    license_data = args['license_info'];
    if(license_data  != null){
      license = true;
    }else{
      license = false;
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        children: [
          (widget.selectedAddress == null)
              ? Container()
              : Expanded(
                  child: ListView(
                    children: [
                      customTextField(context, "License", "$license"),
                      customTextField(
                          context, "License Number", "${license? license_data!['license_address'] : ''}"),
                      customTextField(
                          context,
                          "Valid To",
                          license ?
                          license_data!['expiration_time'] : ''
                      ),
                          // intl.DateFormat.yMd()
                          //     .add_jm()
                          //     .format(DateTime.now())),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
