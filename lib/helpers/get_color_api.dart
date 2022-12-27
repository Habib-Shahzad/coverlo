import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/color_bloc.dart';
import 'package:coverlo/constants.dart';

getColorApi(Bloc bloc, String uniqueID, String deviceUniqueIdentifier,
    VehicleType vehicleType) async {
  bloc.connect(
      {
        'uniqueID': uniqueID,
        'deviceUniqueIdentifier': deviceUniqueIdentifier,
      },
      vehicleType == VehicleType.Car
          ? ColorBloc.GET_COLORS_VEHICLE
          : ColorBloc.GET_COLORS_MOTORCYCLE);
}
