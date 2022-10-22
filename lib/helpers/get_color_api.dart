import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/color_bloc.dart';

getColorApi(Bloc bloc, String uniqueID, String deviceUniqueIdentifier) async {
  bloc.connect({
    'uniqueID': uniqueID,
    'deviceUniqueIdentifier': deviceUniqueIdentifier,
  }, ColorBloc.GET_COLORS);
}
