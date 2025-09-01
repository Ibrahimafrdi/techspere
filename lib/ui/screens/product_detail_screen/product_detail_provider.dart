import 'package:delivery_app/core/models/addon.dart';
import 'package:delivery_app/core/models/order_item.dart';
import 'package:delivery_app/core/view_models/base_view_model.dart';

class AddToCartScreenProvider extends BaseViewModel {
  OrderItem orderItem = OrderItem(selectedVariations: {}, selectedAddons: []);
  initItem(item) {
    orderItem.item = item;
  }

  updateQuantity(int quantity) {
    orderItem.quantity = quantity;
    notifyListeners();
  }

  updateVariation(String variation, String option) {
    if (orderItem.selectedVariations!.containsKey(variation)) {
      if (orderItem.item?.variations
              ?.firstWhere((v) => v.name == variation)
              .isSingleSelection ??
          true) {
        orderItem.selectedVariations![variation] = [option];
      } else {
        if (orderItem.selectedVariations![variation]!.contains(option)) {
          orderItem.selectedVariations![variation]!.remove(option);
        } else {
          orderItem.selectedVariations![variation]!.add(option);
        }
      }
    } else {
      orderItem.selectedVariations?.addAll(
        {
          variation: [option],
        },
      );
    }
    print(orderItem.selectedVariations);

    notifyListeners();
  }

  updateAddon(Addon addon) {
    if (orderItem.selectedAddons!.contains(addon)) {
      orderItem.selectedAddons!.remove(addon);
    } else {
      orderItem.selectedAddons!.add(addon);
    }
    notifyListeners();
  }
  void updateSpecialInstructions(String value) {
    orderItem.specialInstructions = value;
    notifyListeners();
  }
}
