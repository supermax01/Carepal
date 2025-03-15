import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'infographics_screen.dart';

class LearnCirrhosisScreen extends StatelessWidget {
  final String? initialScreen;

  const LearnCirrhosisScreen({
    super.key,
    this.initialScreen,
  });

  Future<void> _launchEducationalArticle() async {
    const url = 'https://www.uptodate.com/contents/cirrhosis-beyond-the-basics';
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchWebinar() async {
    const url = 'https://www.youtube.com/watch?v=nRDgNxQmBIo&t=9s';
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchNewsWebsite() async {
    const url = 'https://liverfoundation.org';
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchResearchPaper() async {
    const url = 'https://pmc.ncbi.nlm.nih.gov/articles/PMC9476861/';
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialScreen == 'infographics') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InfographicsScreen()),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF056E55)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Educational Resources',
          style: TextStyle(
            color: Color(0xFF056E55),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('lib/images/profile_picture.png'),
            radius: 20,
          ),
          SizedBox(width: 16),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Carepal is also a pool of resources for Cirrhosis and other liver diseases, empowering you to take informed decisions.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              _buildResourceCard(
                title: 'Educational Articles',
                description: 'Browse through our library.',
                icon: Icons.menu_book_rounded,
                useIcon: true,
                onTap: _launchEducationalArticle,
              ),
              _buildResourceCard(
                title: 'Video Tutorials',
                description: 'Learn through tutorials.',
                icon: Icons.play_circle_filled_rounded,
                useIcon: true,
                onTap: _launchYouTubePlaylist,
              ),
              _buildResourceCard(
                title: 'Infographics and Visuals',
                description: 'Data in your hands.',
                icon: Icons.bar_chart_rounded,
                useIcon: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InfographicsScreen()),
                  );
                },
              ),
              _buildResourceCard(
                title: 'Webinars & Live Sessions',
                description: 'Watch the live sessions here.',
                icon: Icons.video_camera_front_rounded,
                useIcon: true,
                onTap: _launchWebinar,
              ),
              _buildResourceCard(
                title: 'Research Papers',
                description: 'Leading research on Liver Cirrhosis',
                icon: Icons.science_rounded,
                useIcon: true,
                onTap: _launchResearchPaper,
              ),
              _buildResourceCard(
                title: 'News on Cirrhosis',
                description: 'Stay up to date on new developments.',
                icon: Icons.newspaper_rounded,
                useIcon: true,
                onTap: _launchNewsWebsite,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard({
    required String title,
    required String description,
    IconData? icon,
    String? imagePath,
    bool useIcon = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF056E55).withOpacity(0.1)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(16),
                color: const Color(0xFFF5F5F5),
                child: Center(
                  child: useIcon && icon != null
                      ? Icon(icon, size: 60, color: const Color(0xFF056E55))
                      : Image.asset(
                          imagePath!,
                          width: 88,
                          height: 88,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchYouTubePlaylist() async {
    const url = 'https://www.youtube.com/watch?v=C1rZEGut0qk';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
