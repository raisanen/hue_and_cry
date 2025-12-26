# Hue & Cry - Location-Based Detective Game

## Project Overview

A location-based detective game inspired by "Sherlock Holmes Consulting Detective" tabletop games and styled after 1800s Police Gazette newspapers. Players solve pre-authored mystery cases by physically walking to real-world locations in their neighborhood, discovering clues, interviewing NPCs, and piecing together solutions.

The name "Hue & Cry" references the ancient English common law practice of loudly pursuing criminals—a fitting title for a game about chasing down leads.

## Core Concept

- Cases are **pre-authored templates** with abstract location requirements (e.g., "a café", "a park")
- At game start, locations are **bound to real POIs** in the player's neighborhood using OpenStreetMap data
- Players **physically travel** to locations (GPS verification) to unlock clues
- The goal is to solve the mystery in as few location visits as possible
- Scoring compares player's path to an optimal "Holmes" solution

## Target Platforms

- **Android** (primary mobile platform)
- **Web** (for desktop play and testing)

Note: Web platform uses browser geolocation API. Some features may be limited compared to native Android.

## Tech Stack

- **Framework**: Flutter 3.x (Android + Web)
- **State Management**: Riverpod (provider-based, testable)
- **Maps**: flutter_map with OpenStreetMap tiles (no API key needed)
- **Location Data**: Overpass API via HTTP (OSM query engine)
- **Geolocation**: geolocator package (works on both Android and Web)
- **Local Storage**: shared_preferences for settings, hive for game state
- **HTTP**: dio for API calls

No backend for MVP—everything runs client-side.

## Project Structure

```
hue_and_cry/
├── lib/
│   ├── main.dart
│   ├── app.dart                    # MaterialApp, theme, routing
│   │
│   ├── models/                     # Data classes (freezed recommended)
│   │   ├── story_role.dart         # Enum: crime_scene, witness, etc.
│   │   ├── poi.dart                # POI from Overpass
│   │   ├── case_template.dart      # The authored mystery
│   │   ├── location_requirement.dart
│   │   ├── character.dart
│   │   ├── clue.dart
│   │   ├── solution.dart
│   │   ├── bound_case.dart         # Template + real POIs
│   │   └── game_state.dart         # Player progress
│   │
│   ├── services/                   # Business logic
│   │   ├── overpass_service.dart   # Fetch POIs from Overpass API
│   │   ├── classification_service.dart  # OSM tags → StoryRole
│   │   ├── binding_service.dart    # Match template to POIs
│   │   ├── location_service.dart   # GPS wrapper
│   │   └── game_service.dart       # Clue unlocking, scoring
│   │
│   ├── providers/                  # Riverpod providers
│   │   ├── location_provider.dart
│   │   ├── case_provider.dart
│   │   ├── game_state_provider.dart
│   │   └── poi_provider.dart
│   │
│   ├── screens/                    # Full-page views
│   │   ├── home_screen.dart        # Case selection
│   │   ├── case_setup_screen.dart  # Fetching POIs, binding
│   │   ├── map_screen.dart         # Main gameplay map
│   │   ├── location_screen.dart    # Location detail, dialogue
│   │   ├── notebook_screen.dart    # Collected clues
│   │   └── solution_screen.dart    # Submit answer, scoring
│   │
│   ├── widgets/                    # Reusable components
│   │   ├── map/
│   │   │   ├── game_map.dart
│   │   │   ├── poi_marker.dart
│   │   │   └── player_marker.dart
│   │   ├── case/
│   │   │   ├── briefing_card.dart
│   │   │   ├── clue_card.dart
│   │   │   └── character_avatar.dart
│   │   └── common/
│   │       ├── loading_overlay.dart
│   │       ├── gazette_card.dart        # Police Gazette styled container
│   │       └── gazette_button.dart
│   │
│   ├── theme/                      # Police Gazette theming
│   │   ├── gazette_theme.dart      # ThemeData configuration
│   │   ├── gazette_colors.dart     # Color palette
│   │   └── gazette_typography.dart # Font styles
│   │
│   ├── data/                       # Static case content
│   │   └── cases/
│   │       └── vanishing_violinist.dart  # Hardcoded case for MVP
│   │
│   └── utils/
│       ├── geo_utils.dart          # Haversine distance, etc.
│       ├── text_interpolation.dart # {location:id} replacement
│       └── constants.dart
│
├── assets/
│   ├── fonts/                      # Period-appropriate typefaces
│   │   ├── OldStandardTT/          # Serif body text
│   │   └── UnifrakturMaguntia/     # Blackletter for headers (optional)
│   ├── images/
│   │   ├── gazette_header.png      # Masthead artwork
│   │   ├── ornaments/              # Victorian decorative elements
│   │   └── engravings/             # Woodcut-style illustrations
│   └── cases/                      # JSON cases (future)
│
├── web/
│   └── index.html                  # Web entry point
│
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml
│
├── test/
│   ├── services/
│   └── models/
│
└── pubspec.yaml
```

