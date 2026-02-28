import 'dart:convert';
import '../config/supabase_config.dart';

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
  final String? audioUrl;

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
    this.audioUrl,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    final audioFile = json['audio_url'] as String?;
    String? resolvedAudioUrl;
    if (audioFile != null) {
      if (audioFile.startsWith('http')) {
        resolvedAudioUrl = audioFile;
      } else {
        resolvedAudioUrl = SupabaseConfig.audioUrl(audioFile);
      }
    }
    return Hadith(
      id: json['id'] as int,
      chapterTitle: json['chapter_title'] as String,
      arabicText: json['arabic_text'] as String,
      pulaarTranslation: json['pulaar_translation'] as String,
      source: json['source'] as String,
      explanation: json['explanation'] as String?,
      note: json['note'] as String?,
      category: json['category'] as String,
      author: json['author'] as String,
      audioUrl: resolvedAudioUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'chapter_title': chapterTitle,
        'arabic_text': arabicText,
        'pulaar_translation': pulaarTranslation,
        'source': source,
        'explanation': explanation,
        'note': note,
        'category': category,
        'author': author,
        'audio_url': audioUrl,
      };

  static String encodeList(List<Hadith> hadiths) =>
      jsonEncode(hadiths.map((h) => h.toJson()).toList());

  static List<Hadith> decodeList(String jsonStr) {
    final list = jsonDecode(jsonStr) as List;
    return list.map((e) => Hadith.fromJson(e as Map<String, dynamic>)).toList();
  }
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

  factory HadithCategory.fromJson(Map<String, dynamic> json, int hadithCount) {
    return HadithCategory(
      name: json['name'] as String,
      nameArabic: json['name_arabic'] as String,
      icon: json['icon'] as String,
      count: hadithCount,
    );
  }
}
