import 'package:flutter/material.dart';
import 'package:frame_scorer/entities/frame.dart';
import 'package:frame_scorer/presentation/styles/app_text_styles.dart';

class FrameWidget extends StatelessWidget {
  const FrameWidget({
    Key? key,
    required this.frameNumber,
    required this.frame,
    this.isLastFrame = false,
  }) : super(key: key);

  final int frameNumber;
  final bool isLastFrame;
  final Frame frame;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Frame $frameNumber',
          style: AppTextStyles.normal_700(),
        ),
        SizedBox(
          width: 8,
        ),
        Row(
          children: _buildFrameScores(),
        )
      ],
    );
  }

  List<Widget> _buildFrameScores() {
    return frame.scores.map((e) {
      if (e == null) {
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Text(
            '$e',
            style: AppTextStyles.normal_700().copyWith(color: Colors.white),
          ),
        ),
      );
    }).toList();
  }
}
