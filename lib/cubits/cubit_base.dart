import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MyCubit<S> extends Cubit<S> {
  MyCubit(S state) : super(state);
  Future<void> getData() async {
    throw UnimplementedError();
  }

  Type getInitState() {
    throw UnimplementedError();
  }

  Type getErrState() {
    throw UnimplementedError();
  }
}
