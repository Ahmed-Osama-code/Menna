import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onESOMPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onMenuPressed;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterPressed;

  const CustomAppBar({
    super.key,
    this.onESOMPressed,
    this.onNotificationPressed,
    this.onMenuPressed,
    this.onSearchChanged,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF64CDC6), Color(0xFF136A88)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row:  Logo and Right Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo Section - Flexible to prevent overflow
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          height: 35,
                          width: 50,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'MindEase',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  // Right Icons Section - Shrink wrap to prevent overflow
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ESOS Button
                      GestureDetector(
                        onTap: onESOMPressed,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE07856), // Reddish color
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'ESOS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.phone, color: Colors.white, size: 12),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Notification Icon
                      GestureDetector(
                        onTap: onNotificationPressed,
                        child: SvgPicture.asset(
                          "assets/images/notification.svg",
                          width: 22,
                          height: 22,
                        ),
                      ),

                      SizedBox(width: 10),
                      // Menu Icon
                      GestureDetector(
                        onTap: onMenuPressed,
                        child: Icon(Icons.menu, color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Color(0xFFCCCCCC), size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onFilterPressed,
                      child: Icon(
                        Icons.tune,
                        color: Color(0xFFCCCCCC),
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(170);
}
