import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/app_drawer.dart';
import 'service_detail_screen.dart';
import 'package:city/screens/service_detail_screen.dart'; // 👈 add this

class HomeScreen extends StatefulWidget {
  final String name;
  final String email;

  HomeScreen({Key? key, required this.name, required this.email}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _services = [];
  bool _isLoading = true;
  bool _isGrid = false;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    // using a mock API setup to fetch JSON data
    // You can replace this endpoint with your real server/Firebase logic
    try {
      final response = await http.get(
        Uri.parse('https://mocki.io/v1/d4867d8b-b5d5-4a48-a4ab-79131b5809b8'),
      );

      // Since mock APIs can sometimes go down, here is fallback mock data
      if (response.statusCode == 200) {
        setState(() {
          _services = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        _loadFallbackData();
      }
    } catch (e) {
      _loadFallbackData();
    }
  }

  void _loadFallbackData() {
    setState(() {
      _services = [
        {
          "id": "1",
          "name": "Sparkle Cleaners",
          "category": "Cleaning",
          "rating": 4.5,
          "image":
          "https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=200&auto=format&fit=crop",
        },
        {
          "id": "2",
          "name": "FixIt Plumbers",
          "category": "Plumber",
          "rating": 4.8,
          "image":
          "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=200&auto=format&fit=crop",
        },
        {
          "id": "3",
          "name": "Style Studio",
          "category": "Salon",
          "rating": 4.2,
          "image":
          "https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=200&auto=format&fit=crop",
        },
        {
          "id": "4",
          "name": "Ace Tutors",
          "category": "Tuition",
          "rating": 4.9,
          "image":
          "https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?q=80&w=200&auto=format&fit=crop",
        },
        {
          "id": "5",
          "name": "Quick Electricians",
          "category": "Electrician",
          "rating": 4.6,
          "image":
          "https://tiimg.tistatic.com/fp/1/007/814/specialist-quickly-efficiently-any-type-work-quick-commercial-electric-services-517.jpg",
        },
        {
          "id": "6",
          "name": "Green Gardeners",
          "category": "Gardening",
          "rating": 4.3,
          "image":
          "https://images.unsplash.com/photo-1592150621744-aca64f48394a?q=80&w=200&auto=format&fit=crop",
        },
        {
          "id": "7",
          "name": "Bright Tutors",
          "category": "Tuition",
          "rating": 4.7,
          "image":
          "https://images.unsplash.com/photo-1577896851231-70ef18881754?q=80&w=200&auto=format&fit=crop",
        },
        {
          "id": "8",
          "name": "HomeFix Carpenters",
          "category": "Carpenter",
          "rating": 4.4,
          "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWH2qB_La_Cr9YjO6ovd4V0EjirWkBwBJRGQ&s",
        },
        {
          "id": "9",
          "name": "Glow Beauty Salon",
          "category": "Salon",
          "rating": 4.5,
          "image":
          "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=200&auto=format&fit=crop",
        },
        {
          "id": "10",
          "name": "Safe Pest Control",
          "category": "Pest Control",
          "rating": 4.6,
          "image":
          "https://images.pexels.com/photos/19789841/pexels-photo-19789841/free-photo-of-smoke-used-for-pest-control.jpeg",
        },
        {
          "id": "11",
          "name": "Tech Repair Hub",
          "category": "Electronics Repair",
          "rating": 4.3,
          "image":
          "https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=200&auto=format&fit=crop",
        },
        {
          "id": "12",
          "name": "Fresh Laundry",
          "category": "Laundry",
          "rating": 4.2,
          "image":
          "https://images.unsplash.com/photo-1582735689369-4fe89db7114c?q=80&w=200&auto=format&fit=crop",
        },
        {
          "id": "13",
          "name": "Secure Home Services",
          "category": "Security",
          "rating": 4.7,
          "image":
          "https://images.unsplash.com/photo-1581092334651-ddf26d9a09d0?q=80&w=200&auto=format&fit=crop",
        },
        {
          "id": "14",
          "name": "FitLife Trainers",
          "category": "Fitness",
          "rating": 4.8,
          "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=200&auto=format&fit=crop",
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
      drawer: AppDrawer(name: widget.name, email: widget.email),
      bottomNavigationBar: SizedBox(height: 30,),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _services.isEmpty
          ? const Center(child: Text("No services found."))
          : _isGrid
          ? _buildGridView()
          : _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                service['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              service['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(service['category']),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '⭐ ${service['rating']}',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ServiceDetailScreen(service: service, mail: widget.email),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ServiceDetailScreen(service: service, mail: widget.email),
              ),
            );
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Image.network(service['image'], fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // ✅ removed trailing: and fixed as normal Row widget
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              service['category'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            // ✅ prevents overflow
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${service['rating']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 13,
                                ),
                              ),
                            ],
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
      },
    );
  }
}