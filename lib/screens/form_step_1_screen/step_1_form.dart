import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/bloc_queue.dart';
import 'package:coverlo/blocs/city_bloc.dart';
import 'package:coverlo/blocs/country_bloc.dart';
import 'package:coverlo/blocs/profession_bloc.dart';
import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/form_fields/date_time_form_field.dart';
import 'package:coverlo/form_fields/drop_down_form_field.dart';
import 'package:coverlo/form_fields/text_form_field.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/global_apidata.dart';
import 'package:coverlo/helpers/dialogs/message_dialog.dart';
import 'package:coverlo/helpers/get_city_api.dart';
import 'package:coverlo/helpers/get_country_api.dart';
import 'package:coverlo/helpers/get_profession_api.dart';
import 'package:coverlo/models/city_model.dart';
import 'package:coverlo/models/country_model.dart';
import 'package:coverlo/models/profession_model.dart';
import 'package:coverlo/networking/response.dart';
import 'package:coverlo/pairbloc.dart';
import 'package:coverlo/screens/form_step_2_screen/form_step_2_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String emailRegex =
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

String pkPhoneRegex =
    r'^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$';

String cnicRegex = r'^[0-9]{1,13}$';
String passportRegex = r'^(?!^0+$)[a-zA-Z0-9]{3,20}$';

class Step1Form extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const Step1Form({Key? key, required this.formKey}) : super(key: key);

  @override
  State<Step1Form> createState() => _Step1FormState();
}

class _Step1FormState extends State<Step1Form> {
  String buttonText = 'Next';

  Object? _cityValue;
  final GlobalKey<FormFieldState> _cityKey = GlobalKey<FormFieldState>();

  Object? _nationalityValue;
  final GlobalKey<FormFieldState> _nationalityKey = GlobalKey<FormFieldState>();

  Object? _genderValue;
  final GlobalKey<FormFieldState> _genderKey = GlobalKey<FormFieldState>();

  Object? _professionValue;
  final GlobalKey<FormFieldState> _professionKey = GlobalKey<FormFieldState>();

  late Bloc _cityBloc;
  late Bloc _countryBloc;
  late Bloc _professionBloc;

  bool cityLoaded = false;
  bool countryLoaded = false;
  bool professionLoaded = false;

  late FocusNode cnicFocusNode;

  bool cnicHasInputError = false;
  bool mobileHasInputError = false;

  late FocusNode mobileFocusNode;

  bool cnicValidated() {
    String regexToCheck =
        countryValue == "PAKISTAN" ? cnicRegex : passportRegex;
    return regexMatched(cnicController.text, regexToCheck) &&
        cnicController.text.isNotEmpty &&
        cnicController.text.length == (countryValue == "PAKISTAN" ? 13 : 9);
  }

  bool mobileValidated() {
    return regexMatched(mobileNoController.text, pkPhoneRegex) &&
        mobileNoController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _cityBloc = CityBloc();
    _countryBloc = CountryBloc();
    _professionBloc = ProfessionBloc();
    StaticGlobal.blocs.addListener(checkBlocsQueue);
    setHardcodedData();
    getData();


    cnicFocusNode = FocusNode();
    cnicFocusNode.addListener(() {
      if (!cnicFocusNode.hasFocus) {
        setState(() {
          cnicHasInputError = !cnicValidated();
        });
      }
    });

    mobileFocusNode = FocusNode();
    mobileFocusNode.addListener(() {
      if (!mobileFocusNode.hasFocus) {
        setState(() {
          mobileHasInputError = !mobileValidated();
        });
      }
    });
  }

  @override
  void dispose() {
    StaticGlobal.blocs.removeListener(checkBlocsQueue);
    _cityBloc.dispose();
    _countryBloc.dispose();
    _professionBloc.dispose();
    super.dispose();
  }

