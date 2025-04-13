import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({Key? key}) : super(key: key);

  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  List<Map<String, dynamic>> _books = [];
  List<Map<String, dynamic>> _filteredBooks = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentMax = 20;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final data = await rootBundle.load('images/books_data.csv');
      final bytes = data.buffer.asUint8List();
      final result = await compute(_parseCSV, bytes);

      if (result.isEmpty) {
        throw Exception('الملف فارغ أو لا يحتوي على بيانات صالحة');
      }

      setState(() {
        _books = result;
        _filteredBooks = result.take(_currentMax).toList();
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      debugPrint('Error loading CSV: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'فشل تحميل البيانات: ${e.toString()}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: ${e.toString()}'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  static List<Map<String, dynamic>> _parseCSV(Uint8List bytes) {
    try {
      String csvData = utf8.decode(bytes);
      final lines = csvData.split('\n').where((line) => line.trim().isNotEmpty).toList();

      if (lines.isEmpty) return [];

      final csvParser = const CsvToListConverter(
        shouldParseNumbers: false,
        allowInvalid: false,
        eol: '\n',
        fieldDelimiter: ',',
      );

      final rows = csvParser.convert(lines.join('\n'));

      if (rows.isEmpty) return [];

      final headers = rows[0].map((cell) => cell?.toString().trim() ?? '').toList();

      return rows.skip(1).where((row) =>
        row.any((cell) => cell != null && cell.toString().trim().isNotEmpty)
      ).map((row) {
        final book = <String, dynamic>{};
        for (int j = 0; j < headers.length; j++) {
          book[headers[j]] = (j < row.length && row[j] != null)
              ? row[j].toString().trim()
              : '';
        }
        return book;
      }).toList();
    } catch (e) {
      debugPrint('CSV Parsing Error: $e');
      return [];
    }
  }

  void _searchBooks(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredBooks = _books.take(_currentMax).toList();
      });
      return;
    }

    final filtered = _books.where((book) {
      return book.values.any((value) =>
          value?.toString().toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();

    setState(() {
      _filteredBooks = filtered.take(_currentMax).toList();
    });
  }

  void _loadMore() {
    if (_filteredBooks.length >= _books.length) return;

    setState(() {
      _currentMax += 20;
      _filteredBooks = _books.take(_currentMax).toList();
    });
  }

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return;

    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في فتح الرابط: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بحث عن الكتب'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: 327,
              height: 38,
              decoration: ShapeDecoration(
                color: const Color(0xFFF9FAFA),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFF6E152E),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: TextField(
                controller: _searchController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'ابحث عن الكتاب',
                  hintStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF6E152E)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _searchBooks('');
                            setState(() {});
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  _searchBooks(value);
                  setState(() {});
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              ':رف الكتب',
              style: TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontFamily: 'Arabic Typesetting',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('جاري تحميل البيانات...'),
                      ],
                    ),
                  )
                : _hasError
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _initializeData,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      )
                    : _filteredBooks.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off, size: 48),
                                SizedBox(height: 16),
                                Text('لا توجد نتائج مطابقة للبحث'),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredBooks.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _filteredBooks.length) {
                                if (_filteredBooks.length < _books.length) {
                                  return Center(
                                    child: TextButton(
                                      onPressed: _loadMore,
                                      child: const Text('تحميل المزيد'),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              }

                              final book = _filteredBooks[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: ListTile(
                                  title: Text(
                                    book['book_title']?.toString() ?? 'بدون عنوان',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(book['book_author']?.toString() ?? 'مؤلف غير معروف'),
                                      if (book['book_rating'] != null)
                                        Row(
                                          children: [
                                            const Icon(Icons.star, color: Colors.amber, size: 16),
                                            const SizedBox(width: 4),
                                            Text(book['book_rating'].toString()),
                                          ],
                                        ),
                                      if (book['book_description'] != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            book['book_description'].toString(),
                                            style: const TextStyle(color: Colors.grey),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                    ],
                                  ),
                                  trailing: book['book_cover_photo_url'] != null
                                      ? IconButton(
                                          icon: const Icon(Icons.link),
                                          onPressed: () => _launchURL(book['book_cover_photo_url'].toString()),
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
