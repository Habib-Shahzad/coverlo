import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/city_bloc.dart';

getCityApi(Bloc bloc, String uniqueID, String deviceUniqueIdentifier) async {
  bloc.connect({
    'uniqueID': uniqueID,
    'deviceUniqueIdentifier': deviceUniqueIdentifier,
  }, CityBloc.GET_CITIES);
}
