import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/make_bloc.dart';
import 'package:coverlo/constants.dart';

getMakeApi(Bloc bloc, String uniqueID, String deviceUniqueIdentifier,
    VehicleType vehicleType) async {
  bloc.connect(
      {
        'uniqueID': uniqueID,
        'deviceUniqueIdentifier': deviceUniqueIdentifier,
      },
      vehicleType == VehicleType.Car
          ? MakeBloc.GET_MAKES_VEHICLE
          : MakeBloc.GET_MAKES_MOTORCYCLE);
}
