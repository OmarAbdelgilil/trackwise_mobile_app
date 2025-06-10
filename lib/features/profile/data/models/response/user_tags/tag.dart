class Tag {
  String? id;
  String? name;
  String? image;
  int? steps;
  int? v;

  Tag({this.id, this.name, this.image, this.steps, this.v});

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json['_id'] as String?,
        name: json['name'] as String?,
        image: json['image'] as String?,
        steps: json['steps'] as int?,
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'image': image,
        'steps': steps,
        '__v': v,
      };
}
