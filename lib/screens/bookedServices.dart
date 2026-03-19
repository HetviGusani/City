import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/hive.dart';

class booked extends StatelessWidget {
  final String email;
  const booked({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final String currentEmail = email;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Bookings'),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: Hive.isBoxOpen('bookedServices')
            ? Future.value(Hive.box<BookedService>('bookedServices'))
            : Hive.openBox<BookedService>('bookedServices'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final box = snapshot.data as Box<BookedService>;

          return ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<BookedService> box, _) {
              final bookings = box.values
                  .where((b) => b.userEmail == currentEmail)
                  .toList()
                  .reversed
                  .toList();

              if (bookings.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_repair_service,
                          size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No bookings yet!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image or placeholder
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: booking.image != null
                                ? Image.memory(
                              booking.image!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.home_repair_service,
                                color: Colors.blue,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    booking.category,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (booking.issue.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    booking.issue,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 12, color: Colors.grey[400]),
                                    const SizedBox(width: 4),
                                    Text(
                                      booking.bookedAt.substring(0, 16),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Delete button
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              await booking.delete();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Booking cancelled'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}