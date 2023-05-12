import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen(
      {super.key, required this.errorMessage, required this.icon, required this.size});

  final String errorMessage;
  // PASARLE UN ICON.ABC X EJEMPLO
  final IconData icon;

  final double size;
  @override
  State<ErrorScreen> createState() => _ErroScreenState();
}

class _ErroScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(widget.icon, size: widget.size),
        Text(
          widget.errorMessage,
          textAlign: TextAlign.center,
          style: AppTheme.errorMessageStyle,
        ),
        SizedBox(
          height: AppTheme.minHeight,
        ),
      ],
    );
  }
}
