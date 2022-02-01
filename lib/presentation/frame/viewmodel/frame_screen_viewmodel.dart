import 'package:frame_scorer/entities/frame.dart';

class FrameScreenViewModel {
  FrameScreenViewModel(int gameId)
      : frames = List.generate(
            10,
            (index) => Frame(
                  id: index,
                  gameId: gameId,
                  isFinal: index == 9, // should be true on last item
                ));
  final List<Frame> frames;
}
