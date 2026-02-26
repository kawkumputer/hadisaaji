class SupabaseConfig {
  static const String projectUrl = 'https://hitwixhtrciymmmtrkzz.supabase.co';
  static const String anonKey =
      'sb_publishable_VnDT20gWqVL0AMpV7t7xpA_MVRrcs_0';
  static const String audioBucket = 'audio';

  /// Génère l'URL publique d'un fichier audio dans le bucket
  static String audioUrl(String filename) {
    return '$projectUrl/storage/v1/object/public/$audioBucket/$filename';
  }
}
