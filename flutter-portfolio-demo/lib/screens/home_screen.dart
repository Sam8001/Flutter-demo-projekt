import 'package:flutter_portfolio_demo/widgets/app_bar.dart';
import 'package:flutter_portfolio_demo/widgets/fast_search.dart';
import 'package:flutter/material.dart';
import '../widgets/search.dart';
import '../widgets/item.dart';
import '../models/content_type.dart';
import '../services/data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final DataService _dataService = DataService(); 

  String selectedFilter = 'All';
  List<String> filters = ['All'];

  // Filter-Variablen
  Set<String> _selectedContentTypes = {};
  Set<String> _selectedTags = {};

  List<Map<String, dynamic>> _contents = [];
  List<Map<String, dynamic>> _filteredContents = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContents();
    _loadFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContents() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Inhalte vom Service laden
      final contents = await _dataService.getFeed();

      setState(() {
        _contents = contents;
        _applyAllFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error with loading: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFilters() async {
    try {
      final courseNames = await _dataService.getCourseNames();
      setState(() {
        filters = ['All', ...courseNames];
      });
    } catch (e) {
      debugPrint('Error with loading filters: $e');
    }
  }

  void _applyAllFilters() {
    String searchQuery = _searchController.text.toLowerCase();
    
    _filteredContents = _contents.where((content) {
      // Kurs-Filter: Nur Inhalte des ausgewÃ¤hlten Kurses anzeigen
      if (selectedFilter != 'All') {
        final contentCourse = content['course'];
        
        // Wenn der Inhalt keinen Kurs hat oder nicht zum Filter passt, filtern wir ihn raus
        if (contentCourse == null || contentCourse != selectedFilter) {
          return false;
        }
      }

      // Suchtext-Filter
      bool matchesSearch = searchQuery.isEmpty ||
          content['title'].toString().toLowerCase().contains(searchQuery) ||
          content['description'].toString().toLowerCase().contains(searchQuery);

      if (!matchesSearch) return false;

      // Content Type Filter
      if (_selectedContentTypes.isNotEmpty) {
        String contentType = content['type'].toString().toLowerCase();
        
        // Mapping zwischen Display-Namen und Datenbankwerten
        bool matchesContentType = _selectedContentTypes.any((selectedType) {
          String selectedTypeLower = selectedType.toLowerCase();
          
          // ÃœberprÃ¼fe verschiedene Varianten
          return contentType == selectedTypeLower ||
                 contentType == 'image' && selectedTypeLower == 'bild' ||
                 contentType == 'pdf' && selectedTypeLower == 'pdf' ||
                 contentType == 'video' && selectedTypeLower == 'video';
        });
        
        if (!matchesContentType) return false;
      }

      // Tags Filter
      if (_selectedTags.isNotEmpty) {
        List<dynamic> contentTagsRaw = content['tags'] ?? [];
        List<String> contentTags = contentTagsRaw
            .map((tag) => tag.toString().toLowerCase())
            .toList();
        
        bool matchesTags = _selectedTags.any((tag) {
          return contentTags.contains(tag.toLowerCase());
        });
        
        if (!matchesTags) return false;
      }

      return true;
    }).toList();
  }

  void _filterContents(String query) {
    setState(() {
      _applyAllFilters();
    });
  }

  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      _loadContentsByFilter();
    });
  }

  Future<void> _loadContentsByFilter() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      List<Map<String, dynamic>> contents;
      
      if (selectedFilter == 'All') {
        // Lade alle Inhalte
        contents = await _dataService.getFeed();
      } else {
        // Lade nur Inhalte des ausgewÃ¤hlten Kurses
        contents = await _dataService.getContentByCourse(selectedFilter);
      }

      setState(() {
        _contents = contents;
        _applyAllFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Fehler beim Laden: $e';
        _isLoading = false;
      });
    }
  }

  void _applyAdvancedFilters(Map<String, Set<String>> filters) {
    setState(() {
      _selectedContentTypes = filters['contentTypes'] ?? {};
      _selectedTags = filters['tags'] ?? {};
      _applyAllFilters();
    });
  }

  void _removeContentTypeFilter(String type) {
    setState(() {
      _selectedContentTypes.remove(type);
      _applyAllFilters();
    });
  }

  void _removeTagFilter(String tag) {
    setState(() {
      _selectedTags.remove(tag);
      _applyAllFilters();
    });
  }

  void _clearAllFilters() {
    setState(() {
      _selectedContentTypes.clear();
      _selectedTags.clear();
      _applyAllFilters();
    });
  }

  ContentType _getContentType(String type) {
    switch (type.toLowerCase()) {
      case 'image':
        return ContentType.image;
      case 'video':
        return ContentType.video;
      case 'pdf':
      default:
        return ContentType.pdf;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ModernAppBar(title: 'Home'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            SearchWidget(
              controller: _searchController,
              onChanged: _filterContents,
              onFilterPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (_) => FilterDialog(
                    selectedContentTypes: _selectedContentTypes,
                    selectedTags: _selectedTags,
                    onApplyFilters: _applyAdvancedFilters,
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            FastSearch(
              filters: filters,
              selectedFilter: selectedFilter,
              onSelected: _applyFilter,
            ),

            const SizedBox(height: 16),

            // Angewendete Filter anzeigen
            if (_selectedContentTypes.isNotEmpty || _selectedTags.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Aktive Filter:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _clearAllFilters,
                        icon: const Icon(Icons.clear, size: 18),
                        label: const Text('Alle lÃ¶schen'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._selectedContentTypes.map((type) {
                        return Chip(
                          label: Text(type),
                          onDeleted: () => _removeContentTypeFilter(type),
                          backgroundColor: Colors.blue.shade100,
                          labelStyle: const TextStyle(fontSize: 12),
                        );
                      }),
                      ..._selectedTags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          onDeleted: () => _removeTagFilter(tag),
                          backgroundColor: Colors.green.shade100,
                          labelStyle: const TextStyle(fontSize: 12),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            const SizedBox(height: 8),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_error!),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadContents,
                                child: const Text('Erneut versuchen'),
                              ),
                            ],
                          ),
                        )
                      : _filteredContents.isEmpty
                          ? const Center(child: Text('Keine Inhalte gefunden'))
                          : ListView.builder(
                              itemCount: _filteredContents.length,
                              itemBuilder: (context, index) {
                                final content = _filteredContents[index];

                                final author = content['author'] ?? 'Unbekannt';
                                final authorId = content['user_id']?.toString() ?? '';

                                DateTime? createdAt;
                                try {
                                  if (content['created_at'] != null) {
                                    createdAt = DateTime.parse(content['created_at'].toString());
                                  }
                                } catch (_) {}

                                final authorAvatarUrl = content['author_avatar']?.toString() ?? '';
                                

                                return ItemWidget(
                                  title: content['title'] ?? 'Ohne Titel',
                                  description: content['description'] ?? '',
                                  author: author,
                                  authorId: authorId,
                                  type: _getContentType(content['type'] ?? 'pdf'),
                                  thumbnailUrl: content['thumbnail_url'] ?? '',
                                  contentUrl: content['file_url'] ?? '',
                                  createdAt: createdAt,
                                  authorAvatarUrl: authorAvatarUrl,
                                );
                              },
                            ),

            ),
          ],
        ),
      ),
    );
  }
}



