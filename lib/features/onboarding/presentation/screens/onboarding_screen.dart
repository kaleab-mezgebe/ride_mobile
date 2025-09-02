import 'package:flutter/material.dart';
import '../../../auth/presentation/screens/phone_register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Anywhere you are",
      "subtitle":
          "Book a ride quickly and easily, wherever you are. Our drivers are always close by.",
      "image": "assets/images/onboard1.png",
    },
    {
      "title": "At anytime",
      "subtitle":
          "Day or night, our ride-hailing service is available 24/7 to take you where you need to go.",
      "image": "assets/images/onboard2.png",
    },
    {
      "title": "Book your car",
      "subtitle":
          "Choose your pickup and dropoff, confirm, and your ride will be on the way in minutes.",
      "image": "assets/images/onboard3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildPageContent(context, index, theme);
              },
            ),
            if (_currentIndex < onboardingData.length - 1)
              Positioned(top: 15, right: 20, child: _buildSkipButton(theme)),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: _buildNextButton(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(BuildContext context, int index, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 60),
          Image.asset(
            onboardingData[index]['image']!,
            height: 250,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Text(
            onboardingData[index]['title']!,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              onboardingData[index]['subtitle']!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 40),
          _buildDotsIndicator(theme),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildDotsIndicator(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingData.length,
        (dotIndex) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentIndex == dotIndex ? 24 : 8,
          decoration: BoxDecoration(
            color:
                _currentIndex == dotIndex
                    ? theme.colorScheme.primary
                    : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton(ThemeData theme) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PhoneRegisterScreen()),
        );
      },
      child: Text(
        "Skip",
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onBackground,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNextButton(ThemeData theme) {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (_currentIndex < onboardingData.length - 1) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PhoneRegisterScreen()),
            );
          }
        },
        child: Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Center(child: _getNextImage()),
        ),
      ),
    );
  }

  Widget _getNextImage() {
    if (_currentIndex == onboardingData.length - 1) {
      return Image.asset("assets/images/final.png", height: 60, width: 60);
    } else if (_currentIndex == 0) {
      return Image.asset("assets/images/first.png", height: 60, width: 60);
    } else {
      return Image.asset("assets/images/second.png", height: 60, width: 60);
    }
  }
}
