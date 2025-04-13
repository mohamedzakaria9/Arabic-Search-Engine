import 'package:flutter/material.dart';
import 'second_page.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: const MyHomePage(),
    );
  }
}
   

   
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
              child: Column(
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        "images/background.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // اللوجو في المنتصف
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "images/logo.png",
                    width: 150, // زيادة عرض اللوجو
                    height: 200, // زيادة ارتفاع اللوجو
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'مكتبة أفق',
                    style: TextStyle(
                      color: Color(0xFF6E152E),
                      fontSize: 60, // تكبير الخط
                      fontFamily: 'Arabic Typesetting',
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // نص "كتب توسع الآفاق" داخل البوكس المطلوب
                  Container(
                    width: 260,
                    height: 75,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF6E152E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.14),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'كتب توسع الآفاق',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35, // تكبير الخط
                        fontFamily: 'Arabic Typesetting',
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // إضافة المؤشرات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIndicator(const Color(0xFF6E152E)), // اللون الأول مختلف
                      const SizedBox(width: 5),
                      _buildIndicator(const Color(0xFFBD2853)),
                      const SizedBox(width: 5),
                      _buildIndicator(const Color(0xFFBD2853)),
                    ],
                  ),
                ],
              ),
            ),

            // زر "تخطي"
            Positioned(
              top: 70,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const second_page()),
                  );
                },
                child: Container(
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6E152E),
                    borderRadius: BorderRadius.circular(80),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
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
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}