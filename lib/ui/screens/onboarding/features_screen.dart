import 'package:flutter/material.dart';

class FeaturesScreen extends StatefulWidget {
  static const routeName = '/features'; // used by router

  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _imagePaths = const [
    'assets/designs/welcome_followup_1.png',
    'assets/designs/welcome_followup_2.png',
    'assets/designs/welcome_followup_3.png',
  ];

  final List<Map<String, String>> _featureContent = const [
    {
      'title': 'GPS Tracking',
      'description': 'Never lose sight of your pet\'s location, no matter where they roam.',
    },
    {
      'title': 'Health Monitoring',
      'description': 'Track your pet\'s health and wellness with detailed insights.',
    },
    {
      'title': 'Activity Tracking',
      'description': 'Monitor your pet\'s daily activities and exercise patterns.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('MyPerro Features'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // --- PageView with images ---
          Expanded(
            flex: 3,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _imagePaths.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        _imagePaths[index],
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- Content below image ---
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    _featureContent[_currentPage]['title']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    _featureContent[_currentPage]['description']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Dots indicator
                  _Dots(count: _imagePaths.length, current: _currentPage),
                ],
              ),
            ),
          ),

          // --- Bottom Button ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < _imagePaths.length - 1) {
                    // Next page
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // FINAL PAGE: go to Sign In (Login)
                    // Use pushReplacementNamed to avoid coming back to Features with back button
                    Navigator.of(context).pushReplacementNamed('/login');

                    // Or if you want to clear the whole stack:
                    // Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5832A), // Brand orange
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  _currentPage < _imagePaths.length - 1 ? 'Next' : 'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int current;
  const _Dots({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    // Brand orange color
    const brandOrange = Color(0xFFF5832A);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 8,
          width: i == current ? 24 : 8,
          decoration: BoxDecoration(
            color: i == current ? brandOrange : brandOrange.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
