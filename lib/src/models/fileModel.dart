class FileModel {
  String? name;
  String? originalName;
  int? size;
  String? storage;
  String? type;
  String? url;

  FileModel({
    this.name,
    this.originalName,
    this.size,
    this.storage,
    this.type,
    this.url,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        name:
            json.containsKey('name') ? json['name'] ?? 'fileName' : 'fileName',
        originalName: json.containsKey('originalName')
            ? json['originalName'] ?? 'originalFileName'
            : 'originalFileName',
        size: json.containsKey('size') ? json['size'] ?? 0 : 0,
        storage: json.containsKey('storage')
            ? json['storage'] ?? 'base64'
            : 'base64',
        type: json.containsKey('type')
            ? json['type'] ?? 'image/jpeg'
            : 'image/j[eg',
        url: json.containsKey('url') ? json['url'] ?? '' : '',
      );

  Map<String, dynamic> toJson() => {
        'name': name == null ? null : name,
        'originalName': originalName == null ? null : originalName,
        'size': size == null ? null : size,
        'storage': storage == null ? null : storage,
        'type': type == null ? null : type,
        'url': url == null ? null : url,
      };
}
