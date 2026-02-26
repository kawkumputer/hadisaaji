class Hadith {
  final int id;
  final String chapterTitle;
  final String arabicText;
  final String pulaarTranslation;
  final String source;
  final String? explanation;
  final String? note;
  final String category;
  final String author;

  const Hadith({
    required this.id,
    required this.chapterTitle,
    required this.arabicText,
    required this.pulaarTranslation,
    required this.source,
    this.explanation,
    this.note,
    required this.category,
    required this.author,
  });
}

class HadithCategory {
  final String name;
  final String nameArabic;
  final String icon;
  final int count;

  const HadithCategory({
    required this.name,
    required this.nameArabic,
    required this.icon,
    required this.count,
  });
}
