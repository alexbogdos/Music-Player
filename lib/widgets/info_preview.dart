import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoPreview extends StatelessWidget {
  const InfoPreview({
    Key? key,
    required this.logoSize,
    required this.panelColor,
    required this.shadowColor,
    required this.blurRadius,
    required this.secondaryColor,
    required this.name,
    required this.artist,
  }) : super(key: key);

  final double logoSize;
  final Color panelColor;
  final Color shadowColor;
  final double blurRadius;
  final Color secondaryColor;

  final String name;
  final String? artist;

  @override
  Widget build(BuildContext context) {
    final Image placeholderImage = Image.asset("assets/images/placeholder.png");

    return Column(
      children: [
        Container(
          width: logoSize,
          height: logoSize * 0.82,
          decoration: BoxDecoration(
            color: panelColor,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                offset: const Offset(8, 8),
                blurRadius: blurRadius,
              ),
            ],
          ),
          child: placeholderImage,
        ),
        Container(
          width: logoSize * 1.4,
          height: logoSize * 0.4,
          padding: EdgeInsets.only(top: logoSize * 0.1),
          child: Column(
            children: [
              Text(
                name,
                style: GoogleFonts.ubuntu(
                  fontSize: logoSize * 0.076,
                  fontWeight: FontWeight.w500,
                  color: secondaryColor.withOpacity(0.8),
                ),
              ),
              SizedBox(height: logoSize * 0.008),
              Text(
                artist.toString(),
                style: GoogleFonts.ubuntu(
                  fontSize: logoSize * 0.052,
                  fontWeight: FontWeight.w400,
                  color: secondaryColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
