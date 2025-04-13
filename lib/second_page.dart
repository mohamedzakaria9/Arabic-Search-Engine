import 'package:flutter/material.dart';
import 'third_page.dart';
// استيراد الصفحة الثالثة

class second_page extends StatelessWidget {
  const second_page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
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

            // زر "تخطي"
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => third_page()),
                  );
                },
                child: Container(
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color(0xFF6E152E),
                    borderRadius: BorderRadius.circular(80),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'تخطي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // المحتوى الرئيسي
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSection("رسالتنا:", "images/resala icon.png", "احداث نهضة في قراءة اللغة العربية عبر وصول تطبيق مكتبة أفق الى جميع المهتمين بالقراءة في الوطن العربي، شاملة أبناء الجاليات العربية في الدول الأجنبية ومتعلّمي اللغة العربية من الناطقين بغيرها."),
                  SizedBox(height: 20),
                  _buildSection("رؤيتنا:", "images/eye icon.png", "غرس حب قراءة اللغة العربية لدى الأفراد لكافة الأعمار."),
                  SizedBox(height: 20),
                  _buildSection("هدفنا:", "images/goal icon.png", "الارتقاء بوعي القراء العرب إلى المستوى العالمي ورفع مستوى المعرفة والعلم والثقافة والقيم في نفوسهم لتكوين أجيال مبدعة في جميع المجالات."),
                  SizedBox(height: 30),

                  // المؤشرات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIndicator(Color(0xFFBD2853)),
                     
                      SizedBox(width: 5),
                      _buildIndicator(Color(0xFF6E152E)),
                       SizedBox(width: 5),
                      _buildIndicator(Color(0xFFBD2853)),
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

  Widget _buildSection(String title, String iconPath, String content) {
    return Container(
      width: 350,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF6E152E), width: 2),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                iconPath,
                width: 50, // تكبير الأيقونة
                height: 50,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF6E152E),
                  fontSize: 42.56,
                  fontFamily: 'Arabic Typesetting',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            content,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xFF4B4B4B),
              fontSize: 18, // تكبير خط المحتوى
              fontFamily: 'Abyssinica SIL',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
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
