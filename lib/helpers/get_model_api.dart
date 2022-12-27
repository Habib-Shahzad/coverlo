import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/model_bloc.dart';
import 'package:coverlo/constants.dart';

getModelApi(Bloc bloc, String uniqueID, String deviceUniqueIdentifier, VehicleType vehicleType) async {
  bloc.connect({
    'uniqueID': uniqueID,
    'deviceUniqueIdentifier': deviceUniqueIdentifier,
  }, vehicleType == VehicleType.Car
          ? ModelBloc.GET_MODELS_CAR
          : ModelBloc.GET_MODELS_MOTORCYCLE);
}
