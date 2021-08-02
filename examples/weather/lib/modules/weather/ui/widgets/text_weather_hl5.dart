import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/modules/weather/ui/decorations/shadows.dart';

class TextWeatherHL5 extends StatelessWidget {
  const TextWeatherHL5({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: 24,
        color: Colors.white,
        shadows: defaultShadow(),
      ),
    );
  }
}