import 'package:flutter/material.dart';
import 'package:university_library/components/appbar.dart';
import 'package:university_library/components/appcolors.dart';
import 'package:university_library/components/approute.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

   
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), 
      end: Offset.zero, 
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        color: AppColors.gray100,
        child: Center(
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'UNIVERSITY OF RWANDA LIBRARY',
                    style: TextStyle(fontSize: 35, color: AppColors.blue500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'This platform helps students to get an Entrance in the library',
                    style: TextStyle(fontSize: 20, color: AppColors.gray700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context,Approute.entrance);
 
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Text('Entrance', style: TextStyle(color: AppColors.gray100)),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Approute.register);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Text('Register', style: TextStyle(color: AppColors.gray100)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
