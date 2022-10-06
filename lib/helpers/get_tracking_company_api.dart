import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/tracking_company_bloc.dart';

getTrackingCompanyApi(
    Bloc bloc, String uniqueID, String deviceUniqueIdentifier) async {
  bloc.connect({
    'uniqueID': uniqueID,
    'deviceUniqueIdentifier': deviceUniqueIdentifier,
  }, TrackingCompanyBloc.GET_TRACKING_COMPANIES);
}
