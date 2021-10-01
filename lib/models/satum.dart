class Satum {
  Satum({
    this.id,
  });

  int id;

  factory Satum.fromJson(Map<String, dynamic> json) => Satum(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

enum FetchBy { TITLE, BY_ID }

final fetchByValues =
    EnumValues({"byID": FetchBy.BY_ID, "title": FetchBy.TITLE});

enum MaturityRating { ALL_AGE }

final maturityRatingValues = EnumValues({"all age": MaturityRating.ALL_AGE});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class RecentSery {
  RecentSery({
    this.id,
  });

  int id;

  factory RecentSery.fromJson(Map<String, dynamic> json) => RecentSery(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