  setHardcodedData() {
    List<DropdownMenuItem<Object>> items = [
      const DropdownMenuItem(value: 0, child: Text('Male')),
      const DropdownMenuItem(value: 1, child: Text('Female')),
      const DropdownMenuItem(value: 2, child: Text('Transgender')),
    ];
    List<Map<String, String>> genders = [
      {'genderName': 'Male', 'genderID': '0'},
      {'genderName': 'Female', 'genderID': '1'},
      {'genderName': 'Transgender', 'genderID': '2'},
    ];
    setState(() {
      genderList = items;
      genderListMap = genders;
    });
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    String deviceUniqueIdentifier =
        prefs.getString('deviceUniqueIdentifier') ?? '';
    String uniqueID = prefs.getString('uniqueID') ?? '';

    _cityBloc.getStream.listen(cityListener);
    _countryBloc.getStream.listen(countryListener);
    _professionBloc.getStream.listen(professionListener);

    getCityApi(_cityBloc, uniqueID, deviceUniqueIdentifier);
    getCountryApi(_countryBloc, uniqueID, deviceUniqueIdentifier);
    getProfessionApi(_professionBloc, uniqueID, deviceUniqueIdentifier);

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

  cityListener(Response response) {
    if (response.status == Status.COMPLETED) {
      List<DropdownMenuItem<Object>> items = [];
      List<Map<String, String>> cities = [];
      CityModel cityModel = response.data as CityModel;
      for (var i = 0; i < cityModel.cityList.length; i++) {
        items.add(
          DropdownMenuItem(
              value: i, child: Text(cityModel.cityList[i].cityName)),
        );
        cities.add({
          'cityCode': cityModel.cityList[i].cityCode,
          'cityID': i.toString()
        });
      }
      setState(() {
        cityList = items;
        cityListMap = cities;
        cityLoaded = true;
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

  countryListener(Response response) {
    if (response.status == Status.COMPLETED) {
      List<DropdownMenuItem<Object>> items = [];
      List<Map<String, String>> countries = [];
      CountryModel countryModel = response.data as CountryModel;
      for (var i = 0; i < countryModel.countryList.length; i++) {
        items.add(
          DropdownMenuItem(
              value: i, child: Text(countryModel.countryList[i].countryName)),
        );
        countries.add({
          'countryCode': countryModel.countryList[i].countryCode, // 'PK
          'countryName': countryModel.countryList[i].countryName,
          'countryID': i.toString()
        });
      }
      setState(() {
        countryList = items;
        countryListMap = countries;
        countryLoaded = true;
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

  professionListener(Response response) {
    if (response.status == Status.COMPLETED) {
      List<DropdownMenuItem<Object>> items = [];
      List<Map<String, String>> professions = [];
      ProfessionModel professionModel = response.data as ProfessionModel;
      for (var i = 0; i < professionModel.professionList.length; i++) {
        items.add(
          DropdownMenuItem(
              value: i,
              child: Text(professionModel.professionList[i].professionName)),
        );
        professions.add({
          'professionName': professionModel.professionList[i].professionName,
          'professionID': i.toString()
        });
      }
      setState(() {
        professionList = items;
        professionListMap = professions;
        professionLoaded = true;
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

  setCityData(Object? value) {
    String? dataIndex = _cityKey.currentState?.value.toString();

    if (dataIndex != null) {
      cityController.text = dataIndex;
    }

    String cityCode =
        cityListMap[int.parse(dataIndex ?? '0')]['cityCode'] ?? '';

    setState(() {
      cityValue = cityCode;
    });
  }

  setCountryData(Object? value) {
    String? dataIndex = _nationalityKey.currentState?.value.toString();

    if (dataIndex != null) {
      countryController.text = dataIndex;
    }

    String countryName =
        countryListMap[int.parse(dataIndex ?? '0')]['countryName'] ?? '';

    String countryCode =
        countryListMap[int.parse(dataIndex ?? '0')]['countryCode'] ?? '';

    setState(() {
      countryValue = countryName;
      countryCodeValue = countryCode;
    });
  }

  setGenderData(Object? value) {
    String? dataIndex = _genderKey.currentState?.value.toString();

    if (dataIndex != null) {
      genderController.text = dataIndex;
    }

    String genderName =
        genderListMap[int.parse(dataIndex ?? '0')]['genderName'] ?? '';

    setState(() {
      genderValue = genderName;
    });
  }

  setProfessionData(Object? value) {
    String? dataIndex = _professionKey.currentState?.value.toString();

    if (dataIndex != null) {
      professionController.text = dataIndex;
    }

    String professionName =
        professionListMap[int.parse(dataIndex ?? '0')]['professionName'] ?? '';

    setState(() {
      professionValue = professionName;
    });
  }

  setCnicIssueDate(DateTime? date) {
    setState(() {
      cnicIssueDateValue = date;
    });
  }

  setDob(DateTime? date) {
    setState(() {
      dateOfBirthValue = date;
    });
  }

  bool dataIsSet = false;

  @override
  Widget build(BuildContext context) {
    if (!dataIsSet && countryLoaded && cityLoaded && professionLoaded) {
      if (cityController.text.isNotEmpty) {
        setCityData(int.parse(cityController.text));
      }
      if (countryController.text.isNotEmpty) {
        setCountryData(int.parse(countryController.text));
      }
      if (genderController.text.isNotEmpty) {
        setGenderData(int.parse(genderController.text));
      }
      if (professionController.text.isNotEmpty) {
        setProfessionData(int.parse(professionController.text));
      }

      setState(() {
        dataIsSet = true;
      });
    }
    return Form(
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      key: widget.formKey,
      child: Column(
        children: [
          textFormFieldMethod(
            context,
            'Name',
            nameController,
            false,
            false,
            TextInputType.text,
            nullValidation: true,
          ),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(
            context,
            'Address',
            addressController,
            false,
            false,
            TextInputType.text,
            nullValidation: true,
          ),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
            context,
            _cityKey,
            'City',
            _cityValue,
            cityList,
            cityListMap,
            'cityName',
            false,
            setCityData,
            nullValidation: true,
            controlled: true,
            dropDownValue: cityController.text != ""
                ? int.parse(cityController.text)
                : null,
          ),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
            context,
            _nationalityKey,
            'Nationality',
            _nationalityValue,
            countryList,
            countryListMap,
            'countryName',
            false,
            setCountryData,
            nullValidation: true,
            controlled: true,
            dropDownValue: countryController.text != ""
                ? int.parse(countryController.text)
                : null,
          ),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(
            context,
            countryValue == "PAKISTAN" ? 'CNIC' : 'Passport No',
            cnicController,
            false,
            false,
            TextInputType.text,
            regexValidation: true,
            regexPattern:
                countryValue == "PAKISTAN" ? cnicRegex : passportRegex,
            regexValidationText: countryValue == "PAKISTAN"
                ? 'Invalid CNIC'
                : 'Invalid Passport',
            nullValidation: true,
            focusNode: cnicFocusNode,
            fieldInputError: cnicHasInputError,
            maxLength: countryValue == "PAKISTAN" ? 13 : 9,
            denyMoreThanMaxLength: true,
          ),
          const SizedBox(height: kMinSpacing),
          dateTimeFormFieldMethod(
            context,
            'CNIC/Passport Issue Date',
            setCnicIssueDate,
            ignoreFuture: true,
            nullValidation: true,
            inititalDate: cnicIssueDateValue,
          ),
          const SizedBox(height: kMinSpacing),
          dateTimeFormFieldMethod(
            context,
            'Date of Birth',
            setDob,
            ignoreFuture: true,
            nullValidation: true,
            inititalDate: dateOfBirthValue,
          ),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
            context,
            _genderKey,
            'Gender',
            _genderValue,
            genderList,
            genderListMap,
            'genderName',
            false,
            setGenderData,
            nullValidation: true,
            controlled: true,
            dropDownValue: genderController.text != ""
                ? int.parse(genderController.text)
                : null,
          ),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
              context,
              _professionKey,
              'Profession',
              _professionValue,
              professionList,
              professionListMap,
              'professionName',
              false,
              setProfessionData,
              nullValidation: true,
              controlled: true,
              dropDownValue: professionController.text != ""
                  ? int.parse(professionController.text)
                  : null),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(
            context,
            'Mobile No',
            mobileNoController,
            false,
            false,
            TextInputType.number,
            regexValidation: true,
            regexPattern: pkPhoneRegex,
            regexValidationText: "Invalid Mobile No",
            nullValidation: true,
            focusNode: mobileFocusNode,
            fieldInputError: mobileHasInputError,
            maxLength: 11,
            denyMoreThanMaxLength: true,
          ),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(
            context,
            'Email',
            emailController,
            false,
            false,
            TextInputType.emailAddress,
            regexValidation: true,
            regexPattern: emailRegex,
            nullValidation: true,
            denySpaces: true,
          ),
          const SizedBox(height: kMinSpacing),
          CustomButton(
            buttonText: buttonText,
            onPressed: () {
              bool formValidated = widget.formKey.currentState!.validate();

              bool invalidMobile = !mobileValidated();
              bool invalidCnic = !cnicValidated();

              if (invalidMobile || invalidCnic) {
                setState(() {
                  mobileHasInputError = invalidMobile;
                  cnicHasInputError = invalidCnic;
                });
              } else if (formValidated) {
                Navigator.pushNamed(context, FormStep2Screen.routeName);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all the fields')),
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
}
