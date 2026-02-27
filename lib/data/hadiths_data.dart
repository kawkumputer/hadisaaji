import '../models/hadith.dart';
import '../config/supabase_config.dart';

const String defaultAuthor =
    'Dr Ahmad Abdullaahi Al-Haniyi, imaaraat/ Tellinɗo/ Ceerno Usmaan Jam Maalik Bah/Firo Abuu Sih';

final List<Hadith> allHadiths = [
  // === CHAPITRE: Ɗomka Yahii Kaɗi Ɗaɗi Leppii ===
  Hadith(
    id: 1,
    chapterTitle: 'Ɗomka Yahii Kaɗi Ɗaɗi Leppii',
    audioUrl: SupabaseConfig.audioUrl('hadiis_1.mpeg'),
    arabicText:
        'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ\n\n'
        '١ - قَالَ رَسُولُ اللَّهِ ﷺ: «لَا يَزَالُ النَّاسُ بِخَيْرٍ مَا عَجَّلُوا الْفِطْرَ»\n\n'
        '٢ - قَالَ أَنَسٌ رضي الله عنه: كَانَ رَسُولُ اللَّهِ ﷺ يُفْطِرُ عَلَى رُطَبَاتٍ قَبْلَ أَنْ يُصَلِّيَ، فَإِنْ لَمْ تَكُنْ رُطَبَاتٌ فَعَلَى تَمَرَاتٍ، فَإِنْ لَمْ تَكُنْ حَسَا حَسَوَاتٍ مِنْ مَاءٍ\n\n'
        '٣ - كَانَ رَسُولُ اللَّهِ ﷺ إِذَا أَفْطَرَ قَالَ: «ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ، وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ»',
    pulaarTranslation:
        '1- Nulaaɗo Alla (jkm) o wiyi : (Yimɓe ceerataa e moyyere ɗoon ɗo ina njaawnoo e kumtagol). Bukaari 1957. Muslim 1098, e wiyɗe Sahlu bun Sa\'adu (wawm).\n\n'
        '2- Anas (wawm) wiyi : Nulaaɗo Alla (jkm) laatinooma ina humtortonoo bagge tati ko aɗii nɗe ina juula, so tawii bagge ɗe keɓaaki o lomtinira ɗum Tamarooje, ɗuum-ne so heɓaaki o wooɓa ngooɓankon taton ndiyam. Abuu Daawuuda 2356/ irwa\'i 922.\n\n'
        '3- Nulaaɗo Alla (jkm) laatinooma so humtiima, omo wiya: (Ɗomka yahii kaɗi-ne ɗaɗi leppii, tee-ne so Alla jaɓii ko njoɓɗi lomata (Tabitata). Abuu Daawuuda 2357, e wiyɗe Abdullaahi bun Umar (wawm)/ irwa\'i 920.',
    source: 'Bukaari 1957, Muslim 1098, Abuu Daawuuda 2356-2357',
    explanation:
        'Ina jeyaa he goowaadi (Sunna) jaawnagol he kumtaari caggal nɗe naage muti. Kaɗi-ne e humtoraade bagge, so o dañaani, o lomtinira Tamarooje. Kaɗi o ɗuworoo duwaawu ngu.',
    note: 'Teskoɗen: Bagge = ko Tamarooje kecce ɗorwuɗe.\nSunna ko ɗooftaaɗe baɗe nulaaɗo, kono riiwtaani jaaɓe ekn',
    category: 'Koorka',
    author: defaultAuthor,
  ),

  // === CHAPITRE: Ɗanngal nder Suumayru (Koorka) ===
  Hadith(
    id: 2,
    chapterTitle: 'Ɗanngal nder Suumayru (Koorka)',
    audioUrl: SupabaseConfig.audioUrl('hadiis_2.mp3'),
    arabicText:
        'الصِّيَامُ فِي السَّفَرِ\n\n'
        '﴿وَمَن كَانَ مَرِيضًا أَوْ عَلَىٰ سَفَرٍ فَعِدَّةٌ مِّنْ أَيَّامٍ أُخَرَ﴾ البقرة ١٨٥\n\n'
        'سَأَلَ حَمْزَةُ بْنُ عَمْرٍو رَسُولَ اللَّهِ ﷺ عَنِ الصِّيَامِ فِي السَّفَرِ، فَقَالَ ﷺ: «إِنْ شِئْتَ فَصُمْ، وَإِنْ شِئْتَ فَأَفْطِرْ»\n\n'
        'قَالَ أَنَسٌ رضي الله عنه: كُنَّا نُسَافِرُ مَعَ النَّبِيِّ ﷺ فَلَمْ يَعِبِ الصَّائِمُ عَلَى الْمُفْطِرِ، وَلَا الْمُفْطِرُ عَلَى الصَّائِمِ\n\n'
        'الْمُسَافِرُ بِالْخِيَارِ: إِنْ شَاءَ صَامَ رَمَضَانَ، وَإِنْ شَاءَ أَفْطَرَ وَيَقْضِي بَعْدَ رَمَضَانَ',
    pulaarTranslation:
        '("Kala oon mo sellaani walla ina woni he ɗanngal waɗɗe-ne yo o heɓɓitoro ɗum ñalɗi goɗɗi") (185 Nagge nge).\n'
        'Hamjata bun Umrawi (wawm) naamniima Nulaaɗo Alla (jkm) ko yowitii e koorka gonɗo he ɗanngal, tan (jkm) wiyi: "so tawii a muuyii tan hoor, kaɗi-ne so a muuyii tay"\n\n'
        'Anas (wawm) min ngoniino ɗannodotonoobe e Annabi (jkm) kay-ne ɗey o ñinataano koorɗo ɗow tayɗo, wonaa kaɗi tayɗo e ɗow koorɗo.',
    source: 'Bukaari 1942-1947, Muslim 1118-1121',
    explanation:
        'Ɗanniido koko suɓnaa : So o muuyii hoora koorka, so o muuyii taya, o heɓɓitoyoo ɗum caggal koorka, waɗɗe-ne, yo o waɗ ɗuum ɓurɗum newanaaɗe mo, ɗum ɗoo jeyaa ko he koyfinooje Sariya, ina he Sahabaabe (wawm) ɓeen hoorannoobe he ɗanngal, ina he maɓɓe ɓeen tayannoobe.',
    note: null,
    category: 'Koorka',
    author: defaultAuthor,
  ),
];

final List<HadithCategory> categories = [
  const HadithCategory(
    name: 'Koorka',
    nameArabic: 'الصيام',
    icon: '🌙',
    count: 2,
  ),
  const HadithCategory(
    name: 'Juulde',
    nameArabic: 'الصلاة',
    icon: '🕌',
    count: 0,
  ),
  const HadithCategory(
    name: 'Laabu',
    nameArabic: 'الطهارة',
    icon: '💧',
    count: 0,
  ),
  const HadithCategory(
    name: 'Sakkude',
    nameArabic: 'الزكاة',
    icon: '💰',
    count: 0,
  ),
  const HadithCategory(
    name: 'Hajju',
    nameArabic: 'الحج',
    icon: '🕋',
    count: 0,
  ),
  const HadithCategory(
    name: 'Jikkuuji',
    nameArabic: 'الأخلاق',
    icon: '❤️',
    count: 0,
  ),
];
