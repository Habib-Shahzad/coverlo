import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/bloc_queue.dart';
import 'package:coverlo/blocs/body_type_bloc.dart';
import 'package:coverlo/blocs/make_bloc.dart';
import 'package:coverlo/blocs/model_bloc.dart';
import 'package:coverlo/blocs/product_bloc.dart';
import 'package:coverlo/blocs/tracking_company_bloc.dart';
import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/components/custom_text.dart';
import 'package:coverlo/components/form_sub_heading.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/form_fields/date_time_form_field.dart';
import 'package:coverlo/form_fields/drop_down_form_field.dart';
import 'package:coverlo/form_fields/radio_method.dart';
import 'package:coverlo/form_fields/slider_method.dart';
import 'package:coverlo/form_fields/text_form_field.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/helpers/dialogs/message_dialog.dart';
import 'package:coverlo/helpers/get_body_type_api.dart';
import 'package:coverlo/helpers/get_make_api.dart';
import 'package:coverlo/helpers/get_model_api.dart';
import 'package:coverlo/helpers/get_product_api.dart';
import 'package:coverlo/helpers/get_tracking_company_api.dart';
import 'package:coverlo/models/body_type_model.dart';
import 'package:coverlo/models/make_model.dart';
import 'package:coverlo/models/model_model.dart';
import 'package:coverlo/models/product_model.dart';
import 'package:coverlo/models/tracking_company_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/screens/form_step_3_screen/form_step_3_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coverlo/blocs/color_bloc.dart';
import 'package:coverlo/helpers/get_color_api.dart';
import 'package:coverlo/models/color_model.dart';

class Step2Form extends StatefulWidget {
  const Step2Form({
    Key? key,
  }) : super(key: key);

  @override
  State<Step2Form> createState() => _Step2FormState();
}

class _Step2FormState extends State<Step2Form> {
  final _formKey = GlobalKey<FormState>();
  String calculateButtonText = 'Calculate';
  String nextButtonText = 'Next';

  final int _minSeatingCapacity = 1;
  int _maxSeatingCapacity = 4;

  String _personalAccidentText = "Personal Accident For Drive +4 Passengers";

  final GlobalKey<FormFieldState> _productKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _vehicleMakeKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _vehicleVariantKey =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _vehicleModelKey =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _colorKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _bodyTypeKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _trackingCompanyKey =
      GlobalKey<FormFieldState>();

  late Bloc _productBloc;

  late Bloc _makeCarBloc;
  late Bloc _makeBikeBloc;

  // model is variant
  late Bloc _modelCarBloc;
  late Bloc _modelBikeBloc;

  // year is model
  late Bloc _bodyTypeBloc;
  late Bloc _trackingCompanyBloc;
  late Bloc _colorCarBloc;
  late Bloc _colorBikeBloc;

  List<DropdownMenuItem<Object>> _colorList = [];
  List<Map<String, String>> _colorListMap = [];

  List<DropdownMenuItem<Object>> _colorCarList = [];
  List<Map<String, String>> _colorCarListMap = [];

  List<DropdownMenuItem<Object>> _colorBikeList = [];
  List<Map<String, String>> _colorBikeListMap = [];

  List<DropdownMenuItem<Object>> _productList = [];
  List<Map<String, String>> _productListMap = [];

  List<DropdownMenuItem<Object>> _makeList = [];
  List<Map<String, String>> _makeListMap = [];

  List<DropdownMenuItem<Object>> _makeCarList = [];
  List<Map<String, String>> _makeCarListMap = [];

  List<DropdownMenuItem<Object>> _makeBikeList = [];
  List<Map<String, String>> _makeBikeListMap = [];

  ModelModel _variants = ModelModel(modelList: []);

  ModelModel _variantsCar = ModelModel(modelList: []);
  ModelModel _variantsBike = ModelModel(modelList: []);

  List<DropdownMenuItem<Object>> _variantList = [];
  List<Map<String, String>> _variantListMap = [];

  List<DropdownMenuItem<Object>> _modelList = [];
  List<Map<String, String>> _modelListMap = [];

  BodyTypeModel _bodyTypes = BodyTypeModel(bodyTypeList: []);
  List<Map<String, String>> _bodyTypeListMap = [];

  List<DropdownMenuItem<Object>> _trackingCompanyList = [];
  List<Map<String, String>> _trackingCompanyListMap = [];

  bool _variantReadOnly = true;
  bool _modelReadOnly = true;

  @override
  void initState() {
    super.initState();

    _productBloc = ProductBloc();

    _makeCarBloc = MakeBloc();
    _makeBikeBloc = MakeBloc();

    _modelCarBloc = ModelBloc();
    _modelBikeBloc = ModelBloc();

    _bodyTypeBloc = BodyTypeBloc();

    _colorCarBloc = ColorBloc();
    _colorBikeBloc = ColorBloc();

    _trackingCompanyBloc = TrackingCompanyBloc();
    StaticGlobal.blocs.addListener(checkBlocsQueue);
    getData();
  }

