part 'mime_mapper.dart';

Map _extensions;

/// Get the default extension for a given content type.
String extension(String contentType) =>
    (_contentTypes.containsKey(contentType) &&
            _contentTypes[contentType].containsKey('extensions'))
        ? _contentTypes[contentType]['extensions'].first
        : null;

/// Get the content type for a given extension or file path.
String contentType(String extension) {
  _processDb();
  if (extension.lastIndexOf('.') >= 0) {
    // assume a file name or path
    extension = extension.substring(extension.lastIndexOf('.') + 1);
  }
  return _extensions[extension.toLowerCase()];
}

/// Lazily process the content types in a map indexed by extension.
void _processDb() {
  if (_extensions == null) {
    _extensions = {};
    _contentTypes.forEach((type, typeInfo) {
      if (typeInfo.containsKey('extensions')) {
        for (String ext in typeInfo['extensions']) {
          _extensions[ext] = type;
        }
      }
    });
  }
}
