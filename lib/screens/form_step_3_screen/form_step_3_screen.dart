import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/components/navigate_button.dart';
import 'package:coverlo/components/sub_heading.dart';
import 'package:coverlo/constants.dart';

import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/screens/payment_screen/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../components/custom_button.dart';

class VehicleImageComponent extends StatelessWidget {
  final String? imageName;
  final String? imageAssetPath;
  final XFile? imageValue;
  final Function()? setImage;
  final Function()? removeImage;

  const VehicleImageComponent({
    Key? key,
    required this.imageName,
    required this.imageValue,
    required this.setImage,
    required this.removeImage,
    required this.imageAssetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.4,
          width: MediaQuery.of(context).size.width * 0.4,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: imageValue == null
                      ? AssetImage(imageAssetPath!)
                      : FileImage(File(imageValue!.path)) as ImageProvider),
            ),
          ),
        ),
        imageValue == null
            ? const SizedBox()
            : Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: removeImage,
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
        imageValue == null
            ? Positioned.fill(
                child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 40.0,
                        width: 40.0,
                        child: IconButton(
                          padding: const EdgeInsets.all(0.0),
                          icon: const Icon(
                            Icons.add_circle_outline,
                            size: 40.0,
                            color: Colors.black,
                          ),
                          onPressed: setImage,
                        )),
                    Text(
                      imageName!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          backgroundColor: Colors.white),
                    ),
                  ],
                ),
              ))
            : const SizedBox(),
      ],
    );
  }
}

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
  bool isCar = true;

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      if (args['productName'].toLowerCase().contains('car')) {
        setState(() {
          isCar = true;
        });
      } else {
        setState(() {
          isCar = false;
        });
      }

      setState(() {
        contribution = args['contribution'];
        productName = args['productName'];

        loaded = true;
      });
    }

    return MainLayout(
      body: loaded == true
          ? SizedBox(
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
                        child: isCar == true
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      VehicleImageComponent(
                                          imageName: 'Front',
                                          imageValue: imageCarFront,
                                          setImage: _pickCarFrontImage,
                                          removeImage: _removeCarFrontImage,
                                          imageAssetPath:
                                              "assets/images/car_front.png"),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                      ),
                                      VehicleImageComponent(
                                          imageName: 'Back',
                                          imageValue: imageCarBack,
                                          setImage: _pickCarBackImage,
                                          removeImage: _removeCarBackImage,
                                          imageAssetPath:
                                              "assets/images/car_back.png"),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      VehicleImageComponent(
                                          imageName: 'Left',
                                          imageValue: imageCarLeft,
                                          setImage: _pickCarLeftImage,
                                          removeImage: _removeCarLeftImage,
                                          imageAssetPath:
                                              "assets/images/car_left.png"),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                      ),
                                      VehicleImageComponent(
                                          imageName: 'Right',
                                          imageValue: imageCarRight,
                                          setImage: _pickCarRightImage,
                                          removeImage: _removeCarRightImage,
                                          imageAssetPath:
                                              "assets/images/car_right.png"),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      VehicleImageComponent(
                                          imageName: 'Hood',
                                          imageValue: imageCarHood,
                                          setImage: _pickCarHoodImage,
                                          removeImage: _removeCarHoodImage,
                                          imageAssetPath:
                                              "assets/images/car_hood.png"),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                      ),
                                      VehicleImageComponent(
                                          imageName: 'Boot',
                                          imageValue: imageCarBoot,
                                          setImage: _pickCarBootImage,
                                          removeImage: _removeCarBootImage,
                                          imageAssetPath:
                                              "assets/images/car_boot.png"),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      VehicleImageComponent(
                                          imageName: 'Front Picture',
                                          imageValue: imageBikeFront,
                                          setImage: _pickBikeFrontImage,
                                          removeImage: _removeBikeFrontImage,
                                          imageAssetPath:
                                              "assets/images/bike_front.png"),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                      ),
                                      VehicleImageComponent(
                                          imageName: 'Back Picture',
                                          imageValue: imageBikeBack,
                                          setImage: _pickBikeBackImage,
                                          removeImage: _removeBikeBackImage,
                                          imageAssetPath:
                                              "assets/images/bike_back.png"),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      VehicleImageComponent(
                                          imageName: 'Left Picture',
                                          imageValue: imageBikeLeft,
                                          setImage: _pickBikeLeftImage,
                                          removeImage: _removeBikeLeftImage,
                                          imageAssetPath:
                                              "assets/images/bike_left.png"),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                      ),
                                      VehicleImageComponent(
                                          imageName: 'Right Picture',
                                          imageValue: imageBikeRight,
                                          setImage: _pickBikeRightImage,
                                          removeImage: _removeBikeRightImage,
                                          imageAssetPath:
                                              "assets/images/bike_right.png"),
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
            )
          : const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

