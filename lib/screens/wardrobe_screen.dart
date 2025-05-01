import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  final List<Map<String, dynamic>> _clothes = [];

  String? _filterSeason;
  String? _filterCategory;

  final List<String> _seasons = ['Yazlık', 'Bahar', 'Kışlık'];
  final Map<String, List<String>> _categories = {
    'Yazlık': ['Üst', 'Alt', 'Ayakkabı', 'Aksesuar'],
    'Bahar': ['Üst', 'Alt', 'Ayakkabı', 'Aksesuar'],
    'Kışlık': ['Üst', 'Alt', 'Ayakkabı', 'Aksesuar'],
  };

  Future<void> _pickImageAndAddClothing({Map<String, dynamic>? editItem}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    String? selectedSeason = editItem?['season'];
    String? selectedCategory = editItem?['category'];
    TextEditingController nameController = TextEditingController(
        text: editItem != null ? editItem['name'] : '');

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(editItem != null ? 'Kıyafeti Düzenle' : 'Kıyafet Ekle'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    hint: const Text('Mevsim seçin'),
                    value: selectedSeason,
                    onChanged: (value) {
                      setState(() => selectedSeason = value);
                    },
                    items: _seasons
                        .map((season) => DropdownMenuItem(
                              value: season,
                              child: Text(season),
                            ))
                        .toList(),
                  ),
                  if (selectedSeason != null)
                    DropdownButton<String>(
                      hint: const Text('Kategori seçin'),
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() => selectedCategory = value);
                      },
                      items: _categories[selectedSeason]!
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                    ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Kıyafet Adı'),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedSeason != null &&
                    selectedCategory != null &&
                    nameController.text.isNotEmpty) {
                  final newClothing = {
                    'image': File(pickedFile.path),
                    'season': selectedSeason,
                    'category': selectedCategory,
                    'name': nameController.text,
                  };

                  setState(() {
                    if (editItem != null) {
                      final index = _clothes.indexOf(editItem);
                      _clothes[index] = newClothing;
                    } else {
                      _clothes.add(newClothing);
                    }
                  });

                  Navigator.pop(context);
                }
              },
              child: Text(editItem != null ? 'Güncelle' : 'Ekle'),
            )
          ],
        );
      },
    );
  }

  void _deleteClothes(Map<String, dynamic> item) {
    
    setState(() => _clothes.remove(item));
   
  }

  void _showFilterDialog() {
    String? selectedSeason = _filterSeason;
    String? selectedCategory = _filterCategory;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Filtrele'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    hint: const Text('Mevsim seçin'),
                    value: selectedSeason,
                    onChanged: (value) {
                      setState(() => selectedSeason = value);
                    },
                    items: _seasons
                        .map((season) => DropdownMenuItem(
                              value: season,
                              child: Text(season),
                            ))
                        .toList(),
                  ),
                  if (selectedSeason != null)
                    DropdownButton<String>(
                      hint: const Text('Kategori seçin'),
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() => selectedCategory = value);
                      },
                      items: _categories[selectedSeason]!
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _filterSeason = null;
                  _filterCategory = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Temizle'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _filterSeason = selectedSeason;
                  _filterCategory = selectedCategory;
                });
                Navigator.pop(context);
              },
              child: const Text('Filtrele'),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> get _filteredClothes {
    return _clothes.where((item) {
      final seasonMatch = _filterSeason == null || item['season'] == _filterSeason;
      final categoryMatch = _filterCategory == null || item['category'] == _filterCategory;
      return seasonMatch && categoryMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade800,
        title: const Text('Gardırop',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_alt_outlined,color: Colors.white,),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickImageAndAddClothing(), backgroundColor: Colors.purple.shade800,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _filteredClothes.length,
        itemBuilder: (context, index) {
          final item = _filteredClothes[index];
          return Stack(
            children: [
              Positioned.fill(
                child: GridTile(
                  footer: Container(
                    color: Colors.black54,
                    child: ListTile(
                      title: Text(item['name'], style: const TextStyle(color: Colors.white)),
                      subtitle: Text('${item['season']} - ${item['category']}', style: const TextStyle(color: Colors.white70)),
                    ),
                  ),
                  child: Image.file(item['image'], fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () => _pickImageAndAddClothing(editItem: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _deleteClothes(item),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
