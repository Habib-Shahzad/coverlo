import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/model_bloc.dart';

getModelApi(Bloc bloc, String uniqueID, String deviceUniqueIdentifier) async {
  bloc.connect({
    'uniqueID': uniqueID,
    'deviceUniqueIdentifier': deviceUniqueIdentifier,
  }, ModelBloc.GET_MODELS);
}
