import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frame_scorer/entities/game.dart';
import 'package:frame_scorer/presentation/dialog/dialog_utils.dart';
import 'package:frame_scorer/presentation/frame/cubit/game_screen_cubit.dart';
import 'package:frame_scorer/presentation/frame/cubit/game_screen_state.dart';
import 'package:frame_scorer/presentation/styles/app_text_styles.dart';
import 'package:frame_scorer/presentation/widgets/frame_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameScreenCubit>(
      create: (context) => GameScreenCubit(game: Game(id: 1)),
      child: BlocConsumer<GameScreenCubit, GameScreenState>(
          listener: (context, state) {
        GameScreenCubit cubit = BlocProvider.of<GameScreenCubit>(context);
        if (state is GameScreenFinishedState) {
          DialogUtils.showGameFinishedDialog(
            context,
            totalScore: state.viewModel.totalScore,
            callback: () {
              cubit.reset();
              DialogUtils.dismissGameFinishedDialog(context);
            },
          );
        }
        if (state is GameScreenErrorState) {
          DialogUtils.showErrorDialog(context, message: state.message);
        }
      }, builder: (context, state) {
        GameScreenCubit cubit = BlocProvider.of<GameScreenCubit>(context);

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            actions: [
              MaterialButton(
                onPressed: () {
                  cubit.reset();
                },
                child: Text('RESET', style: TextStyle(color: Colors.blue)),
              )
            ],
            title: Text(
              'Bowling Score',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.separated(
                    itemCount: state.viewModel.frames.length,
                    itemBuilder: (context, index) => FrameWidget(
                        frameNumber: index + 1,
                        frame: state.viewModel.frames[index]),
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          onPressed: () {
                            cubit.roll(1);
                          },
                          child: Text('1')),
                      MaterialButton(
                          onPressed: () {
                            cubit.roll(2);
                          },
                          child: Text('2')),
                      MaterialButton(
                          onPressed: () {
                            cubit.roll(3);
                          },
                          child: Text('3')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          onPressed: () {
                            cubit.roll(4);
                          },
                          child: Text('4')),
                      MaterialButton(
                          onPressed: () {
                            cubit.roll(5);
                          },
                          child: Text('5')),
                      MaterialButton(
                          onPressed: () {
                            cubit.roll(6);
                          },
                          child: Text('6')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          onPressed: () {
                            cubit.roll(7);
                          },
                          child: Text('7')),
                      MaterialButton(
                          onPressed: () {
                            cubit.roll(8);
                          },
                          child: Text('8')),
                      MaterialButton(
                          onPressed: () {
                            cubit.roll(9);
                          },
                          child: Text('9')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          onPressed: () {
                            cubit.roll(10);
                          },
                          child: Text('Strike')),
                      MaterialButton(
                          onPressed: () {
                            cubit.roll(0);
                          },
                          child: Text('Gutter')),
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
