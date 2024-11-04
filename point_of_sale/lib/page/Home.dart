import 'dart:async';
import 'package:flutter/material.dart';
import 'package:point_of_sale/page/Sales/SalesDetails.dart';

import 'package:point_of_sale/page/branch/AllBranchView.dart';
import 'package:point_of_sale/page/category/AllCategoryView.dart';
import 'package:point_of_sale/page/product/AllProductView.dart';
import 'package:point_of_sale/page/supplier/AllSupplierView.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  int _carouselIndex = 0;
  late PageController _pageController;
  Timer? _timer;

  static const List<String> _texts = [
    "মাসিক ও বার্ষিক প্যাকেজে ব্যাবসার সকল প্রয়োজনীয় \nফিচার নিয়ে দ্রুত ব্যবস্থপনায় এগিয়ে থাকুন।",
    "মাত্র ১৯৯ টাকায় ৬০% ছাড়ে মাসব্যাপি\nস্মাট ম্যানেজমেন্ট আরও সহজ, আরও দ্রুত।",
    "সারা বছরের নিশ্চিত ব্যাবস্থাপনা মাত্র ১৯৯ টাকায় \n৮০% ছাড়ে ব্যাবসার উন্নয়নে ফ্রী সব ফিচার সমূহ।"
  ];

  static const List<Color> _colors = [
    Colors.redAccent,
    Colors.lightBlueAccent,
    Colors.greenAccent,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPageChange();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPageChange() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _carouselIndex = (_carouselIndex + 1) % _texts.length;
      });
      _pageController.animateToPage(
        _carouselIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  final List<Map<String, String>> myItems = [
    {"img": "https://cdn-icons-png.flaticon.com/128/7466/7466065.png", "title": "Products"},
    {"img": "https://cdn-icons-png.flaticon.com/128/9119/9119160.png", "title": "Customers"},
    {"img": "https://cdn-icons-png.flaticon.com/128/10103/10103393.png", "title": "Purchase"},
    {"img": "https://cdn-icons-png.flaticon.com/128/3211/3211610.png", "title": "Sale"},
    {"img": "https://cdn-icons-png.flaticon.com/128/7661/7661842.png", "title": "Purchase List"},
    {"img": "https://cdn-icons-png.flaticon.com/128/6632/6632834.png", "title": "Sales List"},
    {"img": "https://cdn-icons-png.flaticon.com/128/3534/3534063.png", "title": "Reports"},
    {"img": "https://cdn-icons-png.flaticon.com/128/7314/7314637.png", "title": "Profit/Loss"},
    {"img": "https://cdn-icons-png.flaticon.com/128/2738/2738236.png", "title": "Due List"},
    {"img": "https://cdn-icons-png.flaticon.com/128/15917/15917216.png", "title": "Stock List"},
    {"img": "https://cdn-icons-png.flaticon.com/128/1728/1728912.png", "title": "Ledger"},
    {"img": "https://cdn-icons-png.flaticon.com/128/407/407826.png", "title": "Warehouse"},
    {"img": "https://cdn-icons-png.flaticon.com/128/3135/3135679.png", "title": "Income"},
    {"img": "https://cdn-icons-png.flaticon.com/128/3886/3886981.png", "title": "Expense"},
    {"img": "https://cdn-icons-png.flaticon.com/128/10364/10364864.png", "title": "Mortgage"},
    {"img": "https://cdn-icons-png.flaticon.com/128/10686/10686242.png", "title": "Tax Reports"},
    {"img": "https://cdn-icons-png.flaticon.com/128/17718/17718145.png", "title": "User Role"},
    {"img": "https://cdn-icons-png.flaticon.com/128/12668/12668466.png", "title": "Manufacture"},
    {"img": "https://cdn-icons-png.flaticon.com/128/1362/1362944.png", "title": "Category"},
    {"img": "https://cdn-icons-png.flaticon.com/128/3321/3321752.png", "title": "Supplier"},
    {"img": "https://cdn-icons-png.flaticon.com/128/13163/13163163.png", "title": "Branch"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                "https://i.postimg.cc/GhsGhb3K/0050785.jpg",
              ),
            ),
            const SizedBox(width: 10),
            const Text("Towhid Medical"),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreenAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        actions: [
          IconButton(
            onPressed: () {}, // Add your functionality here
            icon: const Icon(Icons.phone, color: Colors.lightGreenAccent),
          ),
          IconButton(
            onPressed: () {}, // Add your functionality here
            icon: const Icon(Icons.video_collection_sharp, color: Colors.red),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              // Carousel
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                child: Container(
                  height: 80,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _texts.length,
                    onPageChanged: (index) {
                      setState(() {
                        _carouselIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        color: _colors[index],
                        child: Center(
                          child: Text(
                            _texts[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // GridView
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: myItems.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (index == 18) {  // Navigate to Category
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllCategoryView()),
                          );
                        } else if (index == 19) {  // Navigate to Supplier
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllSupplierView()),
                          );
                        } else if (index == 20) {  // Navigate to Branch
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllBranchesView()),
                          );
                        }else if (index == 0) {  // Navigate to Branch
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllProductView()),
                          );
                        }else if (index == 3) {  // Navigate to Branch
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewSalesDetailsScreen()),
                          );
                        }
                      },
                      child: Card(
                        elevation: 3, // Adjust the elevation for shadow effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                        ),
                        child: Container(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: NetworkImage(myItems[index]["img"]!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                myItems[index]["title"]!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w100,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.lightGreenAccent,
        unselectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.countertops), label: "Counter"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
