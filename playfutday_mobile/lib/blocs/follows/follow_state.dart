// ignore: file_names
import 'package:equatable/equatable.dart';
import 'package:playfutday_flutter/models/models.dart';

enum AllFollowStatus { initial, success, failure }

class AllFollowState extends Equatable {
  const AllFollowState({
    this.status = AllFollowStatus.initial,
    this.allFollow = const <UserFollow>[],
    this.hasReachedMax = false,
  });

  final AllFollowStatus status;
  final List<UserFollow> allFollow;
  final bool hasReachedMax;

  AllFollowState copyWith({
    AllFollowStatus? status,
    List<UserFollow>? allFollow,
    bool? hasReachedMax,
  }) {
    return AllFollowState(
      status: status ?? this.status,
      allFollow: allFollow ?? this.allFollow,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''AllFollowState { status: $status, hasReachedMax: $hasReachedMax, allFollow: ${allFollow.length} }''';
  }

  @override
  List<Object> get props => [status, allFollow, hasReachedMax];
}
