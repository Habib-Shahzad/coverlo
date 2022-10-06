import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/year_bloc.dart';

getYearApi(Bloc bloc, String uniqueID, String deviceUniqueIdentifier) async {
  bloc.connect({
    'uniqueID': uniqueID,
    'deviceUniqueIdentifier': deviceUniqueIdentifier,
  }, YearBloc.GET_YEARS);
}
