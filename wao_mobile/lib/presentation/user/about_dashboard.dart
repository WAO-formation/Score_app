import 'package:flutter/material.dart';
import '../../shared/custom_text.dart';
import '../../shared/welcome_box.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/theme_data.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'About',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const AboutContent(),
    );
  }
}

class AboutContent extends StatelessWidget {
  const AboutContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WelcomeToWAO(title: 'About WAO'),
            const SizedBox(height: 40),

            // Overview
            const InfoSection(
              title: "Overview",
              content: "Founded in June 2012 by Solomon Kyei, Waoherds Limited is a pioneering force in the sports industry, introducing an innovative sport known as \"Wao!\" that blends physical gameplay with digital storytelling. Waoherds is committed to revolutionizing the sports landscape by integrating technology, community engagement, and entertainment to foster global unity and individual empowerment.",
            ),
            const SizedBox(height: 20),

            // Vision
            const InfoSection(
              title: "Vision",
              content: "To champion world oneness through innovative sports experiences that blend technology with traditional gameplay, creating a platform for personal and community development.",
            ),
            const SizedBox(height: 20),

            // Mission
            const InfoSection(
              title: "Mission",
              content: "Empowering individuals through world-class edutainment and sports development, leveraging Waoherd's success in sports as a catalyst for broader life achievements beyond the playing field.",
            ),
            const SizedBox(height: 20),

            // Business Description
            const InfoSection(
              title: "Business Description",
              content: "Waoherds has introduced \"WAO!\" – a two-ball hand-controlled multiple-scoring contact sport played on the unique WaoSphere, a digitized spherical pitch. This innovative sport allows players to engage in dynamic gameplay while integrating storytelling elements that resonate with global audiences. The sport encourages creativity, teamwork, and physical activity, appealing to a wide demographic from schools to professional leagues.",
            ),
            const SizedBox(height: 20),

            // For Players
            const InfoSection(
              title: "For Players",
              content: "Wao! is a sport of skills, critical thinking and strategy. Teams deploy different strategies in a single game in order to dominate the two balls and is interesting on its own. The competition is more and creativity is demanded of all Players. A Player has to demonstrate multitasking character and be at least two times smarter than one ball sport Player or single focus Athlete to be exceptional! There are many things to be happy about playing two balls concurrently on the same pitch -WaoSphere.",
            ),
            const SizedBox(height: 20),

            // For Audience
            const InfoSection(
              title: "For Audience",
              content: "\"Our eyes naturally want to survey several features at once.\" \"The brain can simultaneously keep track of two separate goals.\" -researchers have proved. So, playing 2 balls concurrently bring more fun, engagement and satisfaction. Wao! audience can enjoy multi-focusing on the 2 balls or can keep focus on the most critical interactions on a particular ball that s/he really enjoy at a juncture. Techthrills replays all catchy moments instantly on the WaoSphere all eyes are gazed watching the game in case you miss sight on anything wow. Playing 2 balls bring to the sport an unending shout of amazement; by the time shouting at an amazing display fades the other catches the fever! This is a multitasking mental exercise that trains both Players and Audience for life beyond the sport.",
            ),
            const SizedBox(height: 20),

            // Products and Services
            const InfoSection(
              title: "Products and Services",
              content: "• Wao Balls: High-quality sports equipment tailored for Wao gameplay\n\n• Wao Jerseys and Shoes: Branded merchandise sold through online and offline channels\n\n• Technological Equipment: Sales and leasing of digital equipment essential for Wao gameplay\n\n• Video Game Versions: Licensing and sales of digital adaptations of Wao for gaming platforms\n\n• Paraphernalia: Accessories such as bags, socks, and fashion items featuring the Waoherd logo\n\n• Sponsorship, Events, Tickets, Franchises, Membership Dues, and Donations",
            ),
            const SizedBox(height: 20),

            // Achievements and Milestones
            const InfoSection(
              title: "Achievements and Milestones",
              content: "• Developed and established Wao as a recognized sport in Ghana, gaining traction in schools and local communities\n\n• Received accolades for innovation in sports technology and community engagement\n\n• Expanded Waoherd's presence nationally, laying the groundwork for future international expansion",
            ),
            const SizedBox(height: 20),

            // Market Position
            const InfoSection(
              title: "Market Position and Industry Impact",
              content: "Waoherds has carved out a unique niche in the Ghanaian sports industry, combining physical sports with digital storytelling to attract a diverse audience. The company's innovative approach has sparked interest globally, positioning Waoherds as a leader in sports innovation and technology integration.",
            ),
            const SizedBox(height: 20),

            // CSR
            const InfoSection(
              title: "Corporate Social Responsibility",
              content: "Waoherds is committed to community development through sports, partnering with NGOs and educational institutions to promote physical fitness, teamwork, and leadership skills among youth. CSR initiatives focus on creating inclusive spaces for sports education and fostering local talent through grassroots programs.",
            ),
            const SizedBox(height: 20),

            // Leadership
            const InfoSection(
              title: "Leadership and Team",
              content: "Led by founder Solomon Kyei, Waoherds boasts a dedicated team of sports enthusiasts, technology innovators, and community advocates. The leadership team combines expertise in sports management, technology development, and business strategy to drive Waoherd's growth and impact.",
            ),
            const SizedBox(height: 20),

            // Future Goals
            const InfoSection(
              title: "Future Goals and Expansion Plans",
              content: "Waoherds aims to expand its footprint internationally, establishing Wao! as a global sport that bridges cultural divides and promotes unity. Future plans include launching digital enhancements to Wao gameplay, expanding merchandise lines, and scaling up event management capabilities to meet growing demand.",
            ),

            const SizedBox(height: 40.0),


            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "CONTACT US",
                      style: AppStyles.secondaryTitle
                  ),
                  const SizedBox(height: 16.0),

                  // Website
                  Row(
                    children: [
                      Icon(
                        Icons.public,
                        size: 20.0,
                        color: lightColorScheme.secondary,
                      ),
                      const SizedBox(width: 12.0),

                      Text(
                          "www.waosport.com",
                          style: AppStyles.informationText
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),

                  // Email
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 20.0,
                        color: lightColorScheme.secondary,
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                          "waosport@gmail.com",
                          style: AppStyles.informationText
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),

                  // Phone
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 20.0,
                        color: lightColorScheme.secondary,
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                          "+233 242 786 261",
                          style: AppStyles.informationText
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0),

                  // Social Media Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Facebook
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: lightColorScheme.secondary,
                              )
                          ),
                          child: Icon(
                            Icons.facebook,
                            size: 20.0,
                            color: lightColorScheme.secondary,
                          ),
                        ),
                      ),

                      // Twitter/X
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: lightColorScheme.secondary,
                              )
                          ),
                          child: Icon(
                            Icons.sports_basketball,
                            size: 20.0,
                            color: lightColorScheme.secondary,
                          ),
                        ),
                      ),

                      // Instagram
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: lightColorScheme.secondary,
                              )
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 20.0,
                            color: lightColorScheme.secondary,
                          ),
                        ),
                      ),

                      // YouTube
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: lightColorScheme.secondary,
                              )
                          ),
                          child: Icon(
                            Icons.play_circle_fill,
                            size: 20.0,
                            color: lightColorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
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

class InfoSection extends StatelessWidget {
  final String title;
  final String content;

  const InfoSection({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              color: lightColorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppStyles.informationText
          ),
        ],
      ),
    );
  }
}