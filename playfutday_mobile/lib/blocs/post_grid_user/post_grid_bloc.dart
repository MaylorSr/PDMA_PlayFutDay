import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/blocs/post_grid_user/post_grid_event.dart';
import 'package:playfutday_flutter/blocs/post_grid_user/post_grid_state.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../services/post_service/post_service.dart';

const throttleDuration = Duration(milliseconds: 500);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AllImagePostGridBloc extends Bloc<ImagePostGridEvent, ImagePostState> {
  AllImagePostGridBloc(this._postService, this.username)
      : super(const ImagePostState()) {
    on<AllImagePostGridFetched>(
      _onAllPostGridFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  // ignore: unused_field
  final PostService _postService;
  final String username;

  Future<void> _onAllPostGridFetched(
      AllImagePostGridFetched event, Emitter<ImagePostState> emitter) async {
    try {
      if (state.status == ImagePostStatus.initial) {
        final imagePostGrid = await _postService.getAllImageGridPost(username);
        return emitter(state.copyWith(
          status: ImagePostStatus.success,
          imagePostGrid: imagePostGrid,
        ));
      }

      final imagePostGrid = await _postService.getAllImageGridPost(username);

      emitter(state.copyWith(
        status: ImagePostStatus.success,
        imagePostGrid: List.of(state.imagePostGrid)..addAll(imagePostGrid!),
      ));
    } catch (_) {
      emitter(state.copyWith(status: ImagePostStatus.failure));
    }
  }
}
