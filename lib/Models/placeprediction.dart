// ignore_for_file: non_constant_identifier_names

//   PlacesPredictions.js Map<String, dynamic> toJson() {
//      {
//        secondary_Text,:['secondary_Text'];
//        main_text: ['main_text'];
//        place_id:['place_id'];
//     }
//   }
// }

class PlacesPredictions {
  final String? secondary_Text;

  final StructuredFormatting? structuredFormatting;

  final String? main_text;

  final String? place_id;

  PlacesPredictions({
    this.secondary_Text,
    this.structuredFormatting,
    this.place_id,
    this.main_text,
  });

  factory PlacesPredictions.fromJson(Map<String, dynamic> json) {
    return PlacesPredictions(
      main_text: json['main_text'] as String?,
      place_id: json['place_id'] as String?,
      secondary_Text: json['reference'] as String?,
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
    );
  }
}

class StructuredFormatting {
  final String? mainText;

  final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }
}
