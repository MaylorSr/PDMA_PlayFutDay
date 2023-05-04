import 'package:equatable/equatable.dart';

import '../../models/image_post_grid.dart';

enum ImagePostStatus { initial, success, failure }

class ImagePostState extends Equatable {
  const ImagePostState({
    this.status = ImagePostStatus.initial,
    this.imagePostGrid = const <ImagesPostGrid>[],
  });

  final ImagePostStatus status;
  final List<ImagesPostGrid> imagePostGrid;

  ImagePostState copyWith({
    ImagePostStatus? status,
    List<ImagesPostGrid>? imagePostGrid,
  }) {
    return ImagePostState(
      status: status ?? this.status,
      imagePostGrid: imagePostGrid ?? this.imagePostGrid,
    );
  }

  @override
  String toString() {
    return '''ImagePostState { status: $status, imagePostGrid: ${imagePostGrid.length} }''';
  }

  @override
  List<Object> get props => [status, imagePostGrid];
}
