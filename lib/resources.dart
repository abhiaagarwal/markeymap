class Resource {
  const Resource();

  _Image get images => const _Image();
  _Video get videos => const _Video();
  _SVG get svg => const _SVG();
  _Data get data => const _Data();
}

class _Image {
  const _Image();

  String get header => 'assets/header.png';
  String get logo => 'assets/logo.png';
  String get texture => 'assets/texture.png';
}

class _Video {
  const _Video();

  String get introVideo => 'assets/intro_video.mp4';
}

class _SVG {
  const _SVG();

  String townSvg(String name) => 'assets/svgs/${name.toLowerCase().trim().replaceAll(' ', '-')}.svg';
}

class _Data {
  const _Data();

  String get credentials => 'assets/credentials.json';
  String get sheetId => '18ERHHKICDJ3JGk2NcRjmU38KjXxdmNgDab9iqu_PwSQ';
}
