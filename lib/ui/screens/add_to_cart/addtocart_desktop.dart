// import 'package:delivery_app/core/constant/color.dart';
// import 'package:delivery_app/core/data_providers/cart_provider.dart';
// import 'package:delivery_app/core/models/item.dart';
// import 'package:delivery_app/ui/custom_widgets/counter_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'add_to_cart_screen_provider.dart';

// class AddToCartScreenDesktop extends StatelessWidget {
//   final Item item;
//   const AddToCartScreenDesktop({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => AddToCartScreenProvider()..initItem(item),
//       child: Consumer2<AddToCartScreenProvider, CartProvider>(
//         builder: (context, model, cartProvider, _) {
//           return Scaffold(
//             body: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               SizedBox(width: 22),
//                               Container(
//                                 width: 120,
//                                 height: 120,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(color: Colors.black12),
//                                 ),
//                                 clipBehavior: Clip.hardEdge,
//                                 child: item.imageUrl != null
//                                     ? Image.network(item.imageUrl!, fit: BoxFit.cover)
//                                     : Image.asset('assets/images/wings.png.png', fit: BoxFit.cover),
//                               ),
//                               SizedBox(width: 15),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       item.title ?? '',
//                                       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       item.description ?? '',
//                                       style: TextStyle(color: Colors.grey, fontSize: 14),
//                                     ),
//                                     SizedBox(height: 16),
//                                     Text(
//                                       'Pkr${model.orderItem.totalPrice.toStringAsFixed(2)}',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18,
//                                           color: Colors.red),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16),
//                           Row(
//                             children: [
//                               Text('Quantity:', style: TextStyle(fontWeight: FontWeight.bold)),
//                               SizedBox(width: 15),
//                               CounterWidget(
//                                 count: model.orderItem.quantity,
//                                 onChanged: model.updateQuantity,
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 20),
//                           ..._buildVariations(item, model),
//                           SizedBox(height: 20),
//                           _buildAddonsSection(item, model),
//                           SizedBox(height: 20),
//                           _buildSpecialInstructions(model),
//                           SizedBox(height: 24),
//                           ElevatedButton(
//                             onPressed: () {
//                               // Validate required variations
//                               for (var variation in item.variations ?? []) {
//                                 if (variation.isRequired ?? false) {
//                                   if (!model.orderItem.selectedVariations!.containsKey(variation.name) ||
//                                       model.orderItem.selectedVariations![variation.name]!.isEmpty) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text('Please select ${variation.name}'),
//                                         backgroundColor: primaryColor,
//                                       ),
//                                     );
//                                     return;
//                                   }
//                                 }
//                               }
//                               cartProvider.addItemToCart(model.orderItem);
//                               Navigator.pop(context); // Or go to cart screen
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: primaryColor,
//                               minimumSize: Size(double.infinity, 50),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Text(
//                               'Add to Cart - P${model.orderItem.totalPrice.toStringAsFixed(2)}',
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   List<Widget> _buildVariations(Item item, AddToCartScreenProvider model) {
//     return List.generate(item.variations?.length ?? 0, (index) {
//       final variation = item.variations![index];
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(variation.name ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//           ...List.generate(variation.options?.length ?? 0, (i) {
//             final option = variation.options![i];
//             final isSelected = model.orderItem.selectedVariations![variation.name]?.contains(option.name) ?? false;
//             return RadioListTile<String>(
//               activeColor: primaryColor,
//               title: Text(option.name ?? ''),
//               subtitle: option.price != null ? Text('+P${option.price?.toStringAsFixed(2)}') : null,
//               value: option.name ?? '',
//               groupValue: isSelected ? option.name : null,
//               onChanged: (value) {
//                 model.updateVariation(variation.name!, value!);
//               },
//               dense: true,
//               contentPadding: EdgeInsets.zero,
//             );
//           })
//         ],
//       );
//     });
//   }

//   Widget _buildAddonsSection(Item item, AddToCartScreenProvider model) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Addons', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         ...List.generate(item.addons?.length ?? 0, (index) {
//           final addon = item.addons![index];
//           final isSelected = model.orderItem.selectedAddons!.contains(addon);
//           return CheckboxListTile(
//             activeColor: primaryColor,
//             title: Text(addon.name ?? ''),
//             subtitle: addon.price != null ? Text('P${addon.price?.toStringAsFixed(2)}') : null,
//             value: isSelected,
//             onChanged: (_) => model.updateAddon(addon),
//             dense: true,
//             contentPadding: EdgeInsets.zero,
//           );
//         })
//       ],
//     );
//   }

//   Widget _buildSpecialInstructions(AddToCartScreenProvider model) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Special Instructions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         SizedBox(height: 8),
//         TextField(
//           //onChanged: model.updateSpecialInstructions,
//           decoration: InputDecoration(
//             hintText: 'Add note (extra mayo, cheese, etc.)',
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//         ),
//       ],
//     );
//   }
// }
