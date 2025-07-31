//  lib/widgets/gradient_app_bar.dart

import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final double height;
  final EdgeInsetsGeometry? leadingPadding;

  const GradientAppBar({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.icon,
    this.gradientColors = const [
      Color(0xFF1B5E20),
      Color(0xFF2E7D32),
      Color(0xFF4CAF50),
    ],
    this.height = 90.0, // Tinggi AppBar
    this.leadingPadding,
  });

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget = IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
      onPressed: () => Navigator.of(context).pop(),
    );

    if (leadingPadding != null) {
      leadingWidget = Padding(padding: leadingPadding!, child: leadingWidget);
    }

    return AppBar(
      elevation: 0,
      toolbarHeight: height, // Atur tinggi toolbar
      leading: leadingWidget,
      automaticallyImplyLeading: false, // Matikan tombol kembali default
      titleSpacing: 0, // Hapus spasi default pada title
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
