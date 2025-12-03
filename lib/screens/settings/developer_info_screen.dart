import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DeveloperInfoScreen extends StatelessWidget {
  const DeveloperInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geliştirici Bilgileri"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Geliştirici",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(LucideIcons.user, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Text(
                    "Mio Technic",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Bu uygulama tamamen ücretsiz olarak geliştirilmiştir.\n"
                "Görüş ve önerilerin için teşekkür ederim.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Icon(LucideIcons.mail, color: Colors.blue),
                  const SizedBox(width: 10),
                  const Text(
                    "destek@miotechnic.com",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Icon(LucideIcons.github, color: Colors.blue),
                  const SizedBox(width: 10),
                  const Text(
                    "github.com/miotechnic",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