## Data Models

### StoryRole
Categories mapping real POIs to narrative functions:

```dart
enum StoryRole {
  crimeScene,    // Parks, alleys, parking areas, waterfronts
  witness,       // Residential areas, cafés, hotels
  suspectWork,   // Offices, shops, commercial buildings
  information,   // Cafés, bars, libraries, hairdressers
  authority,     // Police, hospitals, government buildings
  hidden,        // Churches, cemeteries, secluded areas
  atmosphere,    // General flavor, red herrings
}
```

### POI (from Overpass)

```dart
class POI {
  final int osmId;
  final String? name;
  final double lat;
  final double lon;
  final Map<String, String> osmTags;
  final List<StoryRole> storyRoles;
  
  String get displayName => name ?? _generateGenericName();
}
```

### LocationRequirement

```dart
class LocationRequirement {
  final String id;
  final StoryRole role;
  final List<String> preferredTags;  // e.g., ["amenity=cafe"]
  final bool required;
  final StoryRole? fallbackRole;
  final String descriptionTemplate;  // "a quiet café where..."
}
```

### Character

```dart
class Character {
  final String id;
  final String name;
  final String role;              // "bartender", "witness"
  final String locationId;        // References LocationRequirement
  final String description;
  final String initialDialogue;
  final Map<String, String> conditionalDialogue;  // clueId → dialogue
}
```

### Clue

```dart
enum ClueType { physical, testimony, observation, record }

class Clue {
  final String id;
  final ClueType type;
  final String locationId;
  final String title;
  final String discoveryText;
  final String notebookSummary;
  final List<String> prerequisites;  // Clue IDs needed first
  final List<String> reveals;        // Location IDs this unlocks
  final String? characterId;
  final bool isEssential;
  final bool isRedHerring;
}
```

### CaseTemplate

```dart
class CaseTemplate {
  final String id;
  final String title;
  final String subtitle;
  final String briefing;
  final Map<String, LocationRequirement> locations;
  final List<Character> characters;
  final List<Clue> clues;
  final Solution solution;
  final int parVisits;
  final int estimatedMinutes;
  final int difficulty;
}
```

### Solution

```dart
class Solution {
  final String perpetratorId;
  final String motive;
  final String method;
  final List<String> keyEvidence;   // Clue IDs
  final List<String> optimalPath;   // Location IDs
}
```

### BoundCase (runtime)

```dart
class BoundLocation {
  final String templateId;
  final POI poi;
  final String displayName;
  final double distanceFromStart;
}

class BoundCase {
  final CaseTemplate template;
  final LatLng playerStart;
  final Map<String, BoundLocation> boundLocations;
  final List<String> unboundOptional;
  
  bool get isPlayable => template.locations.entries
      .where((e) => e.value.required)
      .every((e) => boundLocations.containsKey(e.key));
}
```

### GameState

```dart
enum GamePhase { setup, active, solved }

class GameState {
  final String caseId;
  final GamePhase phase;
  final Set<String> visitedLocations;
  final Set<String> discoveredClues;
  final Set<String> unlockedLocations;  // Revealed by clues
  final List<String> visitOrder;        // For scoring
  final DateTime startedAt;
  final DateTime? completedAt;
}
```

## OSM Classification Rules

Map Overpass tags to StoryRoles:

