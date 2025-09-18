import 'package:flutter/material.dart';

Future<String?> showPickerSearch({
  required BuildContext context,
  required String title,
  required List<String> items,
  String? initialValue,
  required String type,
  bool enable = true,
}) async {
  TextEditingController searchController = TextEditingController();
  List<String> filteredItems = List.from(items);

  final screenHeight = MediaQuery.of(context).size.height;
  final modalHeight = screenHeight * 0.6;

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    elevation: 2,
    isDismissible: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SafeArea(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: modalHeight,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF34302D),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'Filtro',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          hintText: 'Digite o nome do cliente',
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            borderSide: BorderSide(
                              color: Colors.amber,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            filteredItems =
                                items
                                    .where(
                                      (item) => item.toLowerCase().contains(
                                        value.toLowerCase(),
                                      ),
                                    )
                                    .toList();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return Card(
                            child: ListTile(
                              title: Text(item),
                              onTap: () => Navigator.pop(context, item),
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  141,
                                  141,
                                  141,
                                ),
                                child: Text(
                                  item.isNotEmpty ? item[0].toUpperCase() : '',
                                  style: const TextStyle(color: Colors.white),
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
            );
          },
        ),
      );
    },
  );
}
