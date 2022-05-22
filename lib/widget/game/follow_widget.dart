import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/screen/base/simple_screen.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';

class FollowWidget extends StatelessWidget {
  final ValueChanged<FollowType> onFollow;

  const FollowWidget({
    required this.onFollow,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilder: (context, theme, localization) => SimpleScreen(
        transparant: true,
        child: MenuBox(
          title: 'Follow', // TODO
          child: Center(
            heightFactor: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CyclingEscapeButton(
                  type: CyclingEscapeButtonType.green,
                  text: localization.followFollow,
                  onClick: () => onFollow(FollowType.follow),
                ),
                CyclingEscapeButton(
                  type: CyclingEscapeButtonType.blue,
                  text: localization.followLeave,
                  onClick: () => onFollow(FollowType.leave),
                ),
                CyclingEscapeButton(
                  type: CyclingEscapeButtonType.yellow,
                  text: localization.followAuto,
                  onClick: () => onFollow(FollowType.autoFollow),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