  @override
  void dispose() {
    StaticGlobal.blocs.removeListener(checkBlocsQueue);
    _productBloc.dispose();

    _makeCarBloc.dispose();
    _makeBikeBloc.dispose();

    _modelCarBloc.dispose();
    _modelBikeBloc.dispose();

    _colorCarBloc.dispose();
    _colorBikeBloc.dispose();
    _trackingCompanyBloc.dispose();
    super.dispose();
  }

  bool _trackingCompanyLoaded = false;

  bool _productLoaded = false;

  bool _modelCarLoaded = false;
  bool _modelBikeLoaded = false;

  bool _makeCarLoaded = false;
  bool _makeBikeLoaded = false;

  bool _colorCarLoaded = false;
  bool _colorBikeLoaded = false;

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    String deviceUniqueIdentifier =
        prefs.getString('deviceUniqueIdentifier') ?? '';
    String uniqueID = prefs.getString('uniqueID') ?? '';

    _productBloc.getStream.listen(productListener);

    _makeCarBloc.getStream.listen(makeCarListener);
    _makeBikeBloc.getStream.listen(makeBikeListener);

    _modelCarBloc.getStream.listen(modelCarListener);
    _modelBikeBloc.getStream.listen(modelBikeListener);

    _bodyTypeBloc.getStream.listen(bodyTypeListener);
    _trackingCompanyBloc.getStream.listen(trackingCompanyListener);

    _colorCarBloc.getStream.listen(colorCarListener);
    _colorBikeBloc.getStream.listen(colorBikeListener);

    getProductApi(_productBloc, uniqueID, deviceUniqueIdentifier);

    getColorApi(
        _colorCarBloc, uniqueID, deviceUniqueIdentifier, VehicleType.Car);
    getColorApi(_colorBikeBloc, uniqueID, deviceUniqueIdentifier,
        VehicleType.Motorcycle);

    getMakeApi(_makeCarBloc, uniqueID, deviceUniqueIdentifier, VehicleType.Car);
    getMakeApi(_makeBikeBloc, uniqueID, deviceUniqueIdentifier,
        VehicleType.Motorcycle);

    getModelApi(
        _modelCarBloc, uniqueID, deviceUniqueIdentifier, VehicleType.Car);
    getModelApi(_modelBikeBloc, uniqueID, deviceUniqueIdentifier,
        VehicleType.Motorcycle);

    getBodyTypeApi(_bodyTypeBloc, uniqueID, deviceUniqueIdentifier);
    getTrackingCompanyApi(
        _trackingCompanyBloc, uniqueID, deviceUniqueIdentifier);

    if (StaticGlobal.blocs.value.isNotEmpty) {
      PairBloc pairBloc = StaticGlobal.blocs.value.first;
      if (pairBloc.status == WAITING) {
        pairBloc.status = RUNNING;
        StaticGlobal.blocs.value.removeAt(0);
        StaticGlobal.blocs.value.insert(0, pairBloc);
        pairBloc.func();
      }
    }
  }

  bool initialStateBuild = false;
  bool dataSet = false;
  bool otherDataSet = false;

  bool productDataSet = false;
  bool makeDataSet = false;

  bool colorsInitialized = false;
  bool makeInitialized = false;
  bool modelInitialized = false;

  @override
  Widget build(BuildContext context) {
    if (_productLoaded && productNameController.text.isNotEmpty) {
      if (productIsCar(productNameController.text)) {
        if (!colorsInitialized) {
          if (_colorCarLoaded) {
            _colorList = _colorCarList;
            _colorListMap = _colorCarListMap;
            colorsInitialized = true;
          }
        }
        if (!makeInitialized) {
          if (_makeCarLoaded) {
            _makeList = _makeCarList;
            _makeListMap = _makeCarListMap;
            makeInitialized = true;
          }
        }
        if (!modelInitialized) {
          if (_modelCarLoaded) {
            _variants = _variantsCar;
            modelInitialized = true;
          }
        }

        if (!productDataSet &&
            colorsInitialized &&
            makeInitialized &&
            _modelCarLoaded) {
          setProductData(int.parse(productNameController.text),
              settingData: true);
          productDataSet = true;
        }
      } else {
        if (!colorsInitialized) {
          if (_colorBikeLoaded) {
            _colorList = _colorBikeList;
            _colorListMap = _colorBikeListMap;
            colorsInitialized = true;
          }
        }
        if (!makeInitialized) {
          if (_makeBikeLoaded) {
            _makeList = _makeBikeList;
            _makeListMap = _makeBikeListMap;
            makeInitialized = true;
          }
        }
        if (!modelInitialized) {
          if (_modelBikeLoaded) {
            _variants = _variantsBike;
            modelInitialized = true;
          }
        }

        if (!productDataSet &&
            colorsInitialized &&
            makeInitialized &&
            _modelBikeLoaded) {
          setProductData(int.parse(productNameController.text),
              settingData: true);
          productDataSet = true;
        }
      }
    }

    if (vehicleMakeController.text.isNotEmpty &&
        makeInitialized &&
        productDataSet &&
        !makeDataSet) {
      setMakeData(
        int.parse(vehicleMakeController.text),
        settingData: true,
      );
      makeDataSet = true;
    }

    // if (!makeDataSet && productNameController.text.isNotEmpty) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dropDownFormFieldMethod(
            context,
            _productKey,
            'Product',
            productValue,
            _productList,
            _productListMap,
            'productName',
            false,
            setProductData,
            controlled: true,
            dropDownValue: productNameController.text != ""
                ? int.parse(productNameController.text)
                : null,
          ),
          const SizedBox(height: kMinSpacing),
          const FormSubHeading(text: 'Applied For Registration'),
          const SizedBox(height: kMinSpacing),
          Row(
            children: [
              radioMethod(
                context,
                'Yes',
                'yes',
                appliedForRegistartion,
                setAppliedForRegistartion,
              ),
              const SizedBox(width: kMinSpacing),
              radioMethod(
                context,
                'Already Registered',
                'already registered',
                appliedForRegistartion,
                setAppliedForRegistartion,
              ),
            ],
          ),
          if (appliedForRegistartion != 'yes')
            const SizedBox(height: kMinSpacing),
          if (appliedForRegistartion != 'yes')
            textFormFieldMethod(
              context,
              'Registration No',
              registrationNoController,
              false,
              false,
              TextInputType.text,
            ),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(
            context,
            'Engine No',
            engineNoController,
            false,
            false,
            TextInputType.text,
          ),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(
            context,
            'Chasis No',
            chasisNoController,
            false,
            false,
            TextInputType.text,
          ),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
            context,
            _vehicleMakeKey,
            'Vehicle Make',
            vehicleMakeValue,
            _makeList,
            _makeListMap,
            'makeName',
            false,
            setMakeData,
            controlled: true,
            dropDownValue: vehicleMakeController.text != ""
                ? int.parse(vehicleMakeController.text)
                : null,
          ),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
            context,
            _vehicleVariantKey,
            'Vehicle Variant',
            vehicleVariantValue,
            _variantList,
            _variantListMap,
            'variantName',
            _variantReadOnly,
            setVariantData,
            controlled: true,
            dropDownValue: vehicleVariantController.text != ""
                ? int.parse(vehicleVariantController.text)
                : null,
          ),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
            context,
            _vehicleModelKey,
            'Vehicle Model',
            vehicleModelValue,
            _modelList,
            _modelListMap,
            'modelName',
            _modelReadOnly,
            setModelData,
            controlled: true,
            dropDownValue: vehicleModelController.text != ""
                ? int.parse(vehicleModelController.text)
                : null,
          ),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
            context,
            _colorKey,
            'Color',
            colorValue,
            _colorList,
            _colorListMap,
            'colorName',
            !_colorCarLoaded,
            setColorData,
            controlled: true,
            dropDownValue: colorController.text != ""
                ? int.parse(colorController.text)
                : null,
          ),
          // const SizedBox(height: kMinSpacing),
          // dropDownFormFieldMethod(
          //   context,
          //   _bodyTypeKey,
          //   'Body Type',
          //   bodyTypeValue,
          //   _bodyTypeList,
          //   _bodyTypeListMap,
          //   'bodyTypeName',
          //   _bodyTypeReadOnly,
          //   setBodyTypeData,
          //   controlled: true,
          //   dropDownValue: bodyTypeController.text != ""
          //       ? int.parse(bodyTypeController.text)
          //       : null,
          // ),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(
            context,
            'Cubic Capacity/Bhp/Torque',
            cubicCapacityController,
            false,
            false,
            TextInputType.text,
          ),
          const SizedBox(height: kMinSpacing),
          FormSubHeading(text: 'Seating Capacity: ${seatingCapacity.ceil()}'),
          const SizedBox(height: kMinSpacing),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _minSeatingCapacity.toString(),
                  style: const TextStyle(
                    color: kFormSubHeadingColor,
                    fontWeight: FontWeight.w500,
                    fontSize: kFormSubHeadingFontSize,
                  ),
                ),
                Text(
                  _maxSeatingCapacity.toString(),
                  style: const TextStyle(
                    color: kFormSubHeadingColor,
                    fontWeight: FontWeight.w500,
                    fontSize: kFormSubHeadingFontSize,
                  ),
                ),
              ],
            ),
          ),
          sliderThemeMethod(
            context,
            seatingCapacity,
            setSeatingCapacity,
            _minSeatingCapacity,
            _maxSeatingCapacity,
          ),

          productValue == thirdParty
              ? const SizedBox()
              : const FormSubHeading(text: 'Tracker Installed'),

          productValue == thirdParty
              ? const SizedBox()
              : const CustomText(
                  text: '(For Motor Cars Only)', color: kFormSubHeadingColor),

          productValue == thirdParty
              ? const SizedBox()
              : const SizedBox(height: kMinSpacing),

          productValue == thirdParty
              ? const SizedBox()
              : Row(
                  children: [
                    radioMethod(
                      context,
                      'Yes',
                      'yes',
                      trackerInstalled,
                      setTrackerInstalled,
                    ),
                    const SizedBox(width: kMinSpacing),
                    radioMethod(
                      context,
                      'No',
                      'no',
                      trackerInstalled,
                      setTrackerInstalled,
                    ),
                  ],
                ),

          const SizedBox(height: kMinSpacing),

          productValue == thirdParty
              ? const SizedBox()
              : showTrackers
                  ? dropDownFormFieldMethod(
                      context,
                      _trackingCompanyKey,
                      'Tracking Company',
                      trackingCompanyValue,
                      _trackingCompanyList,
                      _trackingCompanyListMap,
                      'trackingCompanyName',
                      false,
                      setTrackingCompanyData,
                      controlled: true,
                      dropDownValue: trackingCompanyController.text != ""
                          ? int.parse(trackingCompanyController.text)
                          : null,
                    )
                  : const SizedBox(),

          productValue == thirdParty
              ? const SizedBox()
              : const SizedBox(height: kMinSpacing),

          productValue == thirdParty
              ? const SizedBox()
              : const CustomText(
                  text: '(For Motor Cars Only)', color: kFormSubHeadingColor),

          productValue == thirdParty
              ? const SizedBox()
              : const SizedBox(height: kMinSpacing),

          productValue == thirdParty
              ? const SizedBox()
              : const FormSubHeading(text: 'Additional Accessories'),

          productValue == thirdParty
              ? const SizedBox()
              : const SizedBox(height: kMinSpacing),

          productValue == thirdParty
              ? const SizedBox()
              : Row(
                  children: [
                    radioMethod(
                      context,
                      'Yes',
                      'yes',
                      additionalAccessories,
                      setAdditionalAccessories,
                    ),
                    const SizedBox(width: kMinSpacing),
                    radioMethod(
                      context,
                      'No',
                      'no',
                      additionalAccessories,
                      setAdditionalAccessories,
                    ),
                  ],
                ),
          const CustomText(
              text: '(For Motor Cars Only)', color: kFormSubHeadingColor),
          const SizedBox(height: kMinSpacing),
          FormSubHeading(text: _personalAccidentText),
          const SizedBox(height: kMinSpacing),
          Row(
            children: [
              radioMethod(
                context,
                'Yes',
                'yes',
                personalAccidentValue,
                setPersonalAccident,
              ),
              const SizedBox(width: kMinSpacing),
              radioMethod(
                context,
                'No',
                'no',
                personalAccidentValue,
                setPersonalAccident,
              ),
            ],
          ),
          const SizedBox(height: kMinSpacing),
          const FormSubHeading(text: 'Period of Insurance'),
          const SizedBox(height: kMinSpacing),
          Row(
            children: [
              const Text(
                'From',
                style: TextStyle(
                  color: kFormSubHeadingColor,
                  fontWeight: FontWeight.w500,
                  fontSize: kFormSubHeadingFontSize,
                ),
              ),
              const SizedBox(width: kMinSpacing),
              Expanded(
                child: dateTimeFormFieldMethod(
                  context,
                  '17-09-2022',
                  setFromInsuranceDate,
                  disabledValue: insurancePeriodIssueDate,
                  disabled: true,
                ),
              ),
              const SizedBox(width: kMinSpacing),
              const Text(
                'To',
                style: TextStyle(
                  color: kFormSubHeadingColor,
                  fontWeight: FontWeight.w500,
                  fontSize: kFormSubHeadingFontSize,
                ),
              ),
              const SizedBox(width: kMinSpacing),
              Expanded(
                child: dateTimeFormFieldMethod(
                  context,
                  '16-09-2023',
                  setToInsuranceDate,
                  disabled: true,
                  disabledValue: insurancePeriodExpiryDate,
                ),
              ),
            ],
          ),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(
              context,
              'Insured Estimated Value',
              insuredEstimatedValueController,
              true,
              false,
              TextInputType.number),
          const SizedBox(height: kMinSpacing),
          CustomButton(
            buttonText: calculateButtonText,
            onPressed: () {
              try {
                String productName = productValue!;
                String year = vehicleModelValue!;
                String vehcileMake = vehicleMakeValue!;

                String hasTracker = trackerInstalled;
                String personalAccident = personalAccidentValue;
                double carEstimatedValue = double.parse(
                    insuredEstimatedValueController.text
                        .replaceAll(',', '')
                        .trim());

                double estimatedValue = 0;

                final DateTime now = DateTime.now();
                final int currentYear = now.year;

                int personalAccidentAmount =
                    personalAccident == 'yes' ? 1200 : 0;
                int yearsOld = currentYear - int.parse(year);

                if (productName == privateCar) {
                  if (yearsOld <= 5) {
                    if (hasTracker == 'yes') {
                      estimatedValue = carEstimatedValue * (1.75 / 100);
                    } else {
                      estimatedValue = carEstimatedValue * (1.5 / 100);
                    }
                    estimatedValue = estimatedValue + personalAccidentAmount;
                    contributionController.text =
                        estimatedValue.toStringAsFixed(2);
                  } else if (yearsOld > 5 && yearsOld <= 15) {
                    estimatedValue = carEstimatedValue * (1.5 / 100);
                    estimatedValue = estimatedValue + personalAccidentAmount;
                    contributionController.text =
                        estimatedValue.toStringAsFixed(2);
                  } else {
                    AlertDialog alert = messageDialog(
                        context,
                        'Error',
                        'The model of the vehicle is greater than 15 years. '
                            'Please contact the administrator.');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }
                } else if (productName == thirdParty) {
                  if (yearsOld <= 10) {
                    String cubicCapacity = cubicCapacityController.text;
                    cubicCapacity = cubicCapacity.replaceAll(RegExp(r'\D'), '');
                    int cubicCapacityInt = int.parse(cubicCapacity);

                    if (cubicCapacityInt < 1000) {
                      estimatedValue = estimatedValue + 1500;
                      contributionController.text =
                          estimatedValue.toStringAsFixed(2);
                    } else if (cubicCapacityInt >= 1000 &&
                        cubicCapacityInt <= 2000) {
                      estimatedValue = estimatedValue + 1500;
                      contributionController.text =
                          estimatedValue.toStringAsFixed(2);
                    } else if (cubicCapacityInt > 2000 &&
                        cubicCapacityInt <= 3500) {
                      estimatedValue = estimatedValue + 2500;
                      contributionController.text =
                          estimatedValue.toStringAsFixed(2);
                    } else {
                      AlertDialog alert = messageDialog(
                          context,
                          'Error',
                          'The cubic capacity is greater than 3500. '
                              'Please contact the administrator.');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    }
                  } else {
                    AlertDialog alert = messageDialog(
                        context,
                        'Error',
                        'The model of the vehicle is greater than 10 years. '
                            'Please contact the administrator.');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }
                } else if (productName == motorCycle) {
                  if (yearsOld <= 5) {
                    if (vehcileMake.toLowerCase().contains('honda')) {
                      estimatedValue = carEstimatedValue * (10 / 100);
                    } else {
                      estimatedValue = carEstimatedValue * (8 / 100);
                    }
                    contributionController.text =
                        estimatedValue.toStringAsFixed(2);
                  } else {
                    AlertDialog alert = messageDialog(
                        context,
                        'Error',
                        'The model of the vehicle is greater than 5 years. '
                            'Please contact the administrator.');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  }
                } else {
                  AlertDialog alert = messageDialog(
                      context,
                      'Error',
                      'The product name is not valid. '
                          'Please contact the administrator.');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                }
              } catch (e) {
                AlertDialog alert = messageDialog(
                    context, 'Error', 'Please fill all the fields');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              }
            },
            buttonColor: kSecondaryColor,
          ),
          const SizedBox(height: kMinSpacing),
          const FormSubHeading(text: 'Contribution (Premium)'),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(
            context,
            '-',
            contributionController,
            true,
            true,
            TextInputType.number,
          ),
          const SizedBox(height: kMinSpacing),
          CustomButton(
            buttonText: nextButtonText,
            onPressed: () {
              if (contributionController.text.isNotEmpty) {
                Navigator.pushNamed(context, FormStep3Screen.routeName,
                    arguments: {
                      'contribution': contributionController.text,
                      'productName': productValue,
                    });
              } else {
                AlertDialog alert = messageDialog(
                    context, 'Error', 'Please calculate the contribution');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              }
            },
            buttonColor: kSecondaryColor,
          ),
          const SizedBox(height: kSpacingBottom),
        ],
      ),
    );
  }

  productListener(Response response) {
    if (response.status == Status.COMPLETED) {
      List<DropdownMenuItem<Object>> items = [];
      List<Map<String, String>> products = [];
      ProductModel productModel = response.data as ProductModel;
      for (var i = 0; i < productModel.productList.length; i++) {
        items.add(
          DropdownMenuItem(
              value: i,
              child: Text(
                productModel.productList[i].productName,
                overflow: TextOverflow.ellipsis,
              )),
        );
        products.add({
          'productCode': productModel.productList[i].productCode,
          'productName': productModel.productList[i].productName,
          'productID': i.toString()
        });
      }

      setState(() {
        _productList = items;
        _productListMap = products;
        _productLoaded = true;
      });
    } else if (response.status == Status.ERROR) {
      AlertDialog alert = messageDialog(context, 'Error', response.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  makeCarListener(Response response) {
    if (response.status == Status.COMPLETED) {
      List<DropdownMenuItem<Object>> items = [];
      List<Map<String, String>> makes = [];
      MakeModel makeModel = response.data as MakeModel;

      List<MakeResponse> makeList = makeModel.makeList;

      for (var i = 0; i < makeList.length; i++) {
        items.add(
          DropdownMenuItem(
              value: i, child: Text(makeModel.makeList[i].makeName)),
        );
        makes.add({
          'makeName': makeModel.makeList[i].makeName,
          'makeCode': makeModel.makeList[i].makeCode,
          'makeID': i.toString()
        });
      }

      setState(() {
        _makeCarList = items;
        _makeCarListMap = makes;
        _makeCarLoaded = true;
      });
    } else if (response.status == Status.ERROR) {
      AlertDialog alert = messageDialog(context, 'Error', response.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  makeBikeListener(Response response) {
    if (response.status == Status.COMPLETED) {
      List<DropdownMenuItem<Object>> items = [];
      List<Map<String, String>> makes = [];
      MakeModel makeModel = response.data as MakeModel;

      List<MakeResponse> makeList = makeModel.makeList;

      // (**DEBUG**) REMOVE THIS LINE TO SHOW ALL COLORS
      // makeList.removeRange(0, 3);

      for (var i = 0; i < makeList.length; i++) {
        items.add(
          DropdownMenuItem(
              value: i, child: Text(makeModel.makeList[i].makeName)),
        );
        makes.add({
          'makeName': makeModel.makeList[i].makeName,
          'makeCode': makeModel.makeList[i].makeCode,
          'makeID': i.toString()
        });
      }
      setState(() {
        _makeBikeList = items;
        _makeBikeListMap = makes;
        _makeBikeLoaded = true;
      });
    } else if (response.status == Status.ERROR) {
      AlertDialog alert = messageDialog(context, 'Error', response.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  modelCarListener(Response response) {
    if (response.status == Status.COMPLETED) {
      ModelModel modelModel = response.data as ModelModel;

      setState(() {
        _variantsCar = modelModel;
        _modelCarLoaded = true;
      });
    } else if (response.status == Status.ERROR) {
      AlertDialog alert = messageDialog(context, 'Error', response.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  modelBikeListener(Response response) {
    if (response.status == Status.COMPLETED) {
      ModelModel modelModel = response.data as ModelModel;

      // (**DEBUG**) REMOVE THIS LINE TO SHOW ALL COLORS
      // modelModel.modelList.removeRange(0, 3);

      setState(() {
        _variantsBike = modelModel;
        _modelBikeLoaded = true;
      });
    } else if (response.status == Status.ERROR) {
      AlertDialog alert = messageDialog(context, 'Error', response.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  bodyTypeListener(Response response) {
    if (response.status == Status.COMPLETED) {
      BodyTypeModel bodyTypeModel = response.data as BodyTypeModel;
      setState(() {
        _bodyTypes = bodyTypeModel;
      });
    } else if (response.status == Status.ERROR) {
      AlertDialog alert = messageDialog(context, 'Error', response.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  trackingCompanyListener(Response response) {
    if (response.status == Status.COMPLETED) {
      List<DropdownMenuItem<Object>> items = [];
      List<Map<String, String>> trackingCompanies = [];
      TrackingCompanyModel trackingCompanyModel =
          response.data as TrackingCompanyModel;
      for (var i = 0;
          i < trackingCompanyModel.trackingCompanyList.length;
          i++) {
        items.add(
          DropdownMenuItem(
              value: i,
              child: Text(trackingCompanyModel
                  .trackingCompanyList[i].trackingCompanyName)),
        );
        trackingCompanies.add({
          'trackingCompanyCode':
              trackingCompanyModel.trackingCompanyList[i].trackingCompanyCode,
          'trackingCompanyName':
              trackingCompanyModel.trackingCompanyList[i].trackingCompanyName,
          'trackingCompanyID': i.toString()
        });
      }
      setState(() {
        _trackingCompanyList = items;
        _trackingCompanyListMap = trackingCompanies;
        _trackingCompanyLoaded = true;
      });
    } else if (response.status == Status.ERROR) {
      AlertDialog alert = messageDialog(context, 'Error', response.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  colorCarListener(Response response) {
    if (response.status == Status.COMPLETED) {
      List<DropdownMenuItem<Object>> items = [];
      List<Map<String, String>> colors = [];
      ColorModel colorModel = response.data as ColorModel;
      for (var i = 0; i < colorModel.colorList.length; i++) {
        items.add(
          DropdownMenuItem(
              value: i, child: Text(colorModel.colorList[i].colorName)),
        );
        colors.add({
          'colorCode': colorModel.colorList[i].colorCode,
          'colorName': colorModel.colorList[i].colorName,
          'colorID': i.toString()
        });
      }

      setState(() {
        _colorCarList = items;
        _colorCarListMap = colors;
        _colorCarLoaded = true;
      });
    } else if (response.status == Status.ERROR) {
      AlertDialog alert = messageDialog(context, 'Error', response.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  colorBikeListener(Response response) {
    if (response.status == Status.COMPLETED) {
      List<DropdownMenuItem<Object>> items = [];
      List<Map<String, String>> colors = [];
      ColorModel colorModel = response.data as ColorModel;

      List<ColorResponse> colorList = colorModel.colorList;

      // (**DEBUG**) REMOVE THIS LINE TO SHOW ALL COLORS
      // colorList.removeRange(0, 3);

      for (var i = 0; i < colorList.length; i++) {
        items.add(
          DropdownMenuItem(
              value: i, child: Text(colorModel.colorList[i].colorName)),
        );
        colors.add({
          'colorName': colorModel.colorList[i].colorName,
          'colorID': i.toString()
        });
      }
      setState(() {
        _colorBikeList = items;
        _colorBikeListMap = colors;
        _colorBikeLoaded = true;
      });
    } else if (response.status == Status.ERROR) {
      AlertDialog alert = messageDialog(context, 'Error', response.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  bool productIsCar(Object? value) {
    String productName = _productListMap.firstWhere(
        (element) => element['productID'] == value.toString())['productName']!;

    return productName.toLowerCase().contains('car');
  }

  setProductData(Object? value, {bool settingData = false}) async {
    String? dataIndex = _productKey.currentState?.value.toString();

    if (dataIndex != null) {
      productNameController.text = dataIndex;
    }

    if (!settingData) {
      contributionController.text = "";

      _vehicleMakeKey.currentState?.reset();
      _vehicleVariantKey.currentState?.reset();
      _vehicleModelKey.currentState?.reset();
      _colorKey.currentState?.reset();

      colorController.text = "";
      colorValue = null;

      vehicleMakeController.text = "";
      vehicleMakeValue = null;

      vehicleModelController.text = "";
      vehicleModelValue = null;

      vehicleVariantController.text = "";
      vehicleVariantValue = null;

      setState(() {
        seatingCapacity = 1;
      });
    }

    var product = _productListMap
        .firstWhere((element) => element['productID'] == value.toString());
    String productName = product['productName']!;
    String productCode = product['productCode']!;

    int maxCap = 0;

    int numYears = 0;

    if (productName.toLowerCase().contains('car')) {
      maxCap = 4;

      numYears = 10;

      _variants = _variantsCar;

      _makeList = _makeCarList;
      _makeListMap = _makeCarListMap;

      _colorList = _colorCarList;
      _colorListMap = _colorCarListMap;

      _personalAccidentText = "Personal Accident For Drive +4 Passengers";
    } else {
      maxCap = 2;

      numYears = 5;

      _variants = _variantsBike;

      _makeList = _makeBikeList;
      _makeListMap = _makeBikeListMap;

      _colorList = _colorBikeList;
      _colorListMap = _colorBikeListMap;

      _personalAccidentText = "Personal Accident For Driver + 1 Passenger";
    }

    final List<DropdownMenuItem<Object>> newModelList = [];
    final List<Map<String, String>> newModelListMap = [];

    for (int i = 0; i < numYears; i++) {
      String dateYear = (DateTime.now().year - i).toString();
      newModelList.add(DropdownMenuItem(value: i, child: Text(dateYear)));
      newModelListMap.add({'value': i.toString(), 'label': dateYear});
    }

    setState(() {
      productValue = productName;
      productCodeValue = productCode;
      _maxSeatingCapacity = maxCap;
      _modelList = newModelList;
      _modelListMap = newModelListMap;
      _modelReadOnly = false;
    });
  }

  setAppliedForRegistartion(String value) {
    setState(() {
      appliedForRegistartion = value;
    });
  }

  setMakeData(Object? value, {settingData = false}) {
    String? dataIndex = _vehicleMakeKey.currentState?.value.toString();

    if (dataIndex != null) {
      vehicleMakeController.text = dataIndex;
    }

    String makeName = _makeListMap.firstWhere(
        (element) => element['makeID'] == value.toString())['makeName']!;

    List<DropdownMenuItem<Object>> items = [];
    List<Map<String, String>> models = [];

    for (var i = 0; i < _variants.modelList.length; i++) {
      if (makeName == _variants.modelList[i].makeName) {
        items.add(
          DropdownMenuItem(
              value: i, child: Text(_variants.modelList[i].modelName)),
        );
        models.add({
          'variantCode': _variants.modelList[i].modelCode,
          'variantName': _variants.modelList[i].modelName,
          'makeName': _variants.modelList[i].makeName,
          'variantID': i.toString()
        });
      }
    }

    if (!settingData) {
      vehicleVariantController.text = "";
      vehicleVariantValue = null;

      vehicleModelController.text = "";
      vehicleModelValue = null;

      bodyTypeController.text = "";
      bodyTypeValue = null;
    }

    _vehicleVariantKey.currentState?.reset();
    _vehicleModelKey.currentState?.reset();
    _bodyTypeKey.currentState?.reset();

    setState(() {
      vehicleMakeValue = makeName;

      _variantReadOnly = false;
      _variantList = items;
      _variantListMap = models;

      _bodyTypeListMap = [];
      bodyTypeValue = null;
    });
  }

  // model is variant
  setVariantData(Object? value, {settingData = false}) {
    String? dataIndex = _vehicleVariantKey.currentState?.value.toString();

    if (dataIndex != null) {
      vehicleVariantController.text = dataIndex;
    }

    var variant = _variantListMap
        .firstWhere((element) => element['variantID'] == value.toString());

    String variantName = variant['variantName']!;
    String variantCode = variant['variantCode']!;

    List<DropdownMenuItem<Object>> bodyTypeItems = [];
    List<Map<String, String>> bodyTypes = [];
    for (var i = 0; i < _bodyTypes.bodyTypeList.length; i++) {
      if (variantName == _bodyTypes.bodyTypeList[i].modelName) {
        bodyTypeItems.add(
          DropdownMenuItem(
              value: i, child: Text(_bodyTypes.bodyTypeList[i].bodyType)),
        );
        bodyTypes.add({
          'bodyType': _bodyTypes.bodyTypeList[i].bodyType,
          'modelName': _bodyTypes.bodyTypeList[i].modelName,
          'bodyTypeID': i.toString()
        });
      }
    }

    if (!settingData) {
      vehicleModelController.text = "";
      bodyTypeController.text = "";
    }

    _vehicleModelKey.currentState?.reset();
    _bodyTypeKey.currentState?.reset();
    setState(() {
      vehcileMakeCodeValue = variantCode;
      vehicleVariantValue = variantName;

      vehicleModelValue = null;

      _bodyTypeListMap = bodyTypes;
      bodyTypeValue = null;
    });
  }

  setBodyTypeData(Object? value) {
    String? dataIndex = _bodyTypeKey.currentState?.value.toString();

    if (dataIndex != null) {
      bodyTypeController.text = dataIndex;
    }

    String bodyTypeName = _bodyTypeListMap.firstWhere(
        (element) => element['bodyTypeID'] == value.toString())['bodyType']!;

    setState(() {
      bodyTypeValue = bodyTypeName;
    });
  }

  setTrackingCompanyData(Object? value) {
    String? dataIndex = _trackingCompanyKey.currentState?.value.toString();

    if (dataIndex != null) {
      trackingCompanyController.text = dataIndex;
    }

    String trackingCompanyCode = _trackingCompanyListMap.firstWhere((element) =>
        element['trackingCompanyID'] ==
        value.toString())['trackingCompanyCode']!;

    setState(() {
      trackingCompanyValue = trackingCompanyCode;
    });
  }

  setColorData(Object? value) {
    String? dataIndex = _colorKey.currentState?.value.toString();
    if (dataIndex != null) {
      colorController.text = dataIndex;
    }

    String colorCode = _colorCarListMap.firstWhere(
        (element) => element['colorID'] == value.toString())['colorCode']!;

    setState(() {
      colorValue = colorCode;
    });
  }

  setModelData(Object? value) {
    String? dataIndex = _vehicleModelKey.currentState?.value.toString();

    if (dataIndex != null) {
      vehicleModelController.text = dataIndex;
    }

    String modelName = (_modelListMap.firstWhere(
        (element) => element['value'] == value.toString())['label']) as String;

    setState(() {
      vehicleModelValue = modelName;
    });
  }

  setSeatingCapacity(double value) {
    setState(() {
      seatingCapacity = value;
    });
  }

  setTrackerInstalled(String value) {
    setState(() {
      trackerInstalled = value;
    });
    if (value == "yes") {
      setState(() {
        showTrackers = true;
      });
    } else {
      setState(() {
        showTrackers = false;
      });
    }
  }

  setAdditionalAccessories(String value) {
    setState(() {
      additionalAccessories = value;
    });
  }

  setPersonalAccident(String value) {
    setState(() {
      personalAccidentValue = value;
    });
  }

  setFromInsuranceDate(DateTime? value) {
    setState(() {});
  }

  setToInsuranceDate(DateTime? value) {}
}
