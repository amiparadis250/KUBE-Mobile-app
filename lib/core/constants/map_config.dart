class MapConfig {
  // Mapbox Access Token - DO NOT commit actual token to Git
  // For production, use environment variables or secure storage
  static const String mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_TOKEN',
    defaultValue: 'pk.eyJ1IjoiZmFibXVrdW56aSIsImEiOiJjbHJiN2JnNjMwazloMmtwam94anpuYnYwIn0.EUG5XIntObOhzQ0nP0IXsw',
  );
  
  // Default map settings
  static const double defaultZoom = 12.0;
  static const double defaultLatitude = -1.9403; // Kigali, Rwanda
  static const double defaultLongitude = 29.8739;
}
