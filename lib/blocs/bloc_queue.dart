import 'package:coverlo/constants.dart';
import 'package:coverlo/globals.dart';
import 'package:coverlo/pairbloc.dart';

checkBlocsQueue() {
  if (StaticGlobal.blocs.value.isNotEmpty) {
    PairBloc pairBloc = StaticGlobal.blocs.value.first;
    if (pairBloc.status == COMPLETED) {
      StaticGlobal.blocs.value.removeAt(0);
    }
    if (StaticGlobal.blocs.value.isNotEmpty) {
      pairBloc = StaticGlobal.blocs.value.first;
      if (pairBloc.status == WAITING) {
        pairBloc.status = RUNNING;
        StaticGlobal.blocs.value.removeAt(0);
        StaticGlobal.blocs.value.insert(0, pairBloc);
        pairBloc.func();
      }
    }
  }
}