```dart
final classificationRules = {
  // Crime scenes
  'leisure': {
    'park': [StoryRole.crimeScene, StoryRole.hidden],
    'garden': [StoryRole.crimeScene, StoryRole.hidden],
    'playground': [StoryRole.crimeScene],
  },
  'amenity': {
    'parking': [StoryRole.crimeScene],
  },
  
  // Information sources
  'amenity': {
    'cafe': [StoryRole.information, StoryRole.witness],
    'bar': [StoryRole.information, StoryRole.witness],
    'pub': [StoryRole.information, StoryRole.witness],
    'restaurant': [StoryRole.information, StoryRole.witness],
    'library': [StoryRole.information],
  },
  'shop': {
    'hairdresser': [StoryRole.information],
    'convenience': [StoryRole.information, StoryRole.witness],
  },
  
  // Suspect workplaces
  'amenity': {
    'bank': [StoryRole.suspectWork],
    'pharmacy': [StoryRole.suspectWork],
  },
  'office': {
    '*': [StoryRole.suspectWork],
  },
  'shop': {
    '*': [StoryRole.suspectWork],
  },
  
  // Authority
  'amenity': {
    'police': [StoryRole.authority],
    'hospital': [StoryRole.authority, StoryRole.witness],
    'townhall': [StoryRole.authority],
  },
  
  // Hidden meeting spots
  'amenity': {
    'place_of_worship': [StoryRole.hidden, StoryRole.atmosphere],
  },
  'landuse': {
    'cemetery': [StoryRole.hidden, StoryRole.atmosphere],
  },
  
  // Atmosphere
  'tourism': {
    'museum': [StoryRole.atmosphere, StoryRole.information],
    'hotel': [StoryRole.atmosphere, StoryRole.witness],
  },
  'historic': {
    '*': [StoryRole.atmosphere],
  },
};
```

## Overpass Query Template

```
[out:json][timeout:30];
(
  node["amenity"]["amenity"!~"^(bench|waste_basket|recycling)$"]({{bbox}});
  way["amenity"]["amenity"!~"^(bench|waste_basket|recycling)$"]({{bbox}});
  node["shop"]({{bbox}});
  way["shop"]({{bbox}});
  node["office"]({{bbox}});
  way["office"]({{bbox}});
  node["leisure"]({{bbox}});
  way["leisure"]({{bbox}});
  node["tourism"]({{bbox}});
  way["tourism"]({{bbox}});
  node["historic"]({{bbox}});
  way["historic"]({{bbox}});
  node["landuse"="cemetery"]({{bbox}});
  way["landuse"="cemetery"]({{bbox}});
);
out center;
```

Where `{{bbox}}` = `south,west,north,east` coordinates.

## Core User Flows

### Flow 1: Start New Case
1. Home screen shows available cases
2. Player taps case → sees briefing
3. Player taps "Start Investigation"
4. App requests location permission
5. App fetches POIs from Overpass (loading screen)
6. App attempts to bind case template to POIs
7. If successful → Map screen with bound locations
8. If failed → Error explaining missing location types

### Flow 2: Investigate Location
1. Player sees map with location markers
2. Markers show: locked 🔒, available ✓, visited ✗
3. Player physically walks to a location
4. When within 50m, location becomes "activatable"
5. Player taps marker → Location screen
6. Shows location description, available clues/NPCs
7. Player reads clues, adds to notebook
8. Some clues unlock new locations (reveals)

### Flow 3: Interview NPC
1. At location with NPC, player taps character
2. Shows character description + initial dialogue
3. If player has prerequisite clues, additional dialogue unlocks
4. New information added to notebook

### Flow 4: Solve Case
1. Player taps "Accuse" button (available anytime)
2. Shows list of characters → select perpetrator
3. Shows text field for motive summary
4. Player submits solution
5. App compares to correct solution
6. Shows results: correct/incorrect, score, optimal path
7. If correct → case complete, can replay or choose new case

## Proximity Detection

```dart
const double UNLOCK_RADIUS_METERS = 50.0;
const double VISIT_RADIUS_METERS = 30.0;

// Check if player can interact with location
bool canInteract(LatLng playerPos, LatLng locationPos) {
  return haversineDistance(playerPos, locationPos) <= UNLOCK_RADIUS_METERS;
}

// Check if player has "visited" for scoring
bool hasVisited(LatLng playerPos, LatLng locationPos) {
  return haversineDistance(playerPos, locationPos) <= VISIT_RADIUS_METERS;
}
```

## MVP Scope

