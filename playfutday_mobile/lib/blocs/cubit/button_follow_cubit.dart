import 'package:bloc/bloc.dart';
import '../../services/user_service/user_service.dart';

part 'button_follow_state.dart';

class ButtonFollowCubit extends Cubit<ButtonFollowInitial> {
  ButtonFollowCubit(this.id, this.service)
      : super(ButtonFollowInitial(isFollow: false)) {
    showFollowState();
  }

  final String id;
  final UserService service;

  showFollowState() async {
    final followState = await service.getStateThatFollowUserByMe(id);
    bool isFollow = followState.toLowerCase() == "true";

    emit(ButtonFollowInitial(isFollow: isFollow));
    return isFollow;
  }

  addFollow() async {
    await service.addFollow(id);
    updateFollowState();
  }

  updateFollowState() async {
    final followState = await service.getStateThatFollowUserByMe(id);
    bool isFollow = followState.toLowerCase() == "true";

    emit(ButtonFollowInitial(isFollow: isFollow));
    return isFollow;
  }
}

