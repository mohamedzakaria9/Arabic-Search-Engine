import 'package:flutter/material.dart';
import 'login.dart'; // تأكد من استيراد صفحة تسجيل الدخول

class third_page extends StatelessWidget {
  const third_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            // الخلفية
            Positioned.fill(
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  "images/background.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            // المحتوى الرئيسي
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "images/logo.png",
                    width: 120, // زيادة حجم اللوجو
                    height: 180,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'مكتبة | Ofuq',
                    style: TextStyle(
                      color: Color(0xFF6E152E),
                      fontSize: 60,
                      fontFamily: 'Arabic Typesetting',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'تجربة متميزة لتغذية العقول تفتح لك أبواب المعرفة والثقافة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF949494),
                      fontSize: 20,
                      fontFamily: 'Abyssinica SIL',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // زر "ابدأ"
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const login()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6E152E),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                    child: const Text(
                      'ابدأ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontFamily: 'Arabic Typesetting',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // المؤشرات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIndicator(const Color(0xFFBD2853)),
                      const SizedBox(width: 5),
                      _buildIndicator(const Color(0xFFBD2853)),
                      const SizedBox(width: 5),
                      _buildIndicator(const Color(0xFF6E152E)),
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

  Widget _buildIndicator(Color color) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
