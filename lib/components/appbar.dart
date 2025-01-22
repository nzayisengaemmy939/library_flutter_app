import 'package:flutter/material.dart';
import 'package:university_library/components/appcolors.dart';
import 'package:university_library/components/approute.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  void showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Kinyarwanda'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: AppColors.gray100,
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Approute.home);
                  },
                  child: Image.asset(
                    "assets/images/ur.png",
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "University of Rwanda Library",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
                showLanguageDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
