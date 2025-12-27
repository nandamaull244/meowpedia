import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meowmedia/model/kategori_model.dart';
import 'package:meowmedia/screen/homescreen.dart';
import 'package:meowmedia/service/kategori_service.dart';
import 'package:meowmedia/service/upload_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  List<KategoriModel> kategoriList = [];
  KategoriModel? selectedCategory;
  bool isLoadingKategori = true;

  Uint8List? selectedImageBytes;
  XFile? selectedImage;

  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    loadKategori();
  }

  void resetForm() {
    _titleController.clear();
    _descController.clear();

    setState(() {
      selectedImageBytes = null;
      selectedCategory = null;
    });
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        selectedImage = image;
        selectedImageBytes = bytes;
      });
    }
  }

  Future<void> submit() async {
  if (selectedImageBytes == null ||
      selectedCategory == null ||
      _titleController.text.isEmpty ||
      _descController.text.isEmpty) {
    _showErrorDialog('Please complete all fields');
    return;
  }

  // SHOW LOADING
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) =>  Center(child: CircularProgressIndicator(color: ThemeData.light().primaryColor)),
  );

  try {
    await UploadService().uploadBerita(
      imageBytes: selectedImageBytes!,
      judul: _titleController.text,
      isi: _descController.text,
      kategoriId: selectedCategory!.id,
    );

    if (!mounted) return;

    // CLOSE LOADING
    Navigator.of(context, rootNavigator: true).pop();

    // SUCCESS POPUP
    _showSuccessDialog();

  } catch (e) {
    if (!mounted) return;

    // CLOSE LOADING
    Navigator.of(context, rootNavigator: true).pop();

    // ERROR POPUP
    _showErrorDialog(e.toString());
  }
}
void _showSuccessDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Upload Success'),
      content: const Text('Your content has been uploaded successfully!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // close dialog

            resetForm();
            print(Supabase.instance.client.auth.currentSession);

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Upload Failed'),
      content: Text(message),
      actions: [
        TextButton(
            style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () {
            Navigator.of(context).pop(); // close dialog only
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}


  Future<void> loadKategori() async {
    try {
      kategoriList = await KategoriService().getKategori();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isLoadingKategori = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Upload',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼️ IMAGE PICKER
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: selectedImageBytes == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 40),
                            SizedBox(height: 8),
                            Text('Tap to upload image'),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.memory(
                            selectedImageBytes!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // 🏷️ CATEGORY BADGES
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              isLoadingKategori
                  ? const Center(child: CircularProgressIndicator())
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kategoriList.map((kategori) {
                        final isSelected = selectedCategory?.id == kategori.id;

                        return ChoiceChip(
                          label: Text(kategori.nama),
                          selected: isSelected,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = kategori;
                            });
                          },
                        );
                      }).toList(),
                    ),

              const SizedBox(height: 20),

              // ✏️ TITLE
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter title',
                ),
              ),

              const SizedBox(height: 16),

              // 📝 DESCRIPTION
              TextField(
                controller: _descController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Write something...',
                ),
              ),

              const SizedBox(height: 24),

              // 🚀 SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
