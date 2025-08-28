import 'package:delivery_app/core/data_providers/cart_provider.dart';
import 'package:delivery_app/core/data_providers/items_provider.dart';
import 'package:delivery_app/core/models/items/item.dart';
import 'package:delivery_app/ui/screens/add_to_cart/addtocart_mobile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  String _selectedBudget = '';
  String _selectedRAM = '';
  String _selectedROM = '';
  String _selectedScreenSize = '';
  String _selectedCameraMegapixels = '';
  String _selectedBatteryLife = '';
  
  List<Item> _filteredItems = [];
  bool _filtersApplied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategoryItems();
    });
  }

  void _loadCategoryItems() {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    final items = itemsProvider.itemsByCategory[widget.categoryId] ?? [];
    setState(() {
      _filteredItems = items;
    });
  }

  void _applyFilters() {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);
    final allItems = itemsProvider.itemsByCategory[widget.categoryId] ?? [];
    
    List<Item> filtered = allItems.where((item) {
      // Search filter
      if (_searchController.text.isNotEmpty) {
        if (!(item.title?.toLowerCase().contains(_searchController.text.toLowerCase()) ?? false)) {
          return false;
        }
      }
      
      // Budget filter
      if (_selectedBudget.isNotEmpty && item.price != null) {
        List<String> budgetRange = _selectedBudget.split(' - ');
        if (budgetRange.length == 2) {
          double minPrice = double.parse(budgetRange[0].replaceAll('Rs. ', '').replaceAll(',', ''));
          double maxPrice = double.parse(budgetRange[1].replaceAll('Rs. ', '').replaceAll(',', ''));
          if (item.price! < minPrice || item.price! > maxPrice) {
            return false;
          }
        }
      }
      
      return true;
    }).toList();
    
    setState(() {
      _filteredItems = filtered;
      _filtersApplied = _selectedBudget.isNotEmpty || 
                      _selectedRAM.isNotEmpty || 
                      _selectedROM.isNotEmpty || 
                      _selectedScreenSize.isNotEmpty ||
                      _selectedCameraMegapixels.isNotEmpty ||
                      _selectedBatteryLife.isNotEmpty ||
                      _searchController.text.isNotEmpty;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedBudget = '';
      _selectedRAM = '';
      _selectedROM = '';
      _selectedScreenSize = '';
      _selectedCameraMegapixels = '';
      _selectedBatteryLife = '';
      _searchController.clear();
      _filtersApplied = false;
    });
    _loadCategoryItems();
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
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'JD',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
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
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Section
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filter Device Specifications',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
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
                          ],
                        ),
                        SizedBox(height: 16),

                        // Budget Filter
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

                        // RAM Filter
                        _buildFilterDropdown(
                          'RAM',
                          'Select RAM',
                          _selectedRAM,
                          ['4GB', '6GB', '8GB', '12GB', '16GB', '32GB'],
                          (value) {
                            setState(() {
                              _selectedRAM = value ?? '';
                            });
                            _applyFilters();
                          },
                        ),

                        // ROM Filter
                        _buildFilterDropdown(
                          'ROM',
                          'Select ROM',
                          _selectedROM,
                          ['64GB', '128GB', '256GB', '512GB', '1TB'],
                          (value) {
                            setState(() {
                              _selectedROM = value ?? '';
                            });
                            _applyFilters();
                          },
                        ),

                        // Screen Size Filter
                        _buildFilterDropdown(
                          'Screen Size',
                          'Select Screen Size',
                          _selectedScreenSize,
                          ['5.5"', '6.1"', '6.4"', '6.7"', '13"', '14"', '15"', '16"'],
                          (value) {
                            setState(() {
                              _selectedScreenSize = value ?? '';
                            });
                            _applyFilters();
                          },
                        ),

                        // Camera Megapixels Filter
                        _buildFilterDropdown(
                          'Camera Megapixels',
                          'e.g. 48MP+',
                          _selectedCameraMegapixels,
                          ['12MP+', '24MP+', '48MP+', '64MP+', '108MP+'],
                          (value) {
                            setState(() {
                              _selectedCameraMegapixels = value ?? '';
                            });
                            _applyFilters();
                          },
                        ),

                        // Battery Life Filter
                        _buildFilterDropdown(
                          'Battery Life',
                          'e.g. 4000 mAh+',
                          _selectedBatteryLife,
                          ['3000 mAh+', '4000 mAh+', '5000 mAh+', '6000 mAh+', '10+ hours'],
                          (value) {
                            setState(() {
                              _selectedBatteryLife = value ?? '';
                            });
                            _applyFilters();
                          },
                        ),

                        SizedBox(height: 20),

                        // Get Device Suggestions Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _applyFilters,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Get Device Suggestions',
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

                  SizedBox(height: 16),

                  // Recommended Devices Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Recommended Devices',
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
                                      'Try adjusting your filters',
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
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 1.2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                return _buildDeviceCard(item, itemsProvider, cartProvider);
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
            ),
          ),
        ],
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

  Widget _buildDeviceCard(Item item, ItemsProvider itemsProvider, CartProvider cartProvider) {
    // Extract specs from item description or use placeholder values
    final specs = _extractSpecs(item);
    
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
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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

                    // Specs
                    ...specs.map((spec) => Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Row(
                        children: [
                          Icon(spec['icon'], size: 12, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              spec['text'],
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
                    )).take(3),

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

  List<Map<String, dynamic>> _extractSpecs(Item item) {
    // This would typically extract specs from item data
    // For now, returning sample specs based on category
    switch (widget.categoryName.toLowerCase()) {
      case 'smartphones':
      case 'phone':
        return [
          {'icon': Icons.memory, 'text': '8GB RAM'},
          {'icon': Icons.storage, 'text': '256GB ROM'},
          {'icon': Icons.battery_full, 'text': '4000 mAh'},
        ];
      case 'laptops':
      case 'laptop':
        return [
          {'icon': Icons.memory, 'text': '16GB RAM'},
          {'icon': Icons.storage, 'text': '512GB SSD'},
          {'icon': Icons.monitor, 'text': '14" Display'},
        ];
      case 'wearables':
      case 'watch':
        return [
          {'icon': Icons.watch, 'text': 'GPS Enabled'},
          {'icon': Icons.favorite, 'text': 'Heart Rate'},
          {'icon': Icons.battery_full, 'text': '7 Days Battery'},
        ];
      default:
        return [
          {'icon': Icons.star, 'text': 'Premium Quality'},
          {'icon': Icons.verified, 'text': 'Warranty Included'},
          {'icon': Icons.local_shipping, 'text': 'Fast Delivery'},
        ];
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}