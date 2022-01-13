import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  CircleButton({ Key? key, this.child, this.onClick }) : super(key: key);

  Widget? child = Container();
  Function? onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: child,
      ),
      onTap: () => onClick != null ? onClick!() : null,
    );
  }

}