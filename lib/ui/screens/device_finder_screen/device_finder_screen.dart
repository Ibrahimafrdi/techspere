import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/core/data_providers/items_provider.dart';
import 'package:delivery_app/core/models/items/item.dart';
import 'package:delivery_app/ui/screens/product_detail_screen/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeviceFinderScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const DeviceFinderScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<DeviceFinderScreen> createState() => _DeviceFinderScreenState();
}

class _DeviceFinderScreenState extends State<DeviceFinderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  String _selectedBudget = '';

  // Dynamic filter selections
  Map<String, String> _selectedFilters = {};

  List<Item> _filteredItems = [];
  bool _filtersApplied = false;
  bool _showFilters = false;
  bool _isProcessingRequirements = false;

  // Available filter options extracted from items
  Map<String, List<String>> _availableFilters = {};

  // Replace with your actual Gemini API key
  static const String _geminiApiKey = 'AIzaSyALgdo0x4XJPd4-FkNWkh-tKJztaAjjMIw';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategoryItems();
      _extractAvailableFilters();
    });
  }

  void _loadCategoryItems() {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    final items = itemsProvider.itemsByCategory[widget.categoryId] ?? [];
    setState(() {
      _filteredItems = items;
    });
  }

  void _extractAvailableFilters() {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    final items = itemsProvider.itemsByCategory[widget.categoryId] ?? [];

    Map<String, Set<String>> tempFilters = {};

    // Extract unique values for each technical spec key
    for (Item item in items) {
      if (item.technicalSpecs != null) {
        item.technicalSpecs!.forEach((key, value) {
          if (value.isNotEmpty) {
            tempFilters[key] ??= <String>{};
            tempFilters[key]!.add(value);
          }
        });
      }
    }

    // Convert Sets to sorted Lists and filter out specs with only one option
    Map<String, List<String>> finalFilters = {};
    tempFilters.forEach((key, valueSet) {
      if (valueSet.isNotEmpty) {
        // Only show filters with multiple options
        List<String> sortedValues = valueSet.toList();
        sortedValues.sort();
        finalFilters[key] = sortedValues;
      }
    });

    setState(() {
      _availableFilters = finalFilters;
      // Initialize selected filters map
      _selectedFilters = Map.fromEntries(
          _availableFilters.keys.map((key) => MapEntry(key, '')));
    });
  }

  Future<void> _processRequirementsWithGemini() async {
    if (_requirementsController.text.trim().isEmpty) {
      _showSnackBar('Please enter your requirements first');
      return;
    }

    setState(() {
      _isProcessingRequirements = true;
    });

    try {
      final response =
          await _callGeminiAPI(_requirementsController.text.trim());
      if (response != null) {
        _applyGeminiFilters(response);
        setState(() {
          _showFilters = true; // Show filters after processing
        });
        _applyFilters();
        _showSnackBar('Requirements processed successfully!');
      }
    } catch (e) {
      _showSnackBar('Error processing requirements: ${e.toString()}');
    } finally {
      setState(() {
        _isProcessingRequirements = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _callGeminiAPI(String requirements) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent');

    // Create a prompt that helps Gemini understand our available filters
    String availableFiltersJson = jsonEncode(_availableFilters);
    String budgetOptions =
        '["Rs. 5,000 - Rs. 15,000", "Rs. 15,000 - Rs. 30,000", "Rs. 30,000 - Rs. 50,000", "Rs. 50,000 - Rs. 100,000", "Rs. 100,000+"]';

    String prompt = '''
You are a device finder assistant. Based on the user's requirements, extract and match the specifications to the available filters.

Available Filters:
- Budget: $budgetOptions
- Technical Specifications: $availableFiltersJson

User Requirements: "$requirements"

Please analyze the requirements and return a JSON response with the following structure:
{
  "budget": "selected budget range or empty string",
  "filters": {
    "filter_key": "selected_value",
    "another_filter_key": "selected_value"
  },
  "explanation": "Brief explanation of how you interpreted the requirements"
}

Rules:
1. Only use filter keys and values that exist in the available filters
2. For budget, match to the closest range from the budget options
3. Be flexible with matching (e.g., "8GB RAM" should match "8GB" if available)
4. If a requirement cannot be matched to available filters, ignore it
5. Return valid JSON only

Example:
If user says "I need a phone with 8GB RAM under 30000", you might return:
{
  "budget": "Rs. 15,000 - Rs. 30,000",
  "filters": {
    "ram": "8GB"
  },
  "explanation": "Found phone with 8GB RAM in your budget range"
}
''';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': _geminiApiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];

        // Extract JSON from the response
        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(text);
        if (jsonMatch != null) {
          return jsonDecode(jsonMatch.group(0)!);
        }
      } else {
        throw Exception('API call failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to process requirements: $e');
    }

    return null;
  }

  void _applyGeminiFilters(Map<String, dynamic> geminiResponse) {
    // Apply budget filter
    if (geminiResponse['budget'] != null &&
        geminiResponse['budget'].toString().isNotEmpty) {
      setState(() {
        _selectedBudget = geminiResponse['budget'].toString();
      });
    }

    // Apply technical spec filters
    if (geminiResponse['filters'] != null) {
      Map<String, dynamic> filters = geminiResponse['filters'];
      filters.forEach((key, value) {
        if (_availableFilters.containsKey(key) &&
            _availableFilters[key]!.contains(value.toString())) {
          setState(() {
            _selectedFilters[key] = value.toString();
          });
        }
      });
    }

    // Show explanation if available
    if (geminiResponse['explanation'] != null) {
      _showSnackBar(geminiResponse['explanation'].toString());
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _applyFilters() {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    final allItems = itemsProvider.itemsByCategory[widget.categoryId] ?? [];

    List<Item> filtered = allItems.where((item) {
      // Search filter
      if (_searchController.text.isNotEmpty) {
        if (!(item.title
                ?.toLowerCase()
                .contains(_searchController.text.toLowerCase()) ??
            false)) {
          return false;
        }
      }

      // Budget filter
      if (_selectedBudget.isNotEmpty && item.price != null) {
        List<String> budgetRange = _selectedBudget.split(' - ');
        if (budgetRange.length == 2) {
          double minPrice = double.parse(
              budgetRange[0].replaceAll('Rs. ', '').replaceAll(',', ''));
          double maxPrice = double.parse(
              budgetRange[1].replaceAll('Rs. ', '').replaceAll(',', ''));
          if (item.price! < minPrice || item.price! > maxPrice) {
            return false;
          }
        }
      }

      // Technical specs filters
      if (item.technicalSpecs != null) {
        for (String filterKey in _selectedFilters.keys) {
          String selectedValue = _selectedFilters[filterKey] ?? '';
          if (selectedValue.isNotEmpty) {
            String? itemValue = item.technicalSpecs![filterKey];
            if (itemValue == null || itemValue != selectedValue) {
              return false;
            }
          }
        }
      } else {
        // If item has no technical specs but filters are selected, exclude it
        bool hasSelectedFilters =
            _selectedFilters.values.any((value) => value.isNotEmpty);
        if (hasSelectedFilters) {
          return false;
        }
      }

      return true;
    }).toList();

    setState(() {
      _filteredItems = filtered;
      _filtersApplied = _selectedBudget.isNotEmpty ||
          _selectedFilters.values.any((value) => value.isNotEmpty) ||
          _searchController.text.isNotEmpty;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedBudget = '';
      _selectedFilters = Map.fromEntries(
          _availableFilters.keys.map((key) => MapEntry(key, '')));
      _searchController.clear();
      _requirementsController.clear();
      _filtersApplied = false;
    });
    _loadCategoryItems();
  }

  String _formatFilterLabel(String key) {
    // Convert technical spec keys to user-friendly labels
    switch (key.toLowerCase()) {
      case 'ram':
        return 'RAM';
      case 'rom':
      case 'storage':
        return 'Storage';
      case 'screensize':
      case 'screen_size':
      case 'display':
        return 'Screen Size';
      case 'camera':
      case 'cameramp':
      case 'camera_mp':
        return 'Camera';
      case 'battery':
      case 'batterylife':
      case 'battery_life':
        return 'Battery';
      case 'processor':
      case 'cpu':
        return 'Processor';
      case 'os':
      case 'operating_system':
        return 'Operating System';
      case 'color':
      case 'colour':
        return 'Color';
      case 'brand':
        return 'Brand';
      case 'model':
        return 'Model';
      case 'connectivity':
        return 'Connectivity';
      case 'weight':
        return 'Weight';
      default:
        // Convert snake_case or camelCase to Title Case
        return key
            .replaceAllMapped(RegExp(r'[_\s]+|(?=[A-Z])'), (match) => ' ')
            .trim()
            .split(' ')
            .map((word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                : '')
            .join(' ');
    }
  }

  String _getFilterHint(String key) {
    switch (key.toLowerCase()) {
      case 'ram':
        return 'Select RAM';
      case 'rom':
      case 'storage':
        return 'Select Storage';
      case 'screensize':
      case 'screen_size':
      case 'display':
        return 'Select Screen Size';
      case 'camera':
      case 'cameramp':
      case 'camera_mp':
        return 'Select Camera';
      case 'battery':
      case 'batterylife':
      case 'battery_life':
        return 'Select Battery';
      case 'processor':
      case 'cpu':
        return 'Select Processor';
      case 'os':
      case 'operating_system':
        return 'Select OS';
      case 'color':
      case 'colour':
        return 'Select Color';
      case 'brand':
        return 'Select Brand';
      default:
        return 'Select ${_formatFilterLabel(key)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Device Finder',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        // actions: [
        //   Container(
        //     margin: EdgeInsets.only(right: 16),
        //     width: 40,
        //     height: 40,
        //     decoration: BoxDecoration(
        //       color: Colors.blue,
        //       shape: BoxShape.circle,
        //     ),
        //     child: Center(
        //       child: Text(
        //         'JD',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.bold,
        //           fontSize: 16,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _applyFilters(),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),

            // AI Requirements Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.smart_toy, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Tell AI what you\'re looking for',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _requirementsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'e.g., "I need a smartphone with 8GB RAM, good camera, under 30000 budget"',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isProcessingRequirements
                          ? null
                          : _processRequirementsWithGemini,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isProcessingRequirements
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Processing...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.auto_awesome,
                                    color: Colors.white, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Find with AI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Toggle Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Advanced Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      if (_filtersApplied)
                        TextButton(
                          onPressed: _clearFilters,
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _showFilters = !_showFilters;
                          });
                        },
                        icon: Icon(
                          _showFilters
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.blue,
                        ),
                        label: Text(
                          _showFilters ? 'Hide' : 'Show',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Collapsible Filter Section
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _showFilters ? null : 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: _showFilters ? 1.0 : 0.0,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Budget Filter (Always show)
                      _buildFilterDropdown(
                        'Budget',
                        'e.g. Rs. 5000 - Rs. 15000',
                        _selectedBudget,
                        [
                          'Rs. 5,000 - Rs. 15,000',
                          'Rs. 15,000 - Rs. 30,000',
                          'Rs. 30,000 - Rs. 50,000',
                          'Rs. 50,000 - Rs. 100,000',
                          'Rs. 100,000+',
                        ],
                        (value) {
                          setState(() {
                            _selectedBudget = value ?? '';
                          });
                          _applyFilters();
                        },
                      ),

                      // Dynamic Technical Spec Filters
                      ..._availableFilters.entries.map((entry) {
                        String key = entry.key;
                        List<String> options = entry.value;

                        return _buildFilterDropdown(
                          _formatFilterLabel(key),
                          _getFilterHint(key),
                          _selectedFilters[key] ?? '',
                          options,
                          (value) {
                            setState(() {
                              _selectedFilters[key] = value ?? '';
                            });
                            _applyFilters();
                          },
                        );
                      }).toList(),

                      SizedBox(height: 20),

                      // Apply Filters Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Apply Filters',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),

                // Recommended Devices Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Recommended ${widget.categoryName} (${_filteredItems.length})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Devices Grid
                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return Consumer<ItemsProvider>(
                      builder: (context, itemsProvider, child) {
                        if (_filteredItems.isEmpty) {
                          return Container(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.devices_other,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No devices found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Try using AI search or adjusting your filters',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1.2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = _filteredItems[index];
                              return _buildDeviceCard(
                                  item, itemsProvider, cartProvider);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),

                SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String hint,
    String selectedValue,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[50],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue.isEmpty ? null : selectedValue,
                hint: Text(
                  hint,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                items: options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(
      Item item, ItemsProvider itemsProvider, CartProvider cartProvider) {
    // Extract specs from item's technicalSpecs
    final specs = _extractSpecsFromTechnicalSpecs(item);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreenMobile(item: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: item.imageUrl != null
                        ? Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/macbook 14.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => itemsProvider.toggleFavorite(item),
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          itemsProvider.isFavorite(item)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: itemsProvider.isFavorite(item)
                              ? Colors.red
                              : Colors.grey[600],
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device Name
                    Text(
                      item.title ?? 'Unknown Device',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 6),

                    // Specs from technicalSpecs
                    ...List.generate(item.technicalSpecs.entries.length,
                        (index) {
                      var entry = item.technicalSpecs.entries.elementAt(index);
                      return Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Row(
                          children: [
                            // ]Icon(spec['icon'], size: 12, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                entry.key + ": " + entry.value,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).take(3),

                    Spacer(),

                    // Price
                    Text(
                      'Rs. ${item.price?.toStringAsFixed(0) ?? '0'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _extractSpecsFromTechnicalSpecs(Item item) {
    List<Map<String, dynamic>> specs = [];

    if (item.technicalSpecs != null && item.technicalSpecs!.isNotEmpty) {
      // Define priority order for specs to display
      List<String> priorityKeys = [
        'ram',
        'storage',
        'rom',
        'battery',
        'screen_size',
        'screensize',
        'display',
        'camera',
        'processor',
        'brand'
      ];

      // First, add specs in priority order
      for (String priorityKey in priorityKeys) {
        String? value = item.technicalSpecs![priorityKey] ??
            item.technicalSpecs![priorityKey.toLowerCase()] ??
            item.technicalSpecs![priorityKey.toUpperCase()];

        if (value != null && value.isNotEmpty) {
          specs.add({
            'icon': _getIconForSpec(priorityKey),
            'text': '${_formatFilterLabel(priorityKey)}: $value',
          });
          if (specs.length >= 3) break; // Limit to 3 specs
        }
      }

      // If we don't have enough specs, add others
      if (specs.length < 3) {
        for (MapEntry<String, String> entry in item.technicalSpecs!.entries) {
          if (!priorityKeys
                  .any((key) => key.toLowerCase() == entry.key.toLowerCase()) &&
              entry.value.isNotEmpty) {
            specs.add({
              'icon': _getIconForSpec(entry.key),
              'text': '${_formatFilterLabel(entry.key)}: ${entry.value}',
            });
            if (specs.length >= 3) break;
          }
        }
      }
    }

    // If still no specs, add default ones
    if (specs.isEmpty) {
      specs = [
        {'icon': Icons.star, 'text': 'Premium Quality'},
        {'icon': Icons.verified, 'text': 'Warranty Included'},
        {'icon': Icons.local_shipping, 'text': 'Fast Delivery'},
      ];
    }

    return specs;
  }

  IconData _getIconForSpec(String specKey) {
    switch (specKey.toLowerCase()) {
      case 'ram':
        return Icons.memory;
      case 'rom':
      case 'storage':
        return Icons.storage;
      case 'battery':
      case 'batterylife':
      case 'battery_life':
        return Icons.battery_full;
      case 'screensize':
      case 'screen_size':
      case 'display':
        return Icons.monitor;
      case 'camera':
      case 'cameramp':
      case 'camera_mp':
        return Icons.camera_alt;
      case 'processor':
      case 'cpu':
        return Icons.settings_input_component;
      case 'os':
      case 'operating_system':
        return Icons.smartphone;
      case 'color':
      case 'colour':
        return Icons.palette;
      case 'brand':
        return Icons.business;
      case 'weight':
        return Icons.scale;
      case 'connectivity':
        return Icons.wifi;
      default:
        return Icons.info;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }
}
