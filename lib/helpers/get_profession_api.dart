import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/profession_bloc.dart';

getProfessionApi(
    Bloc bloc, String uniqueID, String deviceUniqueIdentifier) async {
  bloc.connect({
    'uniqueID': uniqueID,
    'deviceUniqueIdentifier': deviceUniqueIdentifier,
  }, ProfessionBloc.GET_PROFESSIONS);
}
