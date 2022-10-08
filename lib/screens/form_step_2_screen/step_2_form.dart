import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/bloc_queue.dart';
import 'package:coverlo/blocs/body_type_bloc.dart';
import 'package:coverlo/blocs/make_bloc.dart';
import 'package:coverlo/blocs/model_bloc.dart';
import 'package:coverlo/blocs/product_bloc.dart';
import 'package:coverlo/blocs/tracking_company_bloc.dart';
import 'package:coverlo/blocs/year_bloc.dart';
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
import 'package:coverlo/helpers/dialogs/message_dialog.dart';
import 'package:coverlo/helpers/get_body_type_api.dart';
import 'package:coverlo/helpers/get_make_api.dart';
import 'package:coverlo/helpers/get_model_api.dart';
import 'package:coverlo/helpers/get_product_api.dart';
import 'package:coverlo/helpers/get_tracking_company_api.dart';
import 'package:coverlo/helpers/get_year_api.dart';
import 'package:coverlo/models/body_type_model.dart';
import 'package:coverlo/models/make_model.dart';
import 'package:coverlo/models/model_model.dart';
import 'package:coverlo/models/product_model.dart';
import 'package:coverlo/models/tracking_company_model.dart';
import 'package:coverlo/models/year_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/screens/form_step_3_screen/form_step_3_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Step2Form extends StatefulWidget {
  const Step2Form({Key? key}) : super(key: key);

  @override
  State<Step2Form> createState() => _Step2FormState();
}

class _Step2FormState extends State<Step2Form> {
  final _formKey = GlobalKey<FormState>();
  String calculateButtonText = 'Calculate';
  String nextButtonText = 'Next';

  // final TextEditingController _productController = TextEditingController();
  String? _productValue;
  final GlobalKey<FormFieldState> _productKey = GlobalKey<FormFieldState>();
  String _appliedForRegistartion = 'yes';
  final TextEditingController _engineNoController = TextEditingController();
  final TextEditingController _chasisNoController = TextEditingController();
  String? _vehicleMakeValue;
  final GlobalKey<FormFieldState> _vehicleMakeKey = GlobalKey<FormFieldState>();
  String? _vehicleVariantValue;
  final GlobalKey<FormFieldState> _vehicleVariantKey =
      GlobalKey<FormFieldState>();
  String? _vehicleModelValue;
  final GlobalKey<FormFieldState> _vehicleModelKey =
      GlobalKey<FormFieldState>();
  final TextEditingController _colorController = TextEditingController();
  String? _bodyTypeValue;
  final GlobalKey<FormFieldState> _bodyTypeKey = GlobalKey<FormFieldState>();
  final TextEditingController _cubicCapacityController =
      TextEditingController();
  double _seatingCapacity = 1;
  final int _minSeatingCapacity = 1;
  final int _maxSeatingCapacity = 4;
  String _trackerInstalled = 'yes';
  String? _trackingCompanyValue;
  final GlobalKey<FormFieldState> _trackingCompanyKey =
      GlobalKey<FormFieldState>();

  String _additionalAccessories = 'no';
  String _personalAccident = 'yes';
  // DateTime? _fromInsuranceDate;
  // DateTime? _toInsuranceDate;
  final TextEditingController _insuranceEstimatedValueController =
      TextEditingController();
  final TextEditingController _contributionController = TextEditingController();

  late Bloc _productBloc;
  late Bloc _makeBloc;
  // model is variant
  late Bloc _modelBloc;
  // year is model
  late Bloc _yearBloc;
  late Bloc _bodyTypeBloc;
  late Bloc _trackingCompanyBloc;

  List<DropdownMenuItem<Object>> _productList = [];
  List<Map<String, String>> _productListMap = [];

  List<DropdownMenuItem<Object>> _makeList = [];
  List<Map<String, String>> _makeListMap = [];

  ModelModel _variants = ModelModel(modelList: []);
  List<DropdownMenuItem<Object>> _variantList = [];
  List<Map<String, String>> _variantListMap = [];

  YearModel _models = YearModel(yearList: []);
  List<DropdownMenuItem<Object>> _modelList = [];
  List<Map<String, String>> _modelListMap = [];

  BodyTypeModel _bodyTypes = BodyTypeModel(bodyTypeList: []);
  List<DropdownMenuItem<Object>> _bodyTypeList = [];
  List<Map<String, String>> _bodyTypeListMap = [];

  List<DropdownMenuItem<Object>> _trackingCompanyList = [];
  List<Map<String, String>> _trackingCompanyListMap = [];

  bool _variantReadOnly = true;
  bool _modelReadOnly = true;
  bool _bodyTypeReadOnly = true;

  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc();
    _makeBloc = MakeBloc();
    _modelBloc = ModelBloc();
    _yearBloc = YearBloc();
    _bodyTypeBloc = BodyTypeBloc();
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
    _yearBloc.dispose();
    _trackingCompanyBloc.dispose();
    super.dispose();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    String deviceUniqueIdentifier =
        prefs.getString('deviceUniqueIdentifier') ?? '';
    String uniqueID = prefs.getString('uniqueID') ?? '';

    _productBloc.getStream.listen(productListener);
    _makeBloc.getStream.listen(makeListener);
    _modelBloc.getStream.listen(modelListener);
    _yearBloc.getStream.listen(yearListener);
    _bodyTypeBloc.getStream.listen(bodyTypeListener);
    _trackingCompanyBloc.getStream.listen(trackingCompanyListener);

    getProductApi(_productBloc, uniqueID, deviceUniqueIdentifier);
    getMakeApi(_makeBloc, uniqueID, deviceUniqueIdentifier);
    getModelApi(_modelBloc, uniqueID, deviceUniqueIdentifier);
    getYearApi(_yearBloc, uniqueID, deviceUniqueIdentifier);
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // dropDownFormFieldMethod(
          //     context,
          //     _productKey,
          //     'Product',
          //     _productValue,
          //     _productList,
          //     _productListMap,
          //     'productName',
          //     false,
          //     setProductData),
          // const SizedBox(height: kMinSpacing),
          
