import 'package:freezed_annotation/freezed_annotation.dart';

part 'solution.freezed.dart';
part 'solution.g.dart';

/// The correct solution to a mystery case.
/// 
/// Used to validate the player's accusation and calculate their score
/// based on how efficiently they solved the case.
@freezed
class Solution with _$Solution {
  const factory Solution({
    /// Character ID of the guilty party
    required String perpetratorId,

    /// The reason/motivation for the crime
    required String motive,

    /// How the crime was committed
    required String method,

    /// IDs of clues that prove the solution
    @Default([]) List<String> keyEvidence,

    /// The optimal sequence of location visits (for scoring)
    @Default([]) List<String> optimalPath,
  }) = _Solution;

  factory Solution.fromJson(Map<String, dynamic> json) =>
      _$SolutionFromJson(json);
}
