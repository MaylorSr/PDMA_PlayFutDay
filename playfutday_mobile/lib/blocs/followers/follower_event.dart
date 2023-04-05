// ignore: file_names
import 'package:equatable/equatable.dart';

abstract class AllFollowerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AllFollowerFetched extends AllFollowerEvent {}
