import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../wardrobe/domain/entities/clothing_category.dart';
import '../viewmodels/add_clothing_view_model.dart';

class AddClothingScreen extends ConsumerStatefulWidget {
  const AddClothingScreen({super.key});

  @override
  ConsumerState<AddClothingScreen> createState() => _AddClothingScreenState();
}

class _AddClothingScreenState extends ConsumerState<AddClothingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _seasonController = TextEditingController();
  final _preferenceController = TextEditingController();
  ClothingCategory _category = ClothingCategory.tops;

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _seasonController.dispose();
    _preferenceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(addClothingViewModelProvider)
        .saveItem(
          name: _nameController.text.trim(),
          category: _category,
          color: _colorController.text.trim(),
          season: _seasonController.text.trim(),
          laundryPreference: _preferenceController.text.trim(),
        );

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Item saved to wardrobe.')));
    _formKey.currentState!.reset();
    _nameController.clear();
    _colorController.clear();
    _seasonController.clear();
    _preferenceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        const SectionHeader(
          title: 'Add Clothing',
          subtitle: 'Create a wardrobe entry with care settings.',
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white10,
                ),
                child: const Center(
                  child: Icon(Icons.add_a_photo_outlined, size: 36),
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Please enter a name'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ClothingCategory>(
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: ClothingCategory.values
                          .map(
                            (cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _category = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _colorController,
                      decoration: const InputDecoration(labelText: 'Color'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _seasonController,
                      decoration: const InputDecoration(labelText: 'Season'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _preferenceController,
                      decoration: const InputDecoration(
                        labelText: 'Laundry Preference',
                      ),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(label: 'Save Item', onPressed: _save),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
