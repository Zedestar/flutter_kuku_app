import 'package:flutter/material.dart';
import 'package:kuku_app/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Welcome to Kuku App',
      description: 'Your one-stop solution for poultry farming',
      image: 'assets/images/defaultPic.jpg',
    ),
    OnboardingContent(
      title: 'Expert Advice',
      description: 'Get professional guidance from experienced veterinarians',
      image: 'assets/images/defaultPic.jpg',
    ),
    OnboardingContent(
      title: 'Community Support',
      description: 'Connect with other farmers and share experiences',
      image: 'assets/images/defaultPic.jpg',
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home-page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _contents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _contents[index].image,
                          height: 300,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _contents[index].title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kcolor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _contents[index].description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _contents.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 5),
                        height: 8,
                        width: _currentPage == index ? 20 : 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: _currentPage == index ? kcolor : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  if (_currentPage < _contents.length - 1) ...[
                    ElevatedButton(
                      onPressed: _completeOnboarding,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kcolor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child: Text("Skip"),
                    )
                  ],
                  ElevatedButton(
                    onPressed: _currentPage == _contents.length - 1
                        ? _completeOnboarding
                        : () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kcolor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: Text(
                      _currentPage == _contents.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final String image;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
  });
}
