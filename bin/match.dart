
abstract class Item {
  String name;
  List<Item> items;

  Item._internal(this.name);
  void accept(ItemVisitor visitor);
  String toString();
}

class LineItem extends Item {
  LineItem(String name) : super._internal(name) {
    items = [];
  }
  void accept(ItemVisitor visitor) {
    visitor.visit(this);
  }
  String toString() => name;
}

class FileItem extends Item {
  FileItem(String name) : super._internal(name) {
    items = [];
  }
  void accept(ItemVisitor visitor) {
    for (var item in items) {
      item.accept(visitor);
    }
    visitor.visit(this);
  }
}

class JobItem extends Item {
  JobItem(String name) : super._internal(name) {
    items = [];
  }
  void accept(ItemVisitor visitor) {
    for (var item in items) {
      item.accept(visitor);
    }
    visitor.visit(this);
  }
}

abstract class ItemVisitor {
  void visit(Item item);
}

class ItemRenderVisitor extends ItemVisitor {
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

class ItemCountVisitor extends ItemVisitor {
  var lines = 0;

  void visit(Item item) {
    if (item is FileItem) {
      print('FILE: ${item.name} (${item.items.length})');
      lines += item.items.length;
    } else if (item is JobItem) {
      print('JOB : ${item.name} (${item.items.length}/$lines)');
    }
  }
}

main() {
  var job = new JobItem('job1');
  for (var fileName in ['file1', 'file2', 'file3']) {
    var file = new FileItem(fileName);
    for (var line in [' 1', '2', '45', '60', '71']) {
      file.items.add(new LineItem(line));
    }
    job.items.add(file);
  }
//  job.accept(new ItemRenderVisitor());
  job.accept(new ItemCountVisitor());
}
