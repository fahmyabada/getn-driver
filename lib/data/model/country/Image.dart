class Image {
  final String? src;
  final String? mimetype;

  Image({
    this.src,
    this.mimetype,
  });

  Image.fromJson(Map<String, dynamic> json)
      : src = json['src'] as String?,
        mimetype = json['mimetype'] as String?;

  Map<String, dynamic> toJson() => {'src': src, 'mimetype': mimetype};

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Image && other.src == src && other.mimetype == mimetype;
  }

  @override
  int get hashCode => src.hashCode ^ mimetype.hashCode;
}