### In Scope
- One complete hardcoded case ("The Vanishing Violinist")
- Real-time GPS tracking on map
- POI fetching and classification from Overpass
- Case binding to real neighborhood
- Proximity-based location unlocking
- Clue discovery with prerequisites
- NPC dialogue (initial + conditional)
- Simple notebook view
- Basic solution submission and scoring
- Local state persistence (resume interrupted game)

### Out of Scope for MVP
- Multiple cases / case selection
- User accounts / cloud sync
- Achievements / statistics
- Hint system
- Social features
- Offline maps
- Case editor
- Procedural case generation
- Time-of-day mechanics
- Photos/AR integration

## Key Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  flutter_map: ^6.0.0
  latlong2: ^0.9.0
  geolocator: ^10.0.0
  permission_handler: ^11.0.0
  dio: ^5.3.0
  hive: ^2.2.0
  hive_flutter: ^1.1.0
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0
  go_router: ^12.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  flutter_lints: ^3.0.0
```

## Platform Configuration

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### Web (web/index.html)
No special configuration needed. Browser geolocation API is used automatically.
Note: HTTPS required for geolocation on web (localhost exempt for development).

### Web Considerations
- Geolocation accuracy may be lower than native Android GPS
- Background location tracking not available
- Consider adding a "demo mode" with simulated location for web testing
- flutter_map works identically on web

## Testing Strategy

### Unit Tests
- Classification service: OSM tags → correct StoryRoles
- Binding service: template requirements → POI selection
- Game logic: prerequisite checking, clue unlocking
- Geo utils: distance calculations

### Integration Tests
- Overpass service with mock responses
- Full binding pipeline with sample POI data

### Manual Testing
- Real-world walking test in known neighborhood
- Edge cases: sparse areas, dense urban areas

## Design Notes: Police Gazette Aesthetic

The visual design mimics 1800s Police Gazette newspapers—sensationalist crime reporting with dramatic woodcut illustrations, bold typography, and a distinct sepia/cream color palette.

### Visual References
- The National Police Gazette (1845-1977)
- Victorian-era broadsheets and penny dreadfuls
- Wanted posters and crime notices
- Woodcut/engraving illustration style

### Color Palette

The app supports both light and dark themes. **Dark theme is the default**, evoking the atmosphere of reading by gaslight or candlelight—fitting for a Victorian mystery game and easier on the eyes for extended play sessions.

```dart
// gazette_colors.dart
class GazetteColors {
  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME COLORS (Classic aged paper look)
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Paper and backgrounds
  static const Color parchment = Color(0xFFF5F0E1);      // Aged paper cream
  static const Color paperWhite = Color(0xFFFAF8F5);     // Cleaner cream
  static const Color newsprint = Color(0xFFE8E4D9);      // Slightly gray paper
  
  // Inks
  static const Color inkBlack = Color(0xFF1A1A1A);       // Rich black text
  static const Color inkBrown = Color(0xFF3D2B1F);       // Aged ink, sepia
  static const Color inkFaded = Color(0xFF5C4B3A);       // Secondary text

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME COLORS (Midnight edition / gas-lit atmosphere)
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Dark backgrounds (like reading by candlelight)
  static const Color darkBackground = Color(0xFF1A1612);     // Deep warm black
  static const Color darkSurface = Color(0xFF2A2420);        // Slightly lighter
  static const Color darkCard = Color(0xFF332D28);           // Card background

  // Light text on dark (aged paper color as text)
  static const Color darkText = Color(0xFFE8E0D0);           // Warm cream text
  static const Color darkTextSecondary = Color(0xFFB8A898);  // Muted cream
  static const Color darkTextFaded = Color(0xFF8A7A6A);      // Faded text
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SHARED ACCENT COLORS (used in both themes)
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Accent colors (used sparingly, as spot color)
  static const Color bloodRed = Color(0xFF8B0000);       // Headlines, alerts
  static const Color bloodRedLight = Color(0xFFB33030);  // Lighter for dark theme
  static const Color copperplate = Color(0xFF6B4423);    // Decorative elements
  static const Color wanted = Color(0xFFB8860B);         // Gold/reward emphasis
  
  // Functional
  static const Color success = Color(0xFF2D5A27);        // Dark green
  static const Color error = Color(0xFF8B0000);          // Same as bloodRed
  static const Color disabled = Color(0xFF9E9E9E);
}
```

### Typography

Use period-appropriate typefaces. Recommendations (Google Fonts):

```dart
// gazette_typography.dart

