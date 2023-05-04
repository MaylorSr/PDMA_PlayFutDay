import 'package:equatable/equatable.dart';

abstract class ImagePostGridEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AllImagePostGridFetched extends ImagePostGridEvent {}
