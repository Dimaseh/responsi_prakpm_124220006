class Amiibo {
  String? amiiboSeries;
  String? character;
  String? gameSeries;
  String? head;
  String? image;
  String? name;
  Release? release;
  String? tail;
  String? type;

  Amiibo({
    this.amiiboSeries,
    this.character,
    this.gameSeries,
    this.head,
    this.image,
    this.name,
    this.release,
    this.tail,
    this.type,
  });

  Amiibo.fromJson(Map<String, dynamic> json) {
    amiiboSeries = json['amiiboSeries'] as String?;
    character = json['character'] as String?;
    gameSeries = json['gameSeries'] as String?;
    head = json['head'] as String?;
    image = json['image'] as String?;
    name = json['name'] as String?;
    release = (json['release'] as Map<String, dynamic>?) != null
        ? Release.fromJson(json['release'] as Map<String, dynamic>)
        : null;
    tail = json['tail'] as String?;
    type = json['type'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['amiiboSeries'] = amiiboSeries;
    json['character'] = character;
    json['gameSeries'] = gameSeries;
    json['head'] = head;
    json['image'] = image;
    json['name'] = name;
    json['release'] = release?.toJson();
    json['tail'] = tail;
    json['type'] = type;
    return json;
  }
}

class Release {
  String? au;
  String? eu;
  String? jp;
  String? na;

  Release({
    this.au,
    this.eu,
    this.jp,
    this.na,
  });

  Release.fromJson(Map<String, dynamic> json) {
    au = json['au'] as String?;
    eu = json['eu'] as String?;
    jp = json['jp'] as String?;
    na = json['na'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['au'] = au;
    json['eu'] = eu;
    json['jp'] = jp;
    json['na'] = na;
    return json;
  }
}
