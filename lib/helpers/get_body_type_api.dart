import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/body_type_bloc.dart';

getBodyTypeApi(
    Bloc bloc, String uniqueID, String deviceUniqueIdentifier) async {
  bloc.connect({
    'uniqueID': uniqueID,
    'deviceUniqueIdentifier': deviceUniqueIdentifier,
  }, BodyTypeBloc.GET_BODY_TYPES);
}
