import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

BoxDecoration boxDecoration = BoxDecoration(
    color: const Color.fromARGB(255, 218, 184, 223),
    borderRadius: BorderRadius.circular(4));

Widget customTextField(context, title, data) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: (title == 'Date')
              ? BoxDecoration(
                  color: const Color.fromARGB(255, 181, 144, 187),
                  borderRadius: BorderRadius.circular(4))
              : boxDecoration,
          padding: const EdgeInsets.all(11.3),
          child: RichText(
              text: TextSpan(
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            text: "$data",
          )),
        ),
      ],
    ),
  );
}

Widget customTextFormField(
    context, title, controllerName, validationFunc, onSavedFunc) {
  var wSize = MediaQuery.of(context).size.width;
  var hSize = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Container(
          width: wSize,
          height: hSize * 6 / 100,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 181, 144, 187),
              borderRadius: BorderRadius.circular(4)),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorColor: const Color.fromARGB(255, 218, 184, 223),
            decoration: const InputDecoration(
              errorStyle: TextStyle(color: Colors.black),
              contentPadding: EdgeInsets.all(8),
              border: InputBorder.none,
            ),
            // keyboardType: (title == "Price") ?
            // TextInputType.number : TextInputType.text,
            // inputFormatters: (title == "Price")
            //     ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            //     : null,
            controller: controllerName,
            validator: validationFunc,
            onSaved: onSavedFunc,
          ),
        ),
      ],
    ),
  );
}
