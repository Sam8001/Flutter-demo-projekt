import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final Set<String> selectedContentTypes;
  final Set<String> selectedTags;
  final ValueChanged<Map<String, Set<String>>> onApplyFilters;

  const FilterDialog({
    super.key,
    required this.selectedContentTypes,
    required this.selectedTags,
    required this.onApplyFilters,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late Set<String> _tempContentTypes;
  late Set<String> _tempTags;

  final List<String> contentTypes = ['Bild', 'PDF', 'Video'];
  final List<String> tags = ['Homework', 'Exam', 'Summary', 'Lecture'];

  @override
  void initState() {
    super.initState();
    _tempContentTypes = Set.from(widget.selectedContentTypes);
    _tempTags = Set.from(widget.selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Content Type Section
          const Text(
            'Content Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: contentTypes.map((type) {
              final isSelected = _tempContentTypes.contains(type);
              return FilterChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _tempContentTypes.add(type);
                    } else {
                      _tempContentTypes.remove(type);
                    }
                  });
                },
                selectedColor: Colors.blue.shade300,
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          
          // Tags Section
          const Text(
            'Category',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              final isSelected = _tempTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _tempTags.add(tag);
                    } else {
                      _tempTags.remove(tag);
                    }
                  });
                },
                selectedColor: Colors.blue.shade300,
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          
          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _tempContentTypes.clear();
                      _tempTags.clear();
                    });
                  },
                  child: const Text('clear all'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters({
                      'contentTypes': _tempContentTypes,
                      'tags': _tempTags,
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FastSearch extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  const FastSearch({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                onSelected(filter);
              },
              selectedColor: Colors.blue.shade300,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
