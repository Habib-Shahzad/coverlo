import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/components/navigate_button.dart';
import 'package:coverlo/components/sub_heading.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/screens/payment_screen/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../components/custom_button.dart';

class FormStep3Screen extends StatefulWidget {
  static const String routeName = '/form_step_3_screen';

  const FormStep3Screen({
    Key? key,
  }) : super(key: key);

  @override
  State<FormStep3Screen> createState() => _FormStep3ScreenState();
}

class _FormStep3ScreenState extends State<FormStep3Screen> {
  bool loaded = false;
  String? contribution;
  String? productName;

  XFile? _imageFront;
  XFile? _imageBack;
  XFile? _imageLeft;
  XFile? _imageRight;
  XFile? _imageHood;
  XFile? _imageBoot;

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        contribution = args['contribution'];
        productName = args['productName'];

        print(productName);

        loaded = true;
      });
    }

    return MainLayout(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding / 2,
          ),
          decoration: const BoxDecoration(color: kBackgroundColor),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                  ),
                  child: Row(
                    children: [
                      NavigateButton(
                          text: 'Step 1',
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          color: kStepButtonColor),
                      const Expanded(
                        child: Divider(
                          color: kStepButtonColor,
                          thickness: 4,
                        ),
                      ),
                      NavigateButton(
                        text: 'Step 2',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: kStepButtonColor,
                      ),
                      const Expanded(
                        child: Divider(
                          color: kStepButtonColor,
                          thickness: 4,
                        ),
                      ),
                      const NavigateButton(
                        text: 'Step 3',
                        onPressed: null,
                        color: kStepButtonActiveColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kDefaultSpacing),
                const MainHeading(
                    headingText: 'Motor Vehicle Cover',
                    color: kDarkTextColor,
                    fontWeight: FontWeight.w600),
                const SizedBox(height: kDefaultSpacing),
                const Align(
                  alignment: Alignment.topLeft,
                  child: SubHeading(
                    headingText: 'Vehicle Pictures',
                    color: kDarkTextColor,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: _imageFront == null
                                            ? const AssetImage(
                                                "assets/images/car_front.png")
                                            : FileImage(File(_imageFront!.path))
                                                as ImageProvider),
                                  ),
                                ),
                              ),
                              _imageFront == null
                                  ? const SizedBox()
                                  : Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _imageFront = null;
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                              _imageFront == null
                                  ? Positioned.fill(
                                      child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 40.0,
                                              width: 40.0,
                                              child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  size: 40.0,
                                                  color: Colors.black,
                                                ),
                                                onPressed: _setImageFront,
                                              )),
                                          const Text(
                                            'Front',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                backgroundColor: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ))
                                  : const SizedBox(),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                          ),
                          Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: _imageBack == null
                                            ? const AssetImage(
                                                "assets/images/car_front.png")
                                            : FileImage(File(_imageBack!.path))
                                                as ImageProvider),
                                  ),
                                ),
                              ),
                              _imageBack == null
                                  ? const SizedBox()
                                  : Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _imageBack = null;
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                              _imageBack == null
                                  ? Positioned.fill(
                                      child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 40.0,
                                              width: 40.0,
                                              child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  size: 40.0,
                                                  color: Colors.black,
                                                ),
                                                onPressed: _setImageBack,
                                              )),
                                          const Text(
                                            'Back',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                backgroundColor: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ))
                                  : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: _imageLeft == null
                                            ? const AssetImage(
                                                "assets/images/car_front.png")
                                            : FileImage(File(_imageLeft!.path))
                                                as ImageProvider),
                                  ),
                                ),
                              ),
                              _imageLeft == null
                                  ? const SizedBox()
                                  : Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _imageLeft = null;
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                              _imageLeft == null
                                  ? Positioned.fill(
                                      child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 40.0,
                                              width: 40.0,
                                              child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  size: 40.0,
                                                  color: Colors.black,
                                                ),
                                                onPressed: _setImageLeft,
                                              )),
                                          const Text(
                                            'Left',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                backgroundColor: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ))
                                  : const SizedBox(),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                          ),
                          Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: _imageRight == null
                                            ? const AssetImage(
                                                "assets/images/car_front.png")
                                            : FileImage(File(_imageRight!.path))
                                                as ImageProvider),
                                  ),
                                ),
                              ),
                              _imageRight == null
                                  ? const SizedBox()
                                  : Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _imageRight = null;
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                              _imageRight == null
                                  ? Positioned.fill(
                                      child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 40.0,
                                              width: 40.0,
                                              child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  size: 40.0,
                                                  color: Colors.black,
                                                ),
                                                onPressed: _setImageRight,
                                              )),
                                          const Text(
                                            'Right',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                backgroundColor: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ))
                                  : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: _imageHood == null
                                            ? const AssetImage(
                                                "assets/images/car_front.png")
                                            : FileImage(File(_imageHood!.path))
                                                as ImageProvider),
                                  ),
                                ),
                              ),
                              _imageHood == null
                                  ? const SizedBox()
                                  : Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _imageHood = null;
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                              _imageHood == null
                                  ? Positioned.fill(
                                      child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 40.0,
                                              width: 40.0,
                                              child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  size: 40.0,
                                                  color: Colors.black,
                                                ),
                                                onPressed: _setImageHood,
                                              )),
                                          const Text(
                                            'Hood',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                backgroundColor: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ))
                                  : const SizedBox(),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                          ),
                          Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: _imageBoot == null
                                            ? const AssetImage(
                                                "assets/images/car_front.png")
                                            : FileImage(File(_imageBoot!.path))
                                                as ImageProvider),
                                  ),
                                ),
                              ),
                              _imageBoot == null
                                  ? const SizedBox()
                                  : Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _imageBoot = null;
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                              _imageBoot == null
                                  ? Positioned.fill(
                                      child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 40.0,
                                              width: 40.0,
                                              child: IconButton(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  size: 40.0,
                                                  color: Colors.black,
                                                ),
                                                onPressed: _setImageBoot,
                                              )),
                                          const Text(
                                            'Boot',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                backgroundColor: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ))
                                  : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  buttonText: "Submit and Pay",
                  onPressed: () {
                    
                    Navigator.pushNamed(
                      context,
                      PaymentScreen.routeName,
                      arguments: {"contribution": contribution},
                    );
                  },
                  buttonColor: kSecondaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _openGallery() async {
    XFile? imageFile;
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return imageFile;
  }

  _setImageFront() {
    _openGallery().then((value) {
      setState(() {
        _imageFront = value;
      });
    });
  }

  _setImageBack() {
    _openGallery().then((value) {
      setState(() {
        _imageBack = value;
      });
    });
  }

  _setImageLeft() {
    _openGallery().then((value) {
      setState(() {
        _imageLeft = value;
      });
    });
  }

  _setImageRight() {
    _openGallery().then((value) {
      setState(() {
        _imageRight = value;
      });
    });
  }

  _setImageHood() {
    _openGallery().then((value) {
      setState(() {
        _imageHood = value;
      });
    });
  }

  _setImageBoot() {
    _openGallery().then((value) {
      setState(() {
        _imageBoot = value;
      });
    });
  }
}
