import 'package:coverlo/blocs/bloc.dart';
import 'package:coverlo/blocs/product_bloc.dart';

getProductApi(Bloc bloc, String uniqueID, String deviceUniqueIdentifier) async {
  bloc.connect({
    'uniqueID': uniqueID,
    'deviceUniqueIdentifier': deviceUniqueIdentifier,
  }, ProductBloc.GET_PRODUCTS);
}