// PRIMARY: Old Standard TT - elegant serif for body text
// Evokes 19th century printing, highly readable

// HEADERS: Playfair Display - high contrast serif
// Good for dramatic headlines, "MURDER MOST FOUL" style

// OPTIONAL ACCENT: UnifrakturMaguntia - blackletter/gothic
// Use VERY sparingly: masthead, special headers only
// Can be hard to read, so limit to decorative purposes

// MONOSPACE: Special Elite or Courier Prime
// Typewriter style for clue documents, evidence

class GazetteTypography {
  static const String primaryFamily = 'OldStandardTT';
  static const String headlineFamily = 'PlayfairDisplay';
  static const String blackletterFamily = 'UnifrakturMaguntia'; // optional
  static const String evidenceFamily = 'SpecialElite';
  
  static TextStyle masthead = TextStyle(
    fontFamily: headlineFamily,
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.0,
    color: GazetteColors.inkBlack,
  );
  
  static TextStyle headline = TextStyle(
    fontFamily: headlineFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: GazetteColors.inkBlack,
  );
  
  static TextStyle subheadline = TextStyle(
    fontFamily: primaryFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: GazetteColors.inkBrown,
  );
  
  static TextStyle body = TextStyle(
    fontFamily: primaryFamily,
    fontSize: 14,
    height: 1.5,
    color: GazetteColors.inkBlack,
  );
  
  static TextStyle caption = TextStyle(
    fontFamily: primaryFamily,
    fontSize: 12,
    fontStyle: FontStyle.italic,
    color: GazetteColors.inkFaded,
  );
  
  static TextStyle evidence = TextStyle(
    fontFamily: evidenceFamily,
    fontSize: 14,
    height: 1.6,
    color: GazetteColors.inkBrown,
  );
}
```

### UI Components

**GazetteCard** - Primary content container:
- Cream/parchment background
- Thin black border (1-2px)
- Optional decorative corner ornaments
- Drop shadow simulating paper stack

**Headlines** - Styled like newspaper headlines:
- ALL CAPS for major headlines
- Horizontal rules (decorative lines) above and below
- Sometimes with small ornamental flourishes (❧ ✦ ◆)

**Column Layout** - Newspaper-style when appropriate:
- Multi-column text for longer content
- Justified text alignment
- Drop caps for article beginnings

**Decorative Elements**:
- Horizontal rules with ornamental ends ──────❧❧──────
- Corner brackets for framing content
- Small woodcut-style icons for categories
- "REWARD" / "WANTED" banner styles for emphasis

**Buttons**:
- Solid dark background with cream text
- Or outlined with dark border
- Slightly rounded or fully rectangular
- Consider vintage "PRESS HERE" label style

**Map Markers**:
- Styled as map pins with gazette aesthetic
- Consider small flag or newspaper icon
- Red accent for critical locations
- Muted/sepia for visited locations

### Sample UI Patterns

```
╔══════════════════════════════════════════════╗
║            ❧ HUE & CRY ❧                     ║
║     BEING A CHRONICLE OF MYSTERY & CRIME     ║
╠══════════════════════════════════════════════╣
║                                              ║
║   ─────── THE VANISHING VIOLINIST ───────   ║
║                                              ║
║   A Most Peculiar Disappearance Confounds    ║
║   the Authorities of This Fair City          ║
║                                              ║
║   ════════════════════════════════════════   ║
║                                              ║
║   Three days past, the acclaimed violinist   ║
║   Maria Lindgren was last seen departing     ║
║   a private engagement...                    ║
║                                              ║
║            ┌─────────────────┐               ║
║            │ BEGIN ENQUIRY ▶ │               ║
║            └─────────────────┘               ║
╚══════════════════════════════════════════════╝
```

### Iconography

Prefer simple, woodcut-inspired icons:
- Magnifying glass (investigation)
- Quill/pen (notebook)
- Scales (justice/solution)
- Eye (witness)
- Key (clue discovered)
- Footprints (location/travel)
- Skull (danger/crime scene)

Consider creating simple SVG icons with rough, engraved line quality rather than smooth modern vectors.

### Animation Guidelines

Keep animations subtle and appropriate to the era:
- Fade transitions (like turning pages)
- No flashy modern effects
- Paper shuffle/stack effects
- Typewriter text reveal for dramatic moments
- Subtle parallax on decorative elements