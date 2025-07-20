import 'package:proci/screens/onboarding/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:math';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool _isLastPage = false;

  void _onDone() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const TermsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundDecor(),
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _isLastPage = index == 2);
            },
            children: const [
              _OnboardingPage(
                icon: Icons.search_rounded,
                title: 'Find Trusted Local Pros',
                subtitle: 'From plumbing to painting, connect with skilled and reviewed service providers right in your neighborhood.',
              ),
              _OnboardingPage(
                icon: Icons.calendar_month_rounded,
                title: 'Book & Manage with Ease',
                subtitle: 'Schedule jobs, chat directly with your provider, and track all your appointments in one simple place.',
              ),
              _OnboardingPage(
                icon: Icons.business_rounded,
                title: 'Grow Your Business',
                subtitle: 'Are you a service provider? Reach more customers, manage your schedule, and build your online reputation.',
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: _onDone, child: const Text('SKIP')),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    dotColor: Colors.grey.shade400,
                    activeDotColor: Theme.of(context).primaryColor,
                  ),
                ),
                _isLastPage
                    ? TextButton(onPressed: _onDone, child: const Text('GET STARTED'))
                    : TextButton(
                        onPressed: () => _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        ),
                        child: const Text('NEXT'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<_OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return FadeTransition(
    opacity: _fadeIn,
    child: SlideTransition(
      position: _slideIn,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Theme.of(context).primaryColor.withOpacity(0.05),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                size: 120,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.subtitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

}

class _BackgroundDecor extends StatelessWidget {
  const _BackgroundDecor();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: _TopWaveClipper(),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.15),
                  Theme.of(context).primaryColor.withOpacity(0.05),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: -30,
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: -20,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 150,
          left: 30,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          right: 50,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width / 2, size.height, size.width, size.height * 0.6,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}