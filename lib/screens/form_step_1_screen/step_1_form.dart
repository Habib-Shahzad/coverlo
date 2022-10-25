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

class Step1Form extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const Step1Form({Key? key, required this.formKey}) : super(key: key);

  @override
  State<Step1Form> createState() => _Step1FormState();
}

class _Step1FormState extends State<Step1Form> {
  // final _formKey = GlobalKey<FormState>();
  String buttonText = 'Next';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  // final TextEditingController _cityController = TextEditingController();
  Object? _cityValue;
  final GlobalKey<FormFieldState> _cityKey = GlobalKey<FormFieldState>();
  // final TextEditingController _nationalityController = TextEditingController();
  Object? _nationalityValue;
  final GlobalKey<FormFieldState> _nationalityKey = GlobalKey<FormFieldState>();
  final TextEditingController _cnicController = TextEditingController();
  // DateTime? _cnicIssueDate;
  // DateTime? _dob;
  // final TextEditingController _genderController = TextEditingController();
  Object? _genderValue;
  final GlobalKey<FormFieldState> _genderKey = GlobalKey<FormFieldState>();
  // final TextEditingController _professionController = TextEditingController();
  Object? _professionValue;
  final GlobalKey<FormFieldState> _professionKey = GlobalKey<FormFieldState>();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late Bloc _cityBloc;
  late Bloc _countryBloc;
  late Bloc _professionBloc;

  List<DropdownMenuItem<Object>> _cityList = [];
  List<Map<String, String>> _cityListMap = [];

  List<DropdownMenuItem<Object>> _countryList = [];
  List<Map<String, String>> _countryListMap = [];

  List<DropdownMenuItem<Object>> _genderList = [];
  List<Map<String, String>> _genderListMap = [];

  List<DropdownMenuItem<Object>> _professionList = [];
  List<Map<String, String>> _professionListMap = [];

  late FocusNode cnicFocusNode;
  bool cnicHasInputError = false;

  late FocusNode mobileFocusNode;
  bool mobileHasInputError = false;


  bool cnicValidated() {
    return regexMatched(_cnicController.text, cnicRegex) &&
        _cnicController.text.isNotEmpty &&
        _cnicController.text.length == 13;
  }

  bool mobileValidated() {
    return regexMatched(_mobileNoController.text, pkPhoneRegex) &&
        _mobileNoController.text.isNotEmpty;
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
    ];
    List<Map<String, String>> genders = [
      {'genderName': 'Male', 'genderID': '0'},
      {'genderName': 'Female', 'genderID': '1'},
    ];
    setState(() {
      _genderList = items;
      _genderListMap = genders;
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
          'cityName': cityModel.cityList[i].cityName,
          'cityID': i.toString()
        });
      }
      setState(() {
        _cityList = items;
        _cityListMap = cities;
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
          'countryName': countryModel.countryList[i].countryName,
          'countryID': i.toString()
        });
      }
      setState(() {
        _countryList = items;
        _countryListMap = countries;
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
        _professionList = items;
        _professionListMap = professions;
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

  setCnicIssueDate(DateTime? date) {
    setState(() {
      // _cnicIssueDate = date;
    });
  }

  setDob(DateTime? date) {
    setState(() {
      // _dob = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      key: widget.formKey,
      child: Column(
        children: [
          textFormFieldMethod(context, 'Name', _nameController, false, false,
              TextInputType.text,
              nullValidation: true),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(context, 'Address', _addressController, false,
              false, TextInputType.text),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(context, _cityKey, 'City', _cityValue,
              _cityList, _cityListMap, 'cityName', false, null),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
              context,
              _nationalityKey,
              'Nationality',
              _nationalityValue,
              _countryList,
              _countryListMap,
              'countryName',
              false,
              null),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(context, 'CNIC/Passport No', _cnicController,
              false, false, TextInputType.text,
              regexValidation: true,
              regexPattern: cnicRegex,
              regexValidationText: "Invalid CNIC",
              nullValidation: true,
              focusNode: cnicFocusNode,
              fieldInputError: cnicHasInputError),
          const SizedBox(height: kMinSpacing),
          dateTimeFormFieldMethod(
              context, 'CNIC/Passport Issue Date', setCnicIssueDate),
          const SizedBox(height: kMinSpacing),
          dateTimeFormFieldMethod(context, 'Date of Birth', setDob),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(context, _genderKey, 'Gender', _genderValue,
              _genderList, _genderListMap, 'genderName', false, null),
          const SizedBox(height: kMinSpacing),
          dropDownFormFieldMethod(
              context,
              _professionKey,
              'Profession',
              _professionValue,
              _professionList,
              _professionListMap,
              'professionName',
              false,
              null),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(context, 'Mobile No', _mobileNoController, false,
              false, TextInputType.number,
              regexValidation: true,
              regexPattern: pkPhoneRegex,
              regexValidationText: "Invalid Mobile No",
              nullValidation: true,
              focusNode: mobileFocusNode,
              fieldInputError: mobileHasInputError),
          const SizedBox(height: kMinSpacing),
          textFormFieldMethod(context, 'Email', _emailController, false, false,
              TextInputType.text,
              regexValidation: true,
              regexPattern: emailRegex,
              nullValidation: true),
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
