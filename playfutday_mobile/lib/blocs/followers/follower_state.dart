// ignore: file_names
import 'package:equatable/equatable.dart';
import 'package:playfutday_flutter/models/models.dart';

enum AllFollowerStatus { initial, success, failure }

class AllFollowerState extends Equatable {
  const AllFollowerState({
    this.status = AllFollowerStatus.initial,
    this.allFollower = const <UserFollow>[],
    this.hasReachedMax = false,
  });

  final AllFollowerStatus status;
  final List<UserFollow> allFollower;
  final bool hasReachedMax;

  AllFollowerState copyWith({
    AllFollowerStatus? status,
    List<UserFollow>? allFollower,
    bool? hasReachedMax,
  }) {
    return AllFollowerState(
      status: status ?? this.status,
      allFollower: allFollower ?? this.allFollower,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''AllFollowerState { status: $status, hasReachedMax: $hasReachedMax, allFollower: ${allFollower.length} }''';
  }

  @override
  List<Object> get props => [status, allFollower, hasReachedMax];
}
