import 'package:coverlo/cubits/city_cubit.dart';
import 'package:coverlo/cubits/colors_cubit.dart';
import 'package:coverlo/cubits/country_cubit.dart';
import 'package:coverlo/cubits/cubit_base.dart';
import 'package:coverlo/cubits/make_cubit.dart';
import 'package:coverlo/cubits/model_cubit.dart';
import 'package:coverlo/cubits/product_cubit.dart';
import 'package:coverlo/cubits/profession_cubit.dart';
import 'package:coverlo/cubits/tracking_company_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DataManager {
  static Future<void> _fetchData<T extends MyCubit<S>, S>(
      MyCubit<S> cubit) async {
    if (cubit.state.runtimeType == cubit.getInitState()) {
      await cubit.getData();
    } else if (cubit.state.runtimeType == cubit.getErrState()) {
      await cubit.getData();
    }
  }

  static Future<void> fetchCountries(BuildContext context) async {
    MyCubit cubit = context.read<CountriesCubit>();
    await _fetchData(cubit);
  }

  static Future<void> fetchCities(BuildContext context) async {
    MyCubit cubit = context.read<CitiesCubit>();
    await _fetchData(cubit);
  }

  static Future<void> fetchProfessions(BuildContext context) async {
    MyCubit cubit = context.read<ProfessionsCubit>();
    await _fetchData(cubit);
  }

  static Future<void> fetchProducts(BuildContext context) async {
    MyCubit cubit = context.read<ProductsCubit>();
    await _fetchData(cubit);
  }

  static Future<void> fetchMakes(BuildContext context) async {
    MyCubit cubit = context.read<MakesCubit>();
    await _fetchData(cubit);
  }

  static Future<void> fetchModels(BuildContext context) async {
    MyCubit cubit = context.read<ModelsCubit>();
    await _fetchData(cubit);
  }

  static Future<void> fetchTrackingCompanies(BuildContext context) async {
    MyCubit cubit = context.read<TrackingCompaniesCubit>();
    await _fetchData(cubit);
  }

  static Future<void> fetchColors(BuildContext context) async {
    MyCubit cubit = context.read<ColorsCubit>();
    await _fetchData(cubit);
  }
}
