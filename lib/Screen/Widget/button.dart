import 'package:flutter/material.dart';
import 'package:reskinner_new/Theme/theme.dart';

class Button extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function()? onClick;

  const Button(
      {super.key, required this.icon, required this.title, this.onClick});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: MaterialButton(
        minWidth: double.infinity,
        height: 50,
        onPressed: onClick,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    color: AppTheme.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: AppTheme.borderColor, width: 1.5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(icon),
                )),
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
      ),
    );
  }
}