          const FormSubHeading(text: 'Applied For Registration'),
          const SizedBox(height: kMinSpacing),
          Row(
            children: [
              radioMethod(context, 'Yes', 'yes', _appliedForRegistartion, setAppliedForRegistartion),
              const SizedBox(width: kMinSpacing),
              radioMethod(context, 'Already Registered', 'already registered',
                  _appliedForRegistartion, setAppliedForRegistartion),
            ],
          ),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(context, 'Engine No', _engineNoController, false,
              false, TextInputType.text),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(context, 'Chasis No', _chasisNoController, false,
              false, TextInputType.text),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
              context,
              _vehicleMakeKey,
              'Vehicle Make',
              _vehicleMakeValue,
              _makeList,
              _makeListMap,
              'makeName',
              false,
              setMakeData),
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
              setVariantData),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
              context,
              _vehicleModelKey,
              'Vehicle Model',
              _vehicleModelValue,
              _modelList,
              _modelListMap,
              'modelName',
              _modelReadOnly,
              setModelData),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(context, 'Color', _colorController, false, false,
              TextInputType.text),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
              context,
              _bodyTypeKey,
              'Body Type',
              _bodyTypeValue,
              _bodyTypeList,
              _bodyTypeListMap,
              'bodyTypeName',
              _bodyTypeReadOnly,
              null),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(context, 'Cubic Capacity/Bhp/Torque',
              _cubicCapacityController, false, false, TextInputType.text),
          const SizedBox(height: kMinSpacing),
          const FormSubHeading(text: 'Seating Capacity'),
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
          sliderThemeMethod(context, _seatingCapacity, setSeatingCapacity),
          const CustomText(
              text: '(For Motor Cars Only)', color: kFormSubHeadingColor),
          const SizedBox(height: kMinSpacing),
          const FormSubHeading(text: 'Tracker Installed'),
          const SizedBox(height: kMinSpacing),
          Row(
            children: [
              radioMethod(context, 'Yes', 'yes', _trackerInstalled,
                  setTrackerInstalled),
              const SizedBox(width: kMinSpacing),
              radioMethod(
                  context, 'No', 'no', _trackerInstalled, setTrackerInstalled),
            ],
          ),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
              context,
              _trackingCompanyKey,
              'Tracking Company',
              _trackingCompanyValue,
              _trackingCompanyList,
              _trackingCompanyListMap,
              'trackingCompanyName',
              false,
              null),
          const SizedBox(height: kMinSpacing),
          const CustomText(
              text: '(For Motor Cars Only)', color: kFormSubHeadingColor),
          const SizedBox(height: kMinSpacing),
          const FormSubHeading(text: 'Additional Accessories'),
          const SizedBox(height: kMinSpacing),
          Row(
            children: [
              radioMethod(context, 'Yes', 'yes', _additionalAccessories,
                  setAdditionalAccessories),
              const SizedBox(width: kMinSpacing),
              radioMethod(context, 'No', 'no', _additionalAccessories,
                  setAdditionalAccessories),
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
              radioMethod(context, 'Yes', 'yes', _personalAccident,
                  setPersonalAccident),
              const SizedBox(width: kMinSpacing),
              radioMethod(
                  context, 'No', 'no', _personalAccident, setPersonalAccident),
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
                ),
              ),
            ],
          ),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(
              context,
              'Insured Estimated Value',
              _insuranceEstimatedValueController,
              true,
              false,
              TextInputType.number),
          const SizedBox(height: kMinSpacing),
          CustomButton(
            buttonText: calculateButtonText,
            onPressed: () {
              try {
                String productName = _productValue!;
                String year = _vehicleModelValue!;
                String hasTracker = _trackerInstalled;
                String personalAccident = _personalAccident;
                double estimatedValue = double.parse(
                    _insuranceEstimatedValueController.text.trim());
                final DateTime now = DateTime.now();
                final int currentYear = now.year;

                int personalAccidentAmount =
                    personalAccident == 'yes' ? 1200 : 0;
                if (productName == 'Private Motor Car - Comprehensive') {
                  if (currentYear - int.parse(year) <= 5) {
                    if (hasTracker == 'yes') {
                      // increase the estimated value by 1.75%
                      estimatedValue = estimatedValue * 1.0175;
                    } else {
                      // increase the estimated value by 1.90%
                      estimatedValue = estimatedValue * 1.0190;
                    }
                    estimatedValue = estimatedValue + personalAccidentAmount;
                    _contributionController.text =
                        estimatedValue.toStringAsFixed(2);
                  } else if (currentYear - int.parse(year) > 5 &&
                      currentYear - int.parse(year) <= 15) {
                    estimatedValue = estimatedValue * 1.015;
                    estimatedValue = estimatedValue + personalAccidentAmount;
                    _contributionController.text =
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
                  if (currentYear - int.parse(year) <= 10) {
                    String cubicCapacity = _cubicCapacityController.text;
                    cubicCapacity = cubicCapacity.replaceAll(RegExp(r'\D'), '');
                    int cubicCapacityInt = int.parse(cubicCapacity);
                    if (cubicCapacityInt >= 1000 && cubicCapacityInt <= 2000) {
                      estimatedValue = estimatedValue + 1500;
                      _contributionController.text =
                          estimatedValue.toStringAsFixed(2);
                    } else if (cubicCapacityInt > 2000 &&
                        cubicCapacityInt <= 3500) {
                      estimatedValue = estimatedValue + 2500;
                      _contributionController.text =
                          estimatedValue.toStringAsFixed(2);
                    } else {
                      AlertDialog alert = messageDialog(
                          context,
                          'Error',
                          'The cubic capacity is greater than 3500 or less than 1000. '
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
          textFormFieldMethod(context, '-', _contributionController, true, true,
              TextInputType.number),
          const SizedBox(height: kMinSpacing),
          CustomButton(
            buttonText: nextButtonText,
            onPressed: () {
              Navigator.pushNamed(context, FormStep3Screen.routeName);
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
              value: i, child: Text(productModel.productList[i].productName)),
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

  yearListener(Response response) {
    if (response.status == Status.COMPLETED) {
      YearModel yearModel = response.data as YearModel;
      setState(() {
        _models = yearModel;
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

  setProductData(Object? value) {
    String productName = _productListMap.firstWhere(
        (element) => element['productID'] == value.toString())['productName']!;
    setState(() {
      _productValue = productName;
    });
  }

  setAppliedForRegistartion(String value) {
    setState(() {
      _appliedForRegistartion = value;
    });
  }

  setMakeData(Object? value) {
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
    _vehicleVariantKey.currentState?.reset();
    _vehicleModelKey.currentState?.reset();
    _bodyTypeKey.currentState?.reset();
    setState(() {
      _vehicleMakeValue = makeName;

      _variantReadOnly = false;
      _variantList = items;
      _variantListMap = models;
      _vehicleVariantValue = null;

      _modelList = [];
      _modelListMap = [];
      _vehicleModelValue = null;
      _modelReadOnly = true;

      _bodyTypeList = [];
      _bodyTypeListMap = [];
      _bodyTypeValue = null;
      _bodyTypeReadOnly = true;
    });
  }

  // model is variant
  setVariantData(Object? value) {
    String variantName = _variantListMap.firstWhere(
        (element) => element['variantID'] == value.toString())['variantName']!;
    List<DropdownMenuItem<Object>> items = [];
    List<Map<String, String>> models = [];
    for (var i = 0; i < _models.yearList.length; i++) {
      if (variantName == _models.yearList[i].modelName) {
        items.add(
          DropdownMenuItem(value: i, child: Text(_models.yearList[i].yearName)),
        );
        models.add({
          'modelName': _models.yearList[i].yearName,
          'variantName': _models.yearList[i].modelName,
          'variantID': i.toString()
        });
      }
    }
    _vehicleModelKey.currentState?.reset();
    _bodyTypeKey.currentState?.reset();
    setState(() {
      _vehicleVariantValue = variantName;

      _modelList = items;
      _modelListMap = models;
      _vehicleModelValue = null;
      _modelReadOnly = false;

      _bodyTypeList = [];
      _bodyTypeListMap = [];
      _bodyTypeValue = null;
      _bodyTypeReadOnly = true;
    });
  }

  setModelData(Object? value) {
    String modelName = _modelListMap.firstWhere(
        (element) => element['variantID'] == value.toString())['modelName']!;
    List<DropdownMenuItem<Object>> items = [];
    List<Map<String, String>> bodyTypes = [];
    for (var i = 0; i < _bodyTypes.bodyTypeList.length; i++) {
      if (modelName == _bodyTypes.bodyTypeList[i].modelName) {
        items.add(
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
    _bodyTypeKey.currentState?.reset();
    setState(() {
      _vehicleModelValue = modelName;

      _bodyTypeList = items;
      _bodyTypeListMap = bodyTypes;
      _bodyTypeValue = null;
      _bodyTypeReadOnly = false;
    });
  }

  setSeatingCapacity(double value) {
    setState(() {
      _seatingCapacity = value;
    });
  }

  setTrackerInstalled(String value) {
    setState(() {
      _trackerInstalled = value;
    });
  }

  setAdditionalAccessories(String value) {
    setState(() {
      _additionalAccessories = value;
    });
  }

  setPersonalAccident(String value) {
    setState(() {
      _personalAccident = value;
    });
  }

  setFromInsuranceDate(DateTime? value) {
    setState(() {
      // _cnicIssueDate = date;
    });
  }

  setToInsuranceDate(DateTime? value) {
    setState(() {
      // _dob = date;
    });
  }
}
