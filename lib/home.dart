import 'package:flutter/material.dart';
import 'BookSearchScreen.dart';


class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<home> {
  String selectedCategory = "كتب علمية";

  final Map<String, List<Map<String, String>>> books = {
   "كتب علمية": [
      {"title": "سيكولوجية الجماهير", "author": "غوستاف لوبون", "image": "https://cdn.abjjad.com/pub/b9bb9dd0-71d2-41e6-b84c-08f86d472aaf.png"},
      {"title": "في قلبي أنثى عبرية", "author": "روحي الخالدي","image": "https://cdn.abjjad.com/pub/503b3aa1-e855-40ed-92a3-81dc75d79f98.png"},
      {"title": "الفيزياء بين البساطة والدهاء", "author": "ضحى صالح", "image": "https://cdn.abjjad.com/pub/e716a266-8881-442c-b549-876620758ea9.png"},
    ],
    "كتب الأدب": [
      {"title": "العواصف", "author": " جبران خليل جبران ", "image": "https://cdn.abjjad.com/pub/1db71d0e-13d1-4a59-8d9a-ee6855129fcd.png"},
      {"title": "الخيميائي", "author": "باولو كويلو", "image": "https://cdn.abjjad.com/pub/40cee10c-4748-4815-8645-a896c6b5dd3f.png"},
      {"title": "وحي القلم", "author": "مصطفى صادق الرافعي","image": "https://cdn.abjjad.com/pub/c12e4c79-4855-4535-9090-0d29d6619ddf.png"},
      {"title": "كليلة ودمنة", "author": "بيدبا الفيلسوف الهندي", "image": "https://cdn.abjjad.com/pub/3bc95d9b-5286-4d77-9b99-62e95fa042c5.png"},
    
   
    ],
    "كتب تاريخية": [
      {"title": "الإلياذة", "author": "هوميروس", "image": "https://cdn.abjjad.com/pub/8c568eaf-dbf3-4fdf-b363-d62f05ce1fb5.png"},
      {"title": "المرأة في الجاهلية", "author": "حبيب زيات", "image": "https://cdn.abjjad.com/pub/4b035f60-a42d-4879-b28d-c2b2a5f273d7.png"},
      {"title": "أقوالنا وأفعالنا", "author": "محمد كرد علي ", "image": "https://cdn.abjjad.com/pub/418e2be4-d785-429e-8a12-6f764a77a728.png"},
      {"title": "هارون الرشيد", "author": "أحمد أمين ", "image": "https://cdn.abjjad.com/pub/4d194220-2f7b-4278-b6ce-8fc40957fec0.png"},
      {"title": "الأمير ", "author": "نيقولا مكيافيللي", "image": "https://cdn.abjjad.com/pub/c1389af7-f58a-492c-bf04-55bfe9fc5ebe.png"},
      {"title": "إبليس", "author": "عباس محمود العقاد ", "image": "https://cdn.abjjad.com/pub/d68a389b-6a02-4cac-ad12-4bec1d076dc7.png"},
      {"title": "أساطير إسكندنافية", "author": "نيل جايمان ", "image": "https://cdn.abjjad.com/pub/1a9b57fc-ec15-4503-be6e-ecf18c29f4e1.png"},

      
    ],
     "روايات وقصص": [
      {"title": "البؤساء", "author": "فيكتور هوغو", "image": "https://cdn.abjjad.com/pub/b82b4388-5306-4e43-8159-ffbbf42e252c.png"},
      {"title": "الجريمة والعقاب", "author": "دوستويفسكي", "image": "https://cdn.abjjad.com/pub/9bc49c23-2932-498e-89b6-d496fad6ccea.png"},
      {"title": "الف ليلة وليلة", "author": "مجهول", "image": "https://cdn.abjjad.com/pub/2f91c377-b8b6-4d67-bf8b-dc2e9f69e54b.png"},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("المكتبة")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  "images/Book in library image.png",
                  width: double.infinity,
                  height: 271,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 100,
                  child: Text(
                    'ابحث في عالم مليء بالكتب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Arabic Typesetting',
                      fontWeight: FontWeight.w400,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.84),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSearchBox(),
            const SizedBox(height: 20),
            _buildCategorySelector(),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.6,
              ),
              itemCount: books[selectedCategory]!.length,
              itemBuilder: (context, index) {
                return _buildBookItem(books[selectedCategory]![index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookSearchScreen()),
        );
      },
      child: Container(
        width: 327,
        height: 38,
        decoration: ShapeDecoration(
          color: const Color(0xFFF9FAFA),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: const Color(0xFF6E152E),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 8),
            Text("ابحث عن كتاب...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryButton("كتب علمية"),
           _buildCategoryButton("روايات وقصص"),
            _buildCategoryButton("كتب تاريخية"),
             _buildCategoryButton( "كتب الأدب"),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedCategory == category ? Colors.brown : Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: selectedCategory == category ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildBookItem(Map<String, String> book) {
    return Column(
      children: [
        Image.network(book["image"]!, width: 100, height: 150, fit: BoxFit.cover),
        const SizedBox(height: 5),
        Text(
          book["title"]!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          book["author"]!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}