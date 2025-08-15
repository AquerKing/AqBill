import 'package:bill/data/category_model.dart';
import 'package:bill/resources/svg_icon.dart';
import 'package:flutter/material.dart';

// 基于CategoryModel的单选滚动选择控件
class CategorySelector extends StatefulWidget {
  final List<CategoryModel> categories;
  final double? maxHeight;
  final ValueChanged<CategoryModel> onSelected;
  final CategoryModel? initialSelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.onSelected,
    this.maxHeight = 200,
    this.initialSelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialSelected;
  }

  void _handleSelect(CategoryModel category) {
    setState(() {
      _selectedCategory = category;
    });
    widget.onSelected(category);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: widget.maxHeight ?? 200),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              widget.categories.map((category) {
                // 关键修改：使用id（整数）作为选中状态的判断依据
                final isSelected = _selectedCategory?.id == category.id;

                final selectedColor = Colors.teal;

                return InkWell(
                  onTap: () => _handleSelect(category),
                  child: Container(
                    color:
                        isSelected
                            ? selectedColor.withValues(alpha: 0.1)
                            : null,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        SvgIcon(category.icon),
                        const SizedBox(width: 12),
                        // 文字区域
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                  color:
                                      isSelected
                                          ? Colors.black87
                                          : Colors.black54,
                                ),
                              ),
                              if (category.description.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    category.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          isSelected
                                              ? selectedColor.withValues(
                                                alpha: 0.8,
                                              )
                                              : Colors.grey[500],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: selectedColor,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
