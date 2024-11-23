import 'dart:async';
import 'package:flutter/material.dart';
import 'package:point_of_sale/model/ProductModel.dart';
import 'package:point_of_sale/page/LogoutPage.dart';
import 'package:point_of_sale/page/Login.dart';
import 'package:point_of_sale/page/Sales/AllSalesView.dart';
import 'package:point_of_sale/page/Sales/CreateSalesDhanmondiBranch.dart';
import 'package:point_of_sale/page/Sales/CreateSalesBananiBranch.dart';
import 'package:point_of_sale/page/Sales/CustomerReoprts.dart';
import 'package:point_of_sale/page/Sales/SalesChart.dart';
import 'package:point_of_sale/page/Sales/SalesDetails.dart';
import 'package:point_of_sale/page/UserRole.dart';

import 'package:point_of_sale/page/branch/AllBranchView.dart';
import 'package:point_of_sale/page/category/AllCategoryView.dart';
import 'package:point_of_sale/page/product/AllProductView.dart';
import 'package:point_of_sale/page/product/Notifications.dart';
import 'package:point_of_sale/page/product/StockListDhanmondiBranch.dart';
import 'package:point_of_sale/page/product/StockListBanani.dart';
import 'package:point_of_sale/page/product/StockListGulshan.dart';
import 'package:point_of_sale/page/supplier/AllSupplierView.dart';
import 'package:point_of_sale/service/AuthService.dart';
import 'package:point_of_sale/service/ProductService.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _carouselIndex = 0;
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  late Future<List<Product>> futureProducts;
  int expiringProductsCount = 0; // Tracks the number of expiring products
  Map<int, bool> hoverStates = {};

  final List<String> _carouselImages = [
    "https://media.istockphoto.com/id/1227011225/vector/people-in-protective-masks-are-in-the-queue-to-the-cashier-keeping-social-distance-safe.jpg?s=612x612&w=0&k=20&c=XnRL2Fd_w_GIQF-kLw99ScXxLAJaMov_V2cMIC4adQI=",
    "https://t4.ftcdn.net/jpg/02/74/73/01/240_F_274730109_gF0azWfAPbZFLr06yKbFu8S5CPSNMYJs.jpg",
    "https://media.istockphoto.com/id/1220303230/vector/social-distancing-during-the-covid-19-pandemic.jpg?s=612x612&w=0&k=20&c=I7Xv5ZAEeL4BYKvj_Ta9_W_D2k17h_VS3mgQhjaDl_4="
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
    // Auto-scroll carousel every 3 seconds
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % _carouselImages.length;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });
    calculateExpiringProducts(); // Calculate expiring products on initialization
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // void _startAutoPageChange() {
  //   _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
  //     setState(() {
  //       _carouselIndex = (_carouselIndex + 1) % _texts.length;
  //     });
  //     _pageController.animateToPage(
  //       _carouselIndex,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeInOut,
  //     );
  //   });
  // }

  // Calculate the number of products expiring within the next 3 days
  void calculateExpiringProducts() async {
    final now = DateTime.now();
    final products = await ProductService().fetchProducts(); // Fetch product list
    setState(() {
      expiringProductsCount = products.where((product) {
        if (product.expiryDate == null) return false; // Skip if expiry date is missing
        final expiryDate = DateTime.parse(product.expiryDate!); // Parse expiry date
        final difference = expiryDate.difference(now).inDays; // Calculate days to expiry
        return difference >= 0 && difference < 3; // Check if within next 3 days
      }).length;
    });
  }


  final List<Map<String, String>> myItems = [
    {"img": "https://cdn-icons-png.flaticon.com/128/1362/1362944.png", "title": "Category"},
    {"img": "https://cdn-icons-png.flaticon.com/128/3321/3321752.png", "title": "Supplier"},
    {"img": "https://cdn-icons-png.flaticon.com/128/13163/13163163.png", "title": "Branch"},
    {"img": "https://cdn-icons-png.flaticon.com/128/7466/7466065.png", "title": "Products"},
    {"img": "https://cdn-icons-png.flaticon.com/128/3211/3211610.png", "title": "Sale"},

    {"img": "https://cdn-icons-png.flaticon.com/128/6632/6632834.png", "title": "Sales Deatails"},

    {"img": "https://cdn-icons-png.flaticon.com/128/17783/17783610.png", "title": "Customer Reports"},
    {"img": "https://cdn-icons-png.flaticon.com/128/15917/15917216.png", "title": "Dhanmondi Branch Stock List"},
    {"img": "https://cdn-icons-png.flaticon.com/128/15917/15917216.png", "title": "Banai Branch Stock List"},
    {"img": "https://cdn-icons-png.flaticon.com/128/15917/15917216.png", "title": "Gulshan Branch Stock List"},
    {"img": "https://cdn-icons-png.flaticon.com/128/3258/3258522.png", "title": "Sales Chart"},
    {"img": "https://cdn-icons-png.flaticon.com/128/17718/17718145.png", "title": "User Role"},


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Departmental Store'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.lightGreenAccent, Colors.blueAccent], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,

            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.lightGreenAccent, // Set the color to green
                ),
                onPressed: () {
                  // Navigate to the notification page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notifications()),
                  );
                },
              ),
              if (expiringProductsCount > 0)
                Positioned(
                  right: 16,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$expiringProductsCount', // Display count of expiring products
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.lightGreenAccent),
              accountName: const Text(
                "Md Towhidul Alam",
                style: TextStyle(color: Colors.black),
              ),
              accountEmail: const Text(
                "alammdtowhidul9@gmail.com",
                style: TextStyle(color: Colors.black),
              ),
              currentAccountPicture: Image.network(
                "https://i.postimg.cc/ry95B8nc/download-9.jpg",
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Contact"),
              onTap: () {
                // Handle Contact navigation or functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                // Handle Profile navigation or functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Logout Confirmation"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Close the dialog without logging out
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Perform logout and navigate to login
                            await AuthService().logout();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: [
              // Carousel
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: SizedBox(
                      height: 150,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _carouselImages.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                            _carouselImages[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  // Left Button
                  // Positioned(
                  //   left: 10,
                  //   child: IconButton(
                  //     onPressed: _goToPreviousImage,
                  //     icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                  //   ),
                  // ),
                  // Right Button
                  // Positioned(
                  //   right: 10,
                  //   child: IconButton(
                  //     onPressed: _goToNextImage,
                  //     icon: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
                  //   ),
                  // ),
                ],
              ),
              // Add gap between carousel and grid
              SizedBox(height: 20),
              // Adjust height as needed
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _carouselImages.map((url) {
                  int index = _carouselImages.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.orange : Colors.grey,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              // GridView with Hover Animation
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
                    return HoverCard(
                      imgUrl: myItems[index]["img"]!,
                      title: myItems[index]["title"]!,
                      onTap: () {
                        // Navigate based on index
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllCategoryView()),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SupplierListView()),
                          );
                        } else if (index == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllBranchesView()),
                          );
                        } else if (index == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllProductView()),
                          );
                        } else if (index == 4) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateSales()),
                          );
                        } else if (index == 5) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewSalesDetailsScreen()),
                          );
                        } else if (index == 6) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CustomerReports()),
                          );
                        } else if (index == 7) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllProductStockDhanmondi()),
                          );
                        } else if (index == 8) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllProductStockBanani()),
                          );
                        } else if (index == 9) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllProductStockGulshan()),
                          );
                        } else if (index == 10) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SalesChart()),
                          );
                        } else if (index == 11) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserRole()),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class HoverCard extends StatefulWidget {
  final String imgUrl;
  final String title;
  final VoidCallback onTap;

  const HoverCard({
    Key? key,
    required this.imgUrl,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Color _borderColor = Colors.transparent; // Default border color

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _borderColor = Colors.blue; // Change border color to green on hover
        });
        _controller.forward();
      },
      onExit: (_) {
        setState(() {
          _borderColor = Colors.transparent; // Reset border color when not hovering
        });
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(  // Wrap the Card widget with a Container
            color: Colors.lightGreenAccent,  // Set background color here
            child: Card(
              elevation: 4, // Reduced the elevation for a lighter shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Smaller radius for the corners
                side: BorderSide(color: _borderColor, width: 2), // Set the border color dynamically
              ),
              child: SizedBox(
                width: 100, // Control the width of the card
                height: 120, // Control the height of the card
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      widget.imgUrl,
                      height: 40, // Reduced image height
                      width: 40, // Reduced image width
                    ),
                    const SizedBox(height: 8), // Reduced spacing between image and text
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12, // Reduced font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


