import 'package:coverlo/components/custom_text.dart';
import 'package:coverlo/components/sub_heading.dart';
import 'package:flutter/material.dart';

AlertDialog messageDialog(context, heading, text) {
  return AlertDialog(
    contentPadding: const EdgeInsets.only(
      left: 0,
      right: 0,
      bottom: 0,
      top: 0,
    ),
    backgroundColor: Colors.transparent,
    content: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
      ),
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
        top: 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          if (heading != '')
            SubHeading(
              headingText: heading,
              color: Colors.black,
            ),
          CustomText(text: text, color: Colors.black,),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    ),
  );
}
