import 'package:flutter/material.dart';

class AppPrimaryButton extends StatefulWidget {
  const AppPrimaryButton(
      {required this.child,
        Key? key,
        this.onPressed,
        this.height,
        this.width,
        this.color,
        this.shape,
        this.padding,
        this.textStyle,
        this.textColor})
      : super(key: key);

  final ShapeBorder? shape;
  final Widget child;
  final VoidCallback? onPressed;
  final double? height, width;
  final Color? color;
  final Color? textColor;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  @override
  AppPrimaryButtonState createState() => AppPrimaryButtonState();
}

class AppPrimaryButtonState extends State<AppPrimaryButton> {
  bool _isLoading = false;

  void showLoader() {
    setState(() {
      _isLoading = true;
    });
  }

  void hideLoader() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color ?? theme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        disabledForegroundColor: Colors.white,
        minimumSize: Size(widget.width ?? 74, widget.height ?? 48),
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16,),
        textStyle: widget.textStyle ??
            const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500),
      ),
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}


