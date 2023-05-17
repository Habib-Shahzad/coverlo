import 'package:coverlo/components/main_heading.dart';
import 'package:coverlo/components/step_navigator.dart';
import 'package:coverlo/components/sub_heading.dart';
import 'package:coverlo/constants.dart';

import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/helpers/image_operations.dart';
import 'package:coverlo/layouts/main_layout.dart';
import 'package:coverlo/respository/insurance_repository.dart';
import 'package:coverlo/screens/form_step_3_screen/vehicle_image.dart';
import 'package:coverlo/screens/payment_screen/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coverlo/components/custom_button.dart';

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

  bool carFrontLoading = false;
  bool carBackLoading = false;
  bool carLeftLoading = false;
  bool carRightLoading = false;
  bool carHoodLoading = false;
  bool carBootLoading = false;

  bool bikeFrontLoading = false;
  bool bikeBackLoading = false;
  bool bikeLeftLoading = false;
  bool bikeRightLoading = false;

  bool generatingInsurance = false;

  bool isLoading() {
    if (generatingInsurance) {
      return true;
    }

    if (isCar) {
      return carFrontLoading ||
          carBackLoading ||
          carLeftLoading ||
          carRightLoading ||
          carHoodLoading ||
          carBootLoading;
    } else {
      return bikeFrontLoading ||
          bikeBackLoading ||
          bikeLeftLoading ||
          bikeRightLoading;
    }
  }

  InsuranceRepository insuranceRepository = InsuranceRepository();

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      if (args['productName'] == privateCar ||
          args['productName'] == thirdParty) {
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
                      stepNavigatorComponent(
                        step3Color: kStepButtonActiveColor,
                        onPressedStep1: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        onPressedStep2: () {
                          Navigator.pop(context);
                        },
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
                                            "assets/images/car_front.png",
                                        imageLoading: carFrontLoading,
                                      ),
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
                                              "assets/images/car_back.png",
                                          imageLoading: carBackLoading),
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
                                              "assets/images/car_left.png",
                                          imageLoading: carLeftLoading),
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
                                              "assets/images/car_right.png",
                                          imageLoading: carRightLoading),
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
                                              "assets/images/car_hood.png",
                                          imageLoading: carHoodLoading),
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
                                              "assets/images/car_boot.png",
                                          imageLoading: carBootLoading),
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
                                              "assets/images/bike_front.png",
                                          imageLoading: bikeFrontLoading),
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
                                              "assets/images/bike_back.png",
                                          imageLoading: bikeBackLoading),
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
                                              "assets/images/bike_left.png",
                                          imageLoading: bikeLeftLoading),
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
                                              "assets/images/bike_right.png",
                                          imageLoading: bikeRightLoading),
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
                        onPressed: () async {
                          bool success = await generateInsurance();
                          if (success) navigateToPayment();
                        },
                        buttonColor: kSecondaryColor,
                        disabled: isLoading(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (generatingInsurance)
                        const CircularProgressIndicator(),
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

  generateInsurance() async {
    bool loading = isLoading();
    if (loading) return;

    if (sessionInsuranceId == null) {
      setState(() {
        generatingInsurance = true;
      });

      List images = getImages(productValue);
      int? insuranceID = await insuranceRepository.sendInsuranceRequest(images);

      // if (insuranceID == null) return false;

      sessionInsuranceId = insuranceID;

      setState(() {
        generatingInsurance = false;
      });
    }

    return true;
  }

  navigateToPayment() {
    if (context.mounted) {
      Navigator.pushNamed(
        context,
        PaymentScreen.routeName,
        arguments: {"contribution": contribution},
      );
    }
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
      bytesCarFront = null;
      imageCarFront = null;
    });
  }

  _removeCarBackImage() {
    setState(() {
      bytesCarBack = null;
      imageCarBack = null;
    });
  }

  _removeCarLeftImage() {
    setState(() {
      bytesCarLeft = null;
      imageCarLeft = null;
    });
  }

  _removeCarRightImage() {
    setState(() {
      bytesCarRight = null;
      imageCarRight = null;
    });
  }

  _removeCarHoodImage() {
    setState(() {
      bytesCarHood = null;
      imageCarHood = null;
    });
  }

  _removeCarBootImage() {
    setState(() {
      bytesCarBoot = null;
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

  setCarFrontLoading(bool loading) {
    setState(() {
      carFrontLoading = loading;
    });
  }

  setCarBackLoading(bool loading) {
    setState(() {
      carBackLoading = loading;
    });
  }

  setCarLeftLoading(bool loading) {
    setState(() {
      carLeftLoading = loading;
    });
  }

  setCarRightLoading(bool loading) {
    setState(() {
      carRightLoading = loading;
    });
  }

  setCarHoodLoading(bool loading) {
    setState(() {
      carHoodLoading = loading;
    });
  }

  setCarBootLoading(bool loading) {
    setState(() {
      carBootLoading = loading;
    });
  }

  setBikeFrontLoading(bool loading) {
    setState(() {
      bikeFrontLoading = loading;
    });
  }

  setBikeBackLoading(bool loading) {
    setState(() {
      bikeBackLoading = loading;
    });
  }

  setBikeLeftLoading(bool loading) {
    setState(() {
      bikeLeftLoading = loading;
    });
  }

  setBikeRightLoading(bool loading) {
    setState(() {
      bikeRightLoading = loading;
    });
  }

  _pickCarFrontImage() async {
    _pickImage(_setCarFrontImage, _setCarFrontBytes, setCarFrontLoading);
  }

  _pickCarBackImage() {
    _pickImage(_setCarBackImage, _setCarBackBytes, setCarBackLoading);
  }

  _pickCarLeftImage() {
    _pickImage(_setCarLeftImage, _setCarLeftBytes, setCarLeftLoading);
  }

  _pickCarRightImage() {
    _pickImage(_setCarRightImage, _setCarRightBytes, setCarRightLoading);
  }

  _pickCarHoodImage() {
    _pickImage(_setCarHoodImage, _setCarHoodBytes, setCarHoodLoading);
  }

  _pickCarBootImage() {
    _pickImage(_setCarBootImage, _setCarBootBytes, setCarBootLoading);
  }

  _pickBikeFrontImage() {
    _pickImage(_setBikeFrontImage, _setBikeFrontBytes, setBikeFrontLoading);
  }

  _pickBikeBackImage() {
    _pickImage(_setBikeBackImage, _setBikeBackBytes, setBikeBackLoading);
  }

  _pickBikeLeftImage() {
    _pickImage(_setBikeLeftImage, _setBikeLeftBytes, setBikeLeftLoading);
  }

  _pickBikeRightImage() {
    _pickImage(_setBikeRightImage, _setBikeRightBytes, setBikeRightLoading);
  }

  _pickImage(Function setImageFunction, Function setBytesFunction,
      Function setLoading) async {
    setLoading(true);

    void navigateBack(BuildContext context) {
      setLoading(false);
      Navigator.pop(context);
    }

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
                onPressed: () => navigateBack(context),
              ),
            ),
          ],
        ),
      ),
    ).then((source) async {
      if (source != null) {
        // ignore: deprecated_member_use
        final pickedFile = await ImagePicker().getImage(source: source);
        final bytes = await pickedFile!.readAsBytes();
        final resizedBytes = imageBytesResize(bytes);

        setBytesFunction(resizedBytes);
        setImageFunction(XFile(pickedFile.path));

        setLoading(false);
      } else {
        setLoading(false);
      }
    });
  }
}
