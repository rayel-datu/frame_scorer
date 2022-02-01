import 'package:flutter_test/flutter_test.dart';
import 'package:frame_scorer/presentation/frame/bloc/frame_screen_cubit.dart';

main() {
  int gameId = 0;
  FrameScreenCubit frameScreenCubit = FrameScreenCubit(gameId);
  setUp(() {});


/// Initial cubit should have an initial not more or less than 10 Frames
/// last frame should have a value of isFinal true
  test('Initialize cubit', (){});
  test('Record score test', () {});
}