// SET CAR IMAGES
  _setCarFrontImage(value) {
    setState(() {
      imageCarFront = value;
    });
  }

  _setCarBackImage(value) {
    setState(() {
      imageCarBack = value;
    });
  }

  _setCarLeftImage(value) {
    setState(() {
      imageCarLeft = value;
    });
  }

  _setCarRightImage(value) {
    setState(() {
      imageCarRight = value;
    });
  }

  _setCarHoodImage(value) {
    setState(() {
      imageCarHood = value;
    });
  }

  _setCarBootImage(value) {
    setState(() {
      imageCarBoot = value;
    });
  }

  // SET CAR BYTES

  _setCarFrontBytes(value) {
    setState(() {
      bytesCarFront = value;
    });
  }

  _setCarBackBytes(value) {
    setState(() {
      bytesCarBack = value;
    });
  }

  _setCarLeftBytes(value) {
    setState(() {
      bytesCarLeft = value;
    });
  }

  _setCarRightBytes(value) {
    setState(() {
      bytesCarRight = value;
    });
  }

  _setCarHoodBytes(value) {
    setState(() {
      bytesCarHood = value;
    });
  }

  _setCarBootBytes(value) {
    setState(() {
      bytesCarBoot = value;
    });
  }

  _removeCarFrontImage() {
    setState(() {
      imageCarFront = null;
    });
  }

  _removeCarBackImage() {
    setState(() {
      imageCarBack = null;
    });
  }

  _removeCarLeftImage() {
    setState(() {
      imageCarLeft = null;
    });
  }

  _removeCarRightImage() {
    setState(() {
      imageCarRight = null;
    });
  }

  _removeCarHoodImage() {
    setState(() {
      imageCarHood = null;
    });
  }

  _removeCarBootImage() {
    setState(() {
      imageCarBoot = null;
    });
  }

  // ADD BIKE FUNCTIONS
  _setBikeFrontImage(value) {
    setState(() {
      imageBikeFront = value;
    });
  }

  _setBikeBackImage(value) {
    setState(() {
      imageBikeBack = value;
    });
  }

  _setBikeLeftImage(value) {
    setState(() {
      imageBikeLeft = value;
    });
  }

  _setBikeRightImage(value) {
    setState(() {
      imageBikeRight = value;
    });
  }

  _setBikeFrontBytes(value) {
    setState(() {
      bytesBikeFront = value;
    });
  }

  _setBikeBackBytes(value) {
    setState(() {
      bytesBikeBack = value;
    });
  }

  _setBikeLeftBytes(value) {
    setState(() {
      bytesBikeLeft = value;
    });
  }

  _setBikeRightBytes(value) {
    setState(() {
      bytesBikeRight = value;
    });
  }

  // REMOVE BIKE FUNCTIONS

  _removeBikeFrontImage() {
    setState(() {
      imageBikeFront = null;
      bytesBikeFront = null;
    });
  }

  _removeBikeBackImage() {
    setState(() {
      imageBikeBack = null;
      bytesBikeBack = null;
    });
  }

  _removeBikeLeftImage() {
    setState(() {
      imageBikeLeft = null;
      bytesBikeLeft = null;
    });
  }

  _removeBikeRightImage() {
    setState(() {
      imageBikeRight = null;
      bytesBikeRight = null;
    });
  }

  _pickCarFrontImage() async {
    _pickImage(_setCarFrontImage, _setCarFrontBytes);
  }

  _pickCarBackImage() {
    _pickImage(_setCarBackImage, _setCarBackBytes);
  }

  _pickCarLeftImage() {
    _pickImage(_setCarLeftImage, _setCarLeftBytes);
  }

  _pickCarRightImage() {
    _pickImage(_setCarRightImage, _setCarRightBytes);
  }

  _pickCarHoodImage() {
    _pickImage(_setCarHoodImage, _setCarHoodBytes);
  }

  _pickCarBootImage() {
    _pickImage(_setCarBootImage, _setCarBootBytes);
  }

  _pickBikeFrontImage() {
    _pickImage(_setBikeFrontImage, _setBikeFrontBytes);
  }

  _pickBikeBackImage() {
    _pickImage(_setBikeBackImage, _setBikeBackBytes);
  }

  _pickBikeLeftImage() {
    _pickImage(_setBikeLeftImage, _setBikeLeftBytes);
  }

  _pickBikeRightImage() {
    _pickImage(_setBikeRightImage, _setBikeRightBytes);
  }

  _pickImage(Function setImageFunction, Function setBytesFunction) async {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context, ImageSource.camera);
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    ).then((source) async {
      if (source != null) {
        final pickedFile = await ImagePicker().getImage(source: source);
        final bytes = await pickedFile!.readAsBytes();
        setBytesFunction(bytes);
        setImageFunction(XFile(pickedFile.path));
      }
    });
  }
}
