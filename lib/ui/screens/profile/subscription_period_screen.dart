import 'package:flutter/material.dart';

// Design tokens
const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);
const _grey600 = Color(0xFF8E8E8E);
const _grey300 = Color(0xFFE9E9E9);

class SubscriptionPeriodScreen extends StatelessWidget {
  const SubscriptionPeriodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: _grey900, size: 20),
        ),
        title: const Text(
          'Subscription Period',
          style: TextStyle(
            color: _grey900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subscription Period Left Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subscription Period Left',
                    style: TextStyle(
                      fontSize: 14,
                      color: _grey600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '3 Months',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Subscription Packs Title
            const Text(
              'Subscription Packs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _grey900,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Subscription Cards
            Expanded(
              child: Row(
                children: [
                  // Starter Pack
                  Expanded(
                    child: _SubscriptionCard(
                      title: 'Starter Pack',
                      duration: '3 Months',
                      features: const [
                        'GPS Tracking',
                        'Basic Health Monitoring',
                        'Activity Tracker',
                        'Basic Pet Management',
                        'Collar Health Management',
                        'Lost Pet Tracking',
                      ],
                      buttonText: 'Subscribe',
                      isRecommended: false,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Lifetime Pack (Recommended)
                  Expanded(
                    child: _SubscriptionCard(
                      title: 'Lifetime Pack',
                      duration: 'Lifetime',
                      features: const [
                        'GPS Tracking',
                        'Advanced Health Monitoring',
                        'Activity Tracker',
                        'Data Analytics',
                        'Collar Health Management',
                        'Emergency Alerts',
                        'Lost Pet Tracking',
                      ],
                      buttonText: 'Subscribe',
                      isRecommended: true,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Yearly Pack
                  Expanded(
                    child: _SubscriptionCard(
                      title: 'Yearly Pack',
                      duration: '1 Year',
                      features: const [
                        'GPS Tracking',
                        'Health Monitoring',
                        'Activity Tracker',
                        'Basic Analytics',
                        'Collar Health Management',
                        'Lost Pet Tracking',
                      ],
                      buttonText: 'Subscribe',
                      isRecommended: false,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final String title;
  final String duration;
  final List<String> features;
  final String buttonText;
  final bool isRecommended;
  final VoidCallback onTap;

  const _SubscriptionCard({
    required this.title,
    required this.duration,
    required this.features,
    required this.buttonText,
    required this.isRecommended,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isRecommended 
          ? Border.all(color: _brandOrange, width: 2)
          : Border.all(color: _grey300),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _grey900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 12,
              color: _grey600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Features List
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _grey700,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
          
          // Subscribe Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: isRecommended ? _brandOrange : _grey300,
                foregroundColor: isRecommended ? Colors.white : _grey700,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
