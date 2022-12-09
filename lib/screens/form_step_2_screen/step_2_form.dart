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

  final GlobalKey<FormFieldState> _productKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _vehicleMakeKey = GlobalKey<FormFieldState>();

  String? _vehicleVariantValue;
  final GlobalKey<FormFieldState> _vehicleVariantKey =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _vehicleModelKey =
      GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _colorKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _bodyTypeKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _trackingCompanyKey =
      GlobalKey<FormFieldState>();

  DateTime insurancePeriodFrom = DateTime.now();

  late Bloc _productBloc;
  late Bloc _makeBloc;

  // model is variant
  late Bloc _modelBloc;
  // year is model
  late Bloc _bodyTypeBloc;
  late Bloc _trackingCompanyBloc;
  late Bloc _colorBloc;

  List<DropdownMenuItem<Object>> _colorList = [];
  List<Map<String, String>> _colorListMap = [];

  List<DropdownMenuItem<Object>> _productList = [];
  List<Map<String, String>> _productListMap = [];

  List<DropdownMenuItem<Object>> _makeList = [];
  List<Map<String, String>> _makeListMap = [];

  ModelModel _variants = ModelModel(modelList: []);
  List<DropdownMenuItem<Object>> _variantList = [];
  List<Map<String, String>> _variantListMap = [];

  final List<DropdownMenuItem<Object>> _modelList = [];
  final List<Map<String, String>> _modelListMap = [];

  BodyTypeModel _bodyTypes = BodyTypeModel(bodyTypeList: []);
  List<Map<String, String>> _bodyTypeListMap = [];

  List<DropdownMenuItem<Object>> _trackingCompanyList = [];
  List<Map<String, String>> _trackingCompanyListMap = [];

  bool _variantReadOnly = true;
  bool _modelReadOnly = true;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 15; i++) {
      String dateYear = (DateTime.now().year - i).toString();
      _modelList.add(DropdownMenuItem(value: i, child: Text(dateYear)));
      _modelListMap.add({'value': i.toString(), 'label': dateYear});
    }

    _productBloc = ProductBloc();
    _makeBloc = MakeBloc();
    _modelBloc = ModelBloc();
    _bodyTypeBloc = BodyTypeBloc();
    _colorBloc = ColorBloc();
    _trackingCompanyBloc = TrackingCompanyBloc();
    StaticGlobal.blocs.addListener(checkBlocsQueue);
    getData();
  }

  @override
  void dispose() {
    StaticGlobal.blocs.removeListener(checkBlocsQueue);
    _productBloc.dispose();
    _makeBloc.dispose();
    _modelBloc.dispose();
    _colorBloc.dispose();
    _trackingCompanyBloc.dispose();
    super.dispose();
  }

  bool _makeLoaded = false;
  bool _modelLoaded = false;
  bool _trackingCompanyLoaded = false;
  bool _colorLoaded = false;

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    String deviceUniqueIdentifier =
        prefs.getString('deviceUniqueIdentifier') ?? '';
    String uniqueID = prefs.getString('uniqueID') ?? '';

    _productBloc.getStream.listen(productListener);
    _makeBloc.getStream.listen(makeListener);
    _modelBloc.getStream.listen(modelListener);
    _bodyTypeBloc.getStream.listen(bodyTypeListener);
    _trackingCompanyBloc.getStream.listen(trackingCompanyListener);
    _colorBloc.getStream.listen(colorListener);

    getProductApi(_productBloc, uniqueID, deviceUniqueIdentifier);
    getMakeApi(_makeBloc, uniqueID, deviceUniqueIdentifier);
    getModelApi(_modelBloc, uniqueID, deviceUniqueIdentifier);
    getBodyTypeApi(_bodyTypeBloc, uniqueID, deviceUniqueIdentifier);
    getTrackingCompanyApi(
        _trackingCompanyBloc, uniqueID, deviceUniqueIdentifier);

    getColorApi(_colorBloc, uniqueID, deviceUniqueIdentifier);

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

  bool dataSet = false;
  bool otherDataSet = false;

  @override
  Widget build(BuildContext context) {
    if (_colorLoaded && _trackingCompanyLoaded && !otherDataSet) {
      if (colorController.text.isNotEmpty) {
        setColorData(int.parse(colorController.text));
      }
      if (trackingCompanyController.text.isNotEmpty) {
        setTrackingCompanyData(int.parse(trackingCompanyController.text));
      }

      setState(() {
        otherDataSet = true;
      });
    }

    if (_makeLoaded && _modelLoaded && !dataSet) {
      if (productNameController.text.isNotEmpty) {
        setProductData(int.parse(productNameController.text),
            settingData: true);
      }

      if (vehicleMakeController.text.isNotEmpty) {
        setMakeData(int.parse(vehicleMakeController.text), settingData: true);
      }

      if (vehicleVariantController.text.isNotEmpty) {
        setVariantData(int.parse(vehicleVariantController.text),
            settingData: true);
      }

      if (vehicleModelController.text.isNotEmpty) {
        setModelData(int.parse(vehicleModelController.text));
      }

      setState(() {
        dataSet = true;
      });
    }

    if (!dataSet) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
            _vehicleVariantValue,
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
            false,
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
          const CustomText(
              text: '(For Motor Cars Only)', color: kFormSubHeadingColor),
          const SizedBox(height: kMinSpacing),
          const FormSubHeading(text: 'Tracker Installed'),
          const SizedBox(height: kMinSpacing),
          Row(
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
          showTrackers
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

          const SizedBox(height: kMinSpacing),
          const CustomText(
              text: '(For Motor Cars Only)', color: kFormSubHeadingColor),
          const SizedBox(height: kMinSpacing),
          const FormSubHeading(text: 'Additional Accessories'),
          const SizedBox(height: kMinSpacing),
          Row(
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
          const FormSubHeading(
              text: 'Personal Accident For Drive +4 Passengers'),
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
                  disabledValue: insurancePeriodFrom,
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
                  disabledValue:
                      insurancePeriodFrom.add(const Duration(days: 364)),
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

                if (productName == 'Private Motor Car - Comprehensive') {
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
                } else if (productName ==
                    'Private Motor Car - Third Party Liability (TPL)') {
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
                } else if (productName ==
                    'Private Motor Cycle - TPL+Total Loss+Theft') {
                  if (yearsOld <= 5) {
                    if (vehcileMake.toLowerCase().contains('honda')) {
                      estimatedValue = carEstimatedValue * (10 / 1000);
                    } else {
                      estimatedValue = estimatedValue * (8 / 100);
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
          'productName': productModel.productList[i].productName,
          'productID': i.toString()
        });
      }
      setState(() {
        _productList = items;
        _productListMap = products;
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

  makeListener(Response response) {
    if (response.status == Status.COMPLETED) {
      List<DropdownMenuItem<Object>> items = [];
      List<Map<String, String>> makes = [];
      MakeModel makeModel = response.data as MakeModel;
      for (var i = 0; i < makeModel.makeList.length; i++) {
        items.add(
          DropdownMenuItem(
              value: i, child: Text(makeModel.makeList[i].makeName)),
        );
        makes.add({
          'makeName': makeModel.makeList[i].makeName,
          'makeID': i.toString()
        });
      }
      setState(() {
        _makeList = items;
        _makeListMap = makes;
        _makeLoaded = true;
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

  modelListener(Response response) {
    if (response.status == Status.COMPLETED) {
      ModelModel modelModel = response.data as ModelModel;
      setState(() {
        _variants = modelModel;
        _modelLoaded = true;
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

  colorListener(Response response) {
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
          'colorName': colorModel.colorList[i].colorName,
          'colorID': i.toString()
        });
      }
      setState(() {
        _colorList = items;
        _colorListMap = colors;
        _colorLoaded = true;
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

  setProductData(Object? value, {bool settingData = false}) {
    String? dataIndex = _productKey.currentState?.value.toString();

    if (dataIndex != null) {
      productNameController.text = dataIndex;
    }

    if (!settingData) {
      contributionController.text = "";
      setState(() {
        seatingCapacity = 1;
      });
    }

    String productName = _productListMap.firstWhere(
        (element) => element['productID'] == value.toString())['productName']!;

    int maxCap = 0;

    if (productName.toLowerCase().contains('car')) {
      maxCap = 4;
    } else {
      maxCap = 2;
    }

    setState(() {
      productValue = productName;
      _maxSeatingCapacity = maxCap;
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
          'variantName': _variants.modelList[i].modelName,
          'makeName': _variants.modelList[i].makeName,
          'variantID': i.toString()
        });
      }
    }

    if (!settingData) {
      vehicleVariantController.text = "";
      vehicleModelController.text = "";
      bodyTypeController.text = "";
    }

    _vehicleVariantKey.currentState?.reset();
    _vehicleModelKey.currentState?.reset();
    _bodyTypeKey.currentState?.reset();
    setState(() {
      vehicleMakeValue = makeName;

      _variantReadOnly = false;
      _variantList = items;
      _variantListMap = models;
      _vehicleVariantValue = null;

      vehicleModelValue = null;
      _modelReadOnly = true;

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

    String variantName = _variantListMap.firstWhere(
        (element) => element['variantID'] == value.toString())['variantName']!;

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
      _vehicleVariantValue = variantName;

      vehicleModelValue = null;
      _modelReadOnly = false;

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

    String trackingCompanyName = _trackingCompanyListMap.firstWhere((element) =>
        element['trackingCompanyID'] ==
        value.toString())['trackingCompanyName']!;

    setState(() {
      trackingCompanyValue = trackingCompanyName;
    });
  }

  setColorData(Object? value) {
    String? dataIndex = _colorKey.currentState?.value.toString();
    if (dataIndex != null) {
      colorController.text = dataIndex;
    }

    String colorName = _colorListMap.firstWhere(
        (element) => element['colorID'] == value.toString())['colorName']!;

    setState(() {
      colorValue = colorName;
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
    setState(() {
      insurancePeriodFrom = value!;
    });
  }

  setToInsuranceDate(DateTime? value) {}
}
