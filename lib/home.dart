import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BookSearchScreen.dart';

// Book model
class Book {
  final String title;
  final String author;
  final String image;

  Book({required this.title, required this.author, required this.image});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<home> {
  String selectedCategory = "";
  Map<String, List<Book>> books = {};
  bool isLoading = true;

  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    loadBooks();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 && !isFetchingMore) {
        loadMoreBooks();
      }
    });
  }

  Future<void> loadBooks() async {
    try {
      final fetchedBooks = await fetchBooks(page: currentPage);
      setState(() {
        books = fetchedBooks;
        selectedCategory = books.keys.first;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching books: $e");
    }
  }

  Future<void> loadMoreBooks() async {
    setState(() {
      isFetchingMore = true;
    });

    try {
      final moreBooks = await fetchBooks(page: currentPage + 1);
      if (moreBooks.isNotEmpty) {
        setState(() {
          books[selectedCategory]!.addAll(moreBooks["الكل"] ?? []);
          currentPage++;
        });
      }
    } catch (e) {
      print("Error fetching more books: $e");
    }

    setState(() {
      isFetchingMore = false;
    });
  }

  Future<Map<String, List<Book>>> fetchBooks({int page = 1}) async {
    final url = Uri.parse('https://search-engine-server-4qq9.vercel.app?page=$page');
    final response = await http.get(url);

    print('📦 Raw response: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      List<Book> allBooks = jsonData.map((item) => Book(
        title: item['book_title'] ?? 'No title',
        author: item['book_author'] ?? 'Unknown author',
        image: item['book_cover_photo_url'] ?? '',
      )).toList();

      return {
        "الكل": allBooks,
      };
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("المكتبة")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        controller: _scrollController,
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
            itemCount: books[selectedCategory]?.length ?? 0,
            itemBuilder: (context, index) {
              return _buildBookItem(books[selectedCategory]![index]);
            },
          ),
          if (isFetchingMore)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
        ],
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
        height: 40,
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
        children: books.keys.map((category) {
          return _buildCategoryButton(category);
        }).toList(),
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

  Widget _buildBookItem(Book book) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            book.image,
            width: 100,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 100),
          ),
          const SizedBox(height: 5),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              book.title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              book.author,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
