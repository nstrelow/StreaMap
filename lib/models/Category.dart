// To parse this data data, do
//
//     final image = imageFromdata(dataString);
//     final video = videoFromdata(dataString);
//     final kind = kindFromdata(dataString);
//     final category = categoryFromdata(dataString);

//import 'dart:convert';
//
//Image imageFromdata(String str) => Image.fromMap(data.decode(str));
//
//String imageTodata(Image data) => data.encode(data.toMap());
//
//Video videoFromdata(String str) => Video.fromMap(data.decode(str));
//
//String videoTodata(Video data) => data.encode(data.toMap());
//
//Kind kindFromdata(String str) => Kind.fromMap(data.decode(str));
//
//String kindTodata(Kind data) => data.encode(data.toMap());
//
//Category categoryFromdata(String str) => Category.fromMap(data.decode(str));
//
//String categoryTodata(Category data) => data.encode(data.toMap());

class Category {
  final Map<String, Kind> kinds;
  final String name;

  String get id {
    return name.toLowerCase().replaceAll(' ', '_');
  }

  Category({
    this.kinds,
    this.name,
  });

  factory Category.fromMap(Map<String, dynamic> data) => Category(
        kinds: Map.from(data['kinds']).map((k, v) => MapEntry<String, Kind>(k, Kind.fromMap(v))),
        name: data['name'],
      );

  Map<String, dynamic> toMap() => {
        'kinds': Map.from(kinds).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
        'name': name,
      };
}

class Kind {
  final String color;
  final Picture image;
  final String name;
  final Map<String, Video> videos;

  String get id {
    return name.toLowerCase().replaceAll(' ', '_');
  }

  Kind({
    this.color,
    this.image,
    this.name,
    this.videos,
  });

  factory Kind.fromMap(Map<String, dynamic> data) => Kind(
        color: data['color'],
        image: data['image'] == null ? null : Picture.fromMap(data['image']),
        name: data['name'],
        videos: Map.from(data['videos']).map((k, v) => MapEntry<String, Video>(k, Video.fromMap(v))),
      );

  Map<String, dynamic> toMap() => {
        'color': color,
        'image': image == null ? null : image.toMap(),
        'name': name,
        'videos': Map.from(videos).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
      };
}

class Picture {
  final String author;
  final String data;
  final String imageLink;
  final String sourceLink;

  Picture({
    this.author,
    this.data,
    this.imageLink,
    this.sourceLink,
  });

  factory Picture.fromMap(Map<String, dynamic> data) => Picture(
        author: data['author'],
        data: data['data'],
        imageLink: data['imageLink'],
        sourceLink: data['sourceLink'],
      );

  Map<String, dynamic> toMap() => {
        'author': author,
        'data': data,
        'imageLink': imageLink,
        'sourceLink': sourceLink,
      };
}

class Video {
  final String color;
  final String description;
  final bool display;
  final Picture image;
  final String link;
  final bool offline;
  final String subtitle;
  final String title;
  final String type;

  Video({
    this.color,
    this.description,
    this.display,
    this.image,
    this.link,
    this.offline,
    this.subtitle,
    this.title,
    this.type,
  });

  factory Video.fromMap(Map<String, dynamic> data) => Video(
        color: data['color'],
        description: data['description'],
        display: data['display'],
        image: data['image'] == null ? null : Picture.fromMap(data['image']),
        link: data['link'],
        offline: data['offline'],
        subtitle: data['subtitle'],
        title: data['title'],
        type: data['type'],
      );

  Map<String, dynamic> toMap() => {
        'color': color,
        'description': description,
        'display': display,
        'image': image == null ? null : image.toMap(),
        'link': link,
        'offline': offline,
        'subtitle': subtitle,
        'title': title,
        'type': type,
      };
}
