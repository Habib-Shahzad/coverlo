import 'package:coverlo/components/custom_button.dart';
import 'package:coverlo/constants.dart';
import 'package:coverlo/cubits/city_cubit.dart';
import 'package:coverlo/cubits/country_cubit.dart';
import 'package:coverlo/cubits/make_cubit.dart';
import 'package:coverlo/cubits/model_cubit.dart';
import 'package:coverlo/cubits/product_cubit.dart';
import 'package:coverlo/cubits/profession_cubit.dart';
import 'package:coverlo/form_fields/date_time_form_field.dart';
import 'package:coverlo/form_fields/drop_down_form_field.dart';
import 'package:coverlo/form_fields/text_form_field.dart';
import 'package:coverlo/global_formdata.dart';
import 'package:coverlo/global_apidata.dart';
import 'package:coverlo/models/city_model.dart';
import 'package:coverlo/models/country_model.dart';
import 'package:coverlo/models/profession_model.dart';
import 'package:coverlo/screens/form_step_2_screen/form_step_2_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as flutter_bloc;

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

  final GlobalKey<FormFieldState> _cityKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _nationalityKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _genderKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _professionKey = GlobalKey<FormFieldState>();

  final CitiesCubit citiesCubit = CitiesCubit();

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.read<ProductsCubit>().state is ProductsInitial) {
        await context.read<ProductsCubit>().getData();
      }
      if (context.read<MakesCubit>().state is MakesInitial) {
        await context.read<MakesCubit>().getData();
      }

      if (context.read<ModelsCubit>().state is ModelsInitial) {
        await context.read<ModelsCubit>().getData();
      }
    });

    setHardcodedData();

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

  setCityData(Object? value, List<dynamic>? cityList) {
    String? dataIndex = _cityKey.currentState?.value.toString();

    if (dataIndex != null) {
      cityController.text = dataIndex;
    }
    var city = cityList![int.parse(dataIndex!)] as City;

    setState(() {
      cityValue = city.cityCode;
    });
  }

  setCountryData(Object? value, List? countryList) {
    String? dataIndex = _nationalityKey.currentState?.value.toString();

    if (dataIndex != null) {
      countryController.text = dataIndex;
    }

    Country country = countryList![int.parse(dataIndex!)] as Country;
    String countryName = country.countryName;
    String countryCode = country.countryCode;

    _cityKey.currentState?.reset();

    setState(() {
      countryValue = countryName;
      countryCodeValue = countryCode;
      cityValue = "";
    });
  }

  setGenderData(Object? value, List? genderList) {
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

  setProfessionData(Object? value, List? professionList) {
    String? dataIndex = _professionKey.currentState?.value.toString();

    if (dataIndex != null) {
      professionController.text = dataIndex;
    }

    Profession profession =
        professionList![int.parse(dataIndex!)] as Profession;

    setState(() {
      professionValue = profession.professionCode;
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
          flutter_bloc.BlocBuilder<CountriesCubit, CountriesState>(
            builder: (context, state) {
              return dropDownFormFieldMethod(
                context,
                _nationalityKey,
                'Nationality',
                countryValue,
                state is CountriesLoaded ? state.dropdownItems : [],
                state is CountriesLoaded ? state.countries : [],
                false,
                setCountryData,
                nullValidation: true,
                controlled: true,
                dropDownValue: countryController.text != ""
                    ? int.parse(countryController.text)
                    : null,
              );
            },
          ),
          const SizedBox(height: kMinSpacing),
          flutter_bloc.BlocBuilder<CitiesCubit, CitiesState>(
            builder: (context, state) {
              List<DropdownMenuItem<Object>> dropdownItems = [];
              List<City> items = [];

              if (state is CitiesLoaded) {
                int index = 0;
                for (City city in state.cities) {
                  if (city.countryName == countryValue) {
                    items.add(city);
                    dropdownItems.add(
                      DropdownMenuItem(
                        value: index,
                        child: Text(city.cityName),
                      ),
                    );
                    index++;
                  }
                }
              }

              return dropDownFormFieldMethod(
                context,
                _cityKey,
                'City',
                cityValue,
                state is CitiesLoaded ? dropdownItems : [],
                state is CitiesLoaded ? items : [],
                false,
                setCityData,
                nullValidation: true,
                controlled: true,
                dropDownValue: cityController.text != ""
                    ? int.parse(cityController.text)
                    : null,
              );
            },
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
            genderValue,
            genderList,
            genderListMap,
            false,
            setGenderData,
            nullValidation: true,
            controlled: true,
            dropDownValue: genderController.text != ""
                ? int.parse(genderController.text)
                : null,
          ),
          const SizedBox(height: kMinSpacing),
          flutter_bloc.BlocBuilder<ProfessionsCubit, ProfessionsState>(
            builder: (context, state) {
              return dropDownFormFieldMethod(
                  context,
                  _professionKey,
                  'Profession',
                  professionValue,
                  state is ProfessionsLoaded ? state.dropdownItems : [],
                  state is ProfessionsLoaded ? state.professions : [],
                  false,
                  setProfessionData,
                  nullValidation: true,
                  controlled: true,
                  dropDownValue: professionController.text != ""
                      ? int.parse(professionController.text)
                      : null);
            },
          ),
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
