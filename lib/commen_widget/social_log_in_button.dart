import 'package:flutter/material.dart';

class SocialLogInButton extends StatelessWidget {
  final String butonText;
  final Color butonColor;
  final Color textColor;
  final double radius;
  final double yukseklik;
  final Widget butonIcon;
  final VoidCallback onPressed;

  const SocialLogInButton(
      {Key key,
      @required this.butonText,
      this.butonColor: Colors.blue,
      this.textColor: Colors.white,
      this.radius: 16,
      this.yukseklik: 40,
      this.butonIcon,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: Text(
        butonText,
        style: TextStyle(color: textColor),
      ),
      color: butonColor,
    );
  }
}
