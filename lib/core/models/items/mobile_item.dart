import 'package:delivery_app/core/models/items/item.dart';

class MobileItem extends Item{
  String? ram;
  String? rom;
  String? cameraPx;
  String? battery;
  String? processor;
  String? display;

  MobileItem({
    
    this.ram,
    this.rom,
    this.cameraPx,
    this.battery,
    this.processor,
    this.display,
  });
}