import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/country_bloc.dart';

getCountryApi(Bloc bloc, String uniqueID, String deviceUniqueIdentifier) async {
  bloc.connect({
    'uniqueID': uniqueID,
    'deviceUniqueIdentifier': deviceUniqueIdentifier,
  }, CountryBloc.GET_COUNTRIES);
}
