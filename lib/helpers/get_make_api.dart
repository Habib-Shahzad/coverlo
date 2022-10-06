import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/make_bloc.dart';

getMakeApi(Bloc bloc, String uniqueID, String deviceUniqueIdentifier) async {
  bloc.connect({
    'uniqueID': uniqueID,
    'deviceUniqueIdentifier': deviceUniqueIdentifier,
  }, MakeBloc.GET_MAKES);
}
