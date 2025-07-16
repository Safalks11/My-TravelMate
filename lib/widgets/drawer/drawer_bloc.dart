import 'package:bloc/bloc.dart';
import 'package:main_project/controller/firebase_helper/firebase_helper.dart';
import 'package:meta/meta.dart';

part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc() : super(DrawerInitial()) {
    on<DrawerEvent>((event, emit) async {
      try {
        final firebaseHelper = FirebaseHelper();
        final userName = firebaseHelper.getUserName();
        emit(UserDetails(userName ?? 'null'));
      } catch (e) {}
    });
  }
}
