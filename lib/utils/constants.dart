/// Application constants for Hue & Cry.

/// The display name of the application.
const String appName = 'Hue & Cry';

/// The tagline shown below the app name.
const String appTagline = 'Being a Chronicle of Mystery & Crime';

/// Overpass API endpoint for fetching OpenStreetMap POI data.
/// 
/// The main public instance. Note that this can be rate-limited during
/// high traffic. Consider using a local instance for production.
const String overpassApiUrl = 'https://overpass-api.de/api/interpreter';

/// Alternative Overpass API endpoints (fallbacks).
const List<String> overpassApiMirrors = [
  'https://overpass.kumi.systems/api/interpreter',
  'https://maps.mail.ru/osm/tools/overpass/api/interpreter',
];

/// Default search radius in meters for POI queries.
/// 
/// This defines how far from the player's location we search for
/// points of interest to bind to case locations.
const double defaultSearchRadiusMeters = 1000.0;

/// OpenStreetMap tile URL template.
/// 
/// Standard OSM tiles with {s} subdomain, {z} zoom, {x}/{y} tile coords.
const String osmTileUrlTemplate =
    'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

/// User agent for tile requests (required by OSM tile usage policy).
const String osmUserAgent = 'HueAndCry/1.0 (location-based-detective-game)';

/// Attribution text required for OpenStreetMap tiles.
const String osmAttribution = '© OpenStreetMap contributors';

/// Timeout in seconds for Overpass API requests.
const int overpassTimeoutSeconds = 30;

/// Timeout in seconds for location permission/acquisition.
const int locationTimeoutSeconds = 15;

/// Minimum accuracy in meters for GPS readings to be considered valid.
const double minimumLocationAccuracyMeters = 100.0;

/// Distance filter in meters for location updates.
/// Only trigger updates when player moves at least this far.
const int locationDistanceFilterMeters = 10;

/// Default map zoom level for gameplay.
const double defaultMapZoom = 16.0;

/// Minimum map zoom level.
const double minMapZoom = 10.0;

/// Maximum map zoom level.
const double maxMapZoom = 19.0;
