import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_angle.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/view/game/archived_game_screen.dart';
import 'package:lichess_mobile/src/view/puzzle/puzzle_screen.dart';
import 'package:lichess_mobile/src/view/study/study_screen.dart';

Route<dynamic>? resolveAppLinkUri(BuildContext context, Uri appLinkUri) {
  if (appLinkUri.pathSegments.isEmpty) return null;

  switch (appLinkUri.pathSegments[0]) {
    case 'study':
      final id = appLinkUri.pathSegments[1];
      return StudyScreen.buildRoute(context, StudyId(id));
    case 'broadcast':
      final id = appLinkUri.pathSegments[3];
      final tab = BroadcastRoundTab.tabOrNullFromString(appLinkUri.fragment);
      return BroadcastRoundScreenLoading.buildRoute(context, BroadcastRoundId(id), initialTab: tab);
    case 'training':
      final id = appLinkUri.pathSegments[1];
      return PuzzleScreen.buildRoute(
        context,
        angle: PuzzleAngle.fromKey('mix'),
        puzzleId: PuzzleId(id),
      );
    case _:
      final gameId = GameId(appLinkUri.pathSegments[0]);
      final orientation = appLinkUri.pathSegments.getOrNull(2);
      // The game id can also be a challenge. Challenge by link is not supported yet so let's ignore it.
      if (gameId.isValid) {
        return ArchivedGameScreen.buildRoute(
          context,
          gameId: gameId,
          orientation: orientation == 'black' ? Side.black : Side.white,
        );
      }
  }

  return null;
}
