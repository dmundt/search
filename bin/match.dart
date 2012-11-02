
import 'package:meta/meta.dart';

abstract class Item extends Comparable {
  num name;
  List<Item> items = <Item>[];

  Item._(this.name);
  void accept(ItemVisitor visitor) {
    if (visitor.strategy == Strategy.TOP_DOWN) {
      for (var item in items) {
        item.accept(visitor);
      }
    }
    visitor.visit(this);
    if (visitor.strategy == Strategy.BOTTOM_UP) {
      for (var item in items) {
        item.accept(visitor);
      }
    }
  }

  void sort() => items.sort();
  @override int compareTo(Item other) => name.compareTo(other.name);
  @override String toString() => name.toString();
}

class LineItem extends Item {
  LineItem(num name) : super._(name);
  @override void accept(ItemVisitor visitor) {
    visitor.visit(this);
  }
}

class FileItem extends Item {
  FileItem(num name) : super._(name);
}

class JobItem extends Item {
  JobItem(num name) : super._(name);
}

class Strategy {
  static const TOP_DOWN = const Strategy._("TOP_DOWN");
  static const BOTTOM_UP = const Strategy._("BOTTOM_UP");

  final String strategy;
  const Strategy._(this.strategy);
  @override String toString() => strategy;
}

abstract class ItemVisitor {
  final Strategy strategy;
  ItemVisitor._(this.strategy);
  void visit(Item item);
}

class ItemSortVisitor extends ItemVisitor {
  ItemSortVisitor() : super._(Strategy.TOP_DOWN);
  void visit(Item item) {
    item.sort();
  }
}

class ItemPrintVisitor extends ItemVisitor {
  ItemPrintVisitor() : super._(Strategy.BOTTOM_UP);
  void visit(Item item) {
    if (item is LineItem) {
      print('LINE: ${item.toString()}');
    } else if (item is FileItem) {
      print('FILE: ${item.toString()}');
    } else if (item is JobItem) {
      print('JOB : ${item.toString()}');
    }
  }
}

main() {
  var job = new JobItem(1);
  // Build item tree structure.
  for (var fileName in [2, 1]) {
    var file = new FileItem(fileName);
    for (var line in [2, 1, 0]) {
      file.items.add(new LineItem(line));
    }
    job.items.add(file);
  }
  // Execute visitors.
  job.accept(new ItemPrintVisitor());
  job.accept(new ItemSortVisitor());
  print('');
  job.accept(new ItemPrintVisitor());
}
