import 'package:croissant/state.dart';
import 'package:croissant/theme/croissant_dark.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopupWidget extends StatelessWidget {
  const PopupWidget({Key? key, required this.inner}) : super(key: key);
  
  final Widget inner;

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<CState>(context).isWideScreen) {
      return Scaffold(body: inner);
    }

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 6,
        left: MediaQuery.of(context).size.width / 4,
        right: MediaQuery.of(context).size.width / 4,
      ),
      child: SizedBox(
        child: Column(
          children: [
            Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 1.5,
                  minWidth: MediaQuery.of(context).size.width / 1.5,
                ),
                child: inner,
              ),
              decoration: BoxDecoration(
                color: CroissantDark.background,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}