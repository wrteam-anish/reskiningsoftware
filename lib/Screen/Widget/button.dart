import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onClick;

  const Button(
      {super.key,
      required this.icon,
      required this.title,
      required this.onClick});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 50,
      onPressed: onClick,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(icon),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              flex: 2,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
  }
}
