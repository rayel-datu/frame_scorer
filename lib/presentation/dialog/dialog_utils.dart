import 'package:flutter/material.dart';
import 'package:frame_scorer/presentation/styles/app_text_styles.dart';

class DialogUtils {
  static String gameFinishedRouteName = '/gameFinished';
  static String errorRouteName = '/error';

  static void showGameFinishedDialog(
    BuildContext context, {
    bool cancellable = false,
    int totalScore = 0,
    Function()? callback,
  }) =>
      showDialog(
        routeSettings: RouteSettings(name: gameFinishedRouteName),
        useRootNavigator: true,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Game Finished!',
                    style:
                        AppTextStyles.normal_700().copyWith(color: Colors.blue),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text('Total score: ${totalScore}'),
                  SizedBox(
                    height: 18,
                  ),
                  MaterialButton(
                    onPressed: callback ?? () {},
                    child: Text(
                      'Reset Game',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );

  static void dismissGameFinishedDialog(BuildContext context) =>
      Navigator.of(context, rootNavigator: true).popUntil(
          (Route<dynamic> route) =>
              route.settings.name != gameFinishedRouteName);

  static void showErrorDialog(BuildContext context,
          {bool cancellable = false, String message = ''}) =>
      showDialog(
        routeSettings: RouteSettings(name: errorRouteName),
        useRootNavigator: true,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Error!',
                    style:
                        AppTextStyles.normal_700().copyWith(color: Colors.red),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '$message',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  MaterialButton(
                    onPressed: () {
                      dismissErrorDialog(context);
                    },
                    child: Text(
                      'Dismiss',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );

  static void dismissErrorDialog(BuildContext context) =>
      Navigator.of(context, rootNavigator: true).popUntil(
          (Route<dynamic> route) => route.settings.name != errorRouteName);
}
