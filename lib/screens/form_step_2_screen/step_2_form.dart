import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/components/custom_text.dart';
import 'package:coverlo/components/form_sub_heading.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/cubits/colors_cubit.dart';
import 'package:coverlo/cubits/make_cubit.dart';
import 'package:coverlo/cubits/model_cubit.dart';
import 'package:coverlo/cubits/product_cubit.dart';
import 'package:coverlo/cubits/tracking_company_cubit.dart';
import 'package:coverlo/form_fields/date_time_form_field.dart';
import 'package:coverlo/form_fields/drop_down_form_field.dart';
import 'package:coverlo/form_fields/radio_method.dart';
import 'package:coverlo/form_fields/slider_method.dart';
import 'package:coverlo/form_fields/text_form_field.dart';
import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/components/message_dialog.dart';
import 'package:coverlo/helpers/helper_functions.dart';
import 'package:coverlo/models/make_model.dart';
import 'package:coverlo/models/model_model.dart';
import 'package:coverlo/models/product_model.dart';
import 'package:coverlo/models/tracking_company_model.dart';
import 'package:coverlo/networking/data_manager.dart';
import 'package:coverlo/screens/form_step_3_screen/form_step_3_screen.dart';
import 'package:flutter/material.dart';
import 'package:coverlo/models/color_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as flutter_bloc;

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

  List<DropdownMenuItem<Object>> vehicleModelDropDownItems = carModelsDropDownItems;
  List<VehicleModel> vehicleModelList = carModelsList;

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

  bool _variantReadOnly = false;
  bool _modelReadOnly = false;

  Future<void> fetchData() async {
    if (context.mounted) await DataManager.fetchProducts(context);
    if (context.mounted) await DataManager.fetchColors(context);
    if (context.mounted) await DataManager.fetchTrackingCompanies(context);
  }

  Future<void>? _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                flutter_bloc.BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    return dropDownFormFieldMethod(
                      context,
                      _productKey,
                      'Product',
                      productValue,
                      state is ProductsLoaded ? state.dropdownItems : [],
                      state is ProductsLoaded ? state.products : [],
                      false,
                      setProductData,
                      controlled: true,
                      dropDownValue: productNameController.text != ""
                          ? int.parse(productNameController.text)
                          : null,
                    );
                  },
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
                flutter_bloc.BlocBuilder<MakesCubit, MakesState>(
                  builder: (context, state) {
                    return dropDownFormFieldMethod(
                      context,
                      _vehicleMakeKey,
                      'Vehicle Make',
                      vehicleMakeValue,
                      state is MakesLoaded ? state.dropdownItems : [],
                      state is MakesLoaded ? state.makes : [],
                      false,
                      setMakeData,
                      controlled: true,
                      dropDownValue: vehicleMakeController.text != ""
                          ? int.parse(vehicleMakeController.text)
                          : null,
                    );
                  },
                ),
                const SizedBox(height: kMinSpacing),
                flutter_bloc.BlocBuilder<ModelsCubit, ModelsState>(
                  builder: (context, state) {
                    List<DropdownMenuItem<Object>> dropdownItems = [];
                    List<Model> items = [];

                    if (state is ModelsLoaded) {
                      int index = 0;
                      for (Model model in state.models) {
                        if (model.makeName == vehicleMakeValue) {
                          items.add(model);
                          dropdownItems.add(
                            DropdownMenuItem(
                              value: index,
                              child: Text(model.modelName),
                            ),
                          );
                          index++;
                        }
                      }
                    }
                    return dropDownFormFieldMethod(
                      context,
                      _vehicleVariantKey,
                      'Vehicle Variant',
                      vehicleVariantValue,
                      dropdownItems,
                      items,
                      _variantReadOnly,
                      setVariantData,
                      controlled: true,
                      dropDownValue: vehicleVariantController.text != ""
                          ? int.parse(vehicleVariantController.text)
                          : null,
                    );
                  },
                ),
                const SizedBox(height: kMinSpacing),
                dropDownFormFieldMethod(
                  context,
                  _vehicleModelKey,
                  'Vehicle Model',
                  vehicleModelValue,
                  vehicleModelDropDownItems,
                  vehicleModelList,
                  _modelReadOnly,
                  setModelData,
                  controlled: true,
                  dropDownValue: vehicleModelController.text != ""
                      ? int.parse(vehicleModelController.text)
                      : null,
                ),
                const SizedBox(height: kMinSpacing),
                flutter_bloc.BlocBuilder<ColorsCubit, ColorsState>(
                  builder: (context, state) {
                    return dropDownFormFieldMethod(
                      context,
                      _colorKey,
                      'Color',
                      colorValue,
                      state is ColorsLoaded ? state.dropdownItems : [],
                      state is ColorsLoaded ? state.colors : [],
                      false,
                      setColorData,
                      controlled: true,
                      dropDownValue: colorController.text != ""
                          ? int.parse(colorController.text)
                          : null,
                    );
                  },
                ),
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
                FormSubHeading(
                    text: 'Seating Capacity: ${seatingCapacity.ceil()}'),
                const SizedBox(height: kMinSpacing),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                        text: '(For Motor Cars Only)',
                        color: kFormSubHeadingColor),
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
                        ? flutter_bloc.BlocBuilder<TrackingCompaniesCubit,
                            TrackingCompaniesState>(
                            builder: (context, state) {
                              return dropDownFormFieldMethod(
                                context,
                                _trackingCompanyKey,
                                'Tracking Company',
                                trackingCompanyValue,
                                state is TrackingCompaniesLoaded
                                    ? state.dropdownItems
                                    : [],
                                state is TrackingCompaniesLoaded
                                    ? state.companies
                                    : [],
                                false,
                                setTrackingCompanyData,
                                controlled: true,
                                dropDownValue: trackingCompanyController.text !=
                                        ""
                                    ? int.parse(trackingCompanyController.text)
                                    : null,
                              );
                            },
                          )
                        : const SizedBox(),
                productValue == thirdParty
                    ? const SizedBox()
                    : const SizedBox(height: kMinSpacing),
                productValue == thirdParty
                    ? const SizedBox()
                    : const CustomText(
                        text: '(For Motor Cars Only)',
                        color: kFormSubHeadingColor),
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
                          estimatedValue =
                              estimatedValue + personalAccidentAmount;
                          contributionController.text =
                              estimatedValue.toStringAsFixed(2);
                        } else if (yearsOld > 5 && yearsOld <= 15) {
                          estimatedValue = carEstimatedValue * (1.5 / 100);
                          estimatedValue =
                              estimatedValue + personalAccidentAmount;
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
                          cubicCapacity =
                              cubicCapacity.replaceAll(RegExp(r'\D'), '');
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
                      AlertDialog alert = messageDialog(context, 'Error',
                          'Please calculate the contribution');
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
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  setProductData(Object? value, List? productList) async {
    String? dataIndex = _productKey.currentState?.value.toString();

    if (dataIndex == null) return;

    setState(() {
      productNameController.text = dataIndex;
      seatingCapacity = 1;
    });

    _vehicleMakeKey.currentState?.reset();
    _vehicleVariantKey.currentState?.reset();
    _vehicleModelKey.currentState?.reset();
    _colorKey.currentState?.reset();
    contributionController.text = "";

    colorController.text = "";
    colorValue = null;

    vehicleMakeController.text = "";
    vehicleMakeValue = null;

    vehicleModelController.text = "";
    vehicleModelValue = null;

    vehicleVariantController.text = "";
    vehicleVariantValue = null;

    var product = productList![int.parse(dataIndex)] as Product;

    String productName = product.productName;
    String productCode = product.productCode;

    int maxCap = 0;
    List<DropdownMenuItem<Object>> newModelList;
    List<VehicleModel> newModelListMap;

    if (selectedProductIsCar(productName)) {
      maxCap = 4;
      newModelList = carModelsDropDownItems;
      newModelListMap = carModelsList;
      _personalAccidentText = "Personal Accident For Drive +4 Passengers";
    } else {
      maxCap = 2;
      newModelList = bikeModelsDropDownItems;
      newModelListMap = bikeModelsList;
      _personalAccidentText = "Personal Accident For Driver + 1 Passenger";
    }

    setState(() {
      productValue = productName;
      productCodeValue = productCode;
      _maxSeatingCapacity = maxCap;
      vehicleModelDropDownItems = newModelList;
      vehicleModelList = newModelListMap;
      _modelReadOnly = false;
    });
  }

  setAppliedForRegistartion(String value) {
    setState(() {
      appliedForRegistartion = value;
    });
  }

  setMakeData(Object? value, List? makesList) {
    String? dataIndex = _vehicleMakeKey.currentState?.value.toString();

    if (dataIndex == null) return;

    vehicleMakeController.text = dataIndex;

    Make make = makesList![int.parse(dataIndex)] as Make;

    String makeName = make.makeName;
    String makeCode = make.makeCode;

    vehicleVariantController.text = "";
    vehicleVariantValue = null;

    vehicleModelController.text = "";
    vehicleModelValue = null;

    bodyTypeController.text = "";
    bodyTypeValue = null;

    _vehicleVariantKey.currentState?.reset();
    _vehicleModelKey.currentState?.reset();
    _bodyTypeKey.currentState?.reset();

    setState(() {
      vehicleMakeValue = makeName;
      vehcileMakeCodeValue = makeCode;

      _variantReadOnly = false;

      bodyTypeValue = null;
    });
  }

  // model is variant
  setVariantData(Object? value, List? variantsList) {
    String? dataIndex = _vehicleVariantKey.currentState?.value.toString();

    if (dataIndex == null) return;

    vehicleVariantController.text = dataIndex;

    var variant = variantsList![int.parse(dataIndex)] as Model;

    String variantName = variant.modelName;
    String variantCode = variant.modelCode;

    vehicleModelController.text = "";
    bodyTypeController.text = "";

    _vehicleModelKey.currentState?.reset();
    _bodyTypeKey.currentState?.reset();
    setState(() {
      vehcileMakeCodeValue = variantCode;
      vehicleVariantValue = variantName;
      vehicleModelValue = null;
      bodyTypeValue = null;
    });
  }

  setTrackingCompanyData(Object? value, List? trackingCompanyList) {
    String? dataIndex = _trackingCompanyKey.currentState?.value.toString();

    if (dataIndex == null || trackingCompanyList == null) return;

    trackingCompanyController.text = dataIndex;

    var company = trackingCompanyList[int.parse(dataIndex)] as TrackingCompany;

    setState(() {
      trackingCompanyValue = company.trackingCompanyCode;
    });
  }

  setColorData(Object? value, List? colorList) {
    String? dataIndex = _colorKey.currentState?.value.toString();

    if (dataIndex == null || colorList == null) return;

    colorController.text = dataIndex;

    var color = colorList[int.parse(dataIndex)] as Color;

    setState(() {
      colorValue = color.colorCode;
    });
  }

  setModelData(Object? value, List? modelYears) {
    String? dataIndex = _vehicleModelKey.currentState?.value.toString();

    if (dataIndex == null || modelYears == null) return;

    vehicleModelController.text = dataIndex;

    String? year = ((modelYears[int.parse(dataIndex)]) as VehicleModel).year;

    setState(() {
      vehicleModelValue = year;
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
