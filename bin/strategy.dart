// Strategy pattern in Dart with abstract base class.
abstract class Renderer {
  static const TEXT = const TextRenderer('text');
  static const HTML = const HtmlRenderer('html');
  static const JSON = const JsonRenderer('json');

  final String name;
  const Renderer._internal(this.name);
  void render();
}

class TextRenderer extends Renderer {
  const TextRenderer(String name) : super._internal(name);
  void render() => print('Rendering to $name...');
}

class HtmlRenderer extends Renderer {
  const HtmlRenderer(String name) : super._internal(name);
  void render() => print('Rendering to $name...');
}

class JsonRenderer extends Renderer {
  const JsonRenderer(String name) : super._internal(name);
  void render() => print('Rendering to $name...');
}

class Context {
  Renderer _renderer;
  Context(this._renderer);
  export() => _renderer.render();
}

void main() {
  var context = new Context(Renderer.JSON);
  context.export();
}
