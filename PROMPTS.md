# Hue & Cry - Implementation Prompts for Claude Code

Use these prompts in sequence. Each builds on the previous. Copy-paste one at a time into Claude Code.

---

## Prompt 1: Project Setup -- DONE

```
1. Make sure this project is targeting Android & Web.

2. Set up pubspec.yaml with these dependencies:
   - flutter_riverpod for state management
   - flutter_map and latlong2 for maps
   - geolocator and permission_handler for GPS
   - dio for HTTP
   - hive and hive_flutter for local storage
   - freezed_annotation, json_annotation for models
   - go_router for navigation
   - google_fonts for typography (Old Standard TT, Playfair Display)
   - Add build_runner, freezed, json_serializable as dev dependencies

3. Create the folder structure as defined in CLAUDE.md, including:
   - lib/theme/ folder for Police Gazette styling
   - assets/fonts/ and assets/images/ornaments/ folders

4. Configure Android permissions for location access as specified in CLAUDE.md

5. Create a minimal main.dart that:
   - Initializes Hive
   - Sets up ProviderScope
   - Runs a placeholder App widget

6. Verify the project compiles and runs on both Android emulator and Chrome (web).
```

---

## Prompt 2: Data Models -- DONE

```
Create all the data models for Hue and Cry using Freezed for immutability and JSON serialization.

Create these files in lib/models/:

1. story_role.dart
   - StoryRole enum with values: crimeScene, witness, suspectWork, information, authority, hidden, atmosphere

2. poi.dart (with Freezed)
   - POI class with: osmId, name (nullable), lat, lon, osmTags (Map<String, String>), storyRoles (List<StoryRole>)
   - Add a displayName getter that returns name or generates a generic name from tags

3. location_requirement.dart (with Freezed)
   - id, role (StoryRole), preferredTags (List<String>), required (bool), fallbackRole (StoryRole?), descriptionTemplate (String)

4. character.dart (with Freezed)
   - id, name, role, locationId, description, initialDialogue, conditionalDialogue (Map<String, String>)

5. clue.dart (with Freezed)
   - ClueType enum: physical, testimony, observation, record
   - Clue class: id, type, locationId, title, discoveryText, notebookSummary, prerequisites (List<String>), reveals (List<String>), characterId (nullable), isEssential, isRedHerring

6. solution.dart (with Freezed)
   - perpetratorId, motive, method, keyEvidence (List<String>), optimalPath (List<String>)

7. case_template.dart (with Freezed)
   - id, title, subtitle, briefing, locations (Map<String, LocationRequirement>), characters (List<Character>), clues (List<Clue>), solution (Solution), parVisits, estimatedMinutes, difficulty

8. bound_case.dart (with Freezed)
   - BoundLocation: templateId, poi, displayName, distanceFromStart
   - BoundCase: template, playerStart (LatLng from latlong2), boundLocations (Map<String, BoundLocation>), unboundOptional (List<String>)
   - Add isPlayable getter

9. game_state.dart (with Freezed)
   - GamePhase enum: setup, active, solved
   - GameState: caseId, phase, visitedLocations (Set<String>), discoveredClues (Set<String>), unlockedLocations (Set<String>), visitOrder (List<String>), startedAt, completedAt (nullable)

Run build_runner to generate the Freezed code.
```

---

## Prompt 3: Utility Functions -- DONE

```
Create utility functions in lib/utils/:

1. geo_utils.dart
   - haversineDistance(LatLng point1, LatLng point2) -> double (meters)
   - isWithinRadius(LatLng center, LatLng point, double radiusMeters) -> bool
   - calculateBoundingBox(LatLng center, double radiusMeters) -> (south, west, north, east) as a record or class
   - Constants: UNLOCK_RADIUS_METERS = 50.0, VISIT_RADIUS_METERS = 30.0

2. text_interpolation.dart
   - interpolateLocationText(String template, Map<String, BoundLocation> locations) -> String
   - Should replace {location:id} patterns with the bound location's displayName
   - Example: "Meet me at {location:cafe_practice}" → "Meet me at Café Linné"

3. constants.dart
   - App name: "Hue & Cry"
   - Overpass API URL
   - Default search radius (1000 meters)
   - Map tile URL template for OpenStreetMap

Write unit tests for geo_utils.dart in test/utils/geo_utils_test.dart.
```

---

## Prompt 4: Overpass Service -- DONE

```
Create the Overpass API service in lib/services/overpass_service.dart:

1. Create OverpassService class with Dio for HTTP:
   - Constructor takes optional Dio instance for testing
   - fetchPOIs(LatLng center, {double radiusMeters = 1000}) -> Future<List<POI>>

2. Build the Overpass QL query as specified in CLAUDE.md:
   - Query for amenity, shop, office, leisure, tourism, historic, cemetery
   - Exclude trivial amenities (bench, waste_basket, etc.)
   - Use bounding box calculated from center + radius
   - Request JSON output with "out center" for way centroids

3. Parse the Overpass response:
   - Handle both nodes and ways
   - Extract coordinates (use center for ways)
   - Extract all tags
   - Skip elements without valid coordinates

4. Don't classify POIs here - just return raw POI objects with empty storyRoles
   (classification happens in a separate service)

5. Handle errors gracefully:
   - Timeout (Overpass can be slow)
   - Rate limiting
   - Network errors
   - Return empty list on failure, log error

Create a Riverpod provider in lib/providers/poi_provider.dart:
- overpassServiceProvider
- poisProvider(LatLng center, double radius) as a FutureProvider

Write unit tests with mocked Dio responses.
```

---

## Prompt 5: Classification Service -- DONE

```
Create the POI classification service in lib/services/classification_service.dart:

1. Define the classification rules as a data structure matching CLAUDE.md:
   - Map OSM tag keys/values to lists of StoryRoles
   - Support wildcard matching for categories like "office=*" and "shop=*"

2. Create ClassificationService with method:
   - classifyPOI(POI poi) -> List<StoryRole>
   - Check poi.osmTags against classification rules
   - Return all matching roles
   - Return [StoryRole.atmosphere] as fallback if no matches

3. Add batch method:
   - classifyAll(List<POI> pois) -> List<POI>
   - Returns new POI instances with storyRoles populated

4. Create helper to get POIs by role:
   - groupByRole(List<POI> pois) -> Map<StoryRole, List<POI>>

Update the poisProvider to also run classification after fetching.

Write comprehensive unit tests covering:
- Each StoryRole has at least one matching rule
- Wildcard matching works
- Multiple roles can be assigned to one POI
- Fallback to atmosphere works
```

---

## Prompt 6: Binding Service -- DONE

```
Create the case binding service in lib/services/binding_service.dart:

1. Create BindingService with method:
   - bindCase(CaseTemplate template, List<POI> availablePOIs, LatLng playerLocation) -> BoundCase

2. Binding algorithm:
   - Group available POIs by StoryRole
   - Sort each group by distance from playerLocation (closest first)
   - Process template locations in order: required first, then optional
   - For each location requirement:
     a. Find unused POIs matching the required role
     b. If none, try fallbackRole
     c. If found, mark POI as used, create BoundLocation
     d. If not found and required, binding fails for this location
   - Track which optional locations couldn't be bound

3. Create BoundCase with:
   - All successfully bound locations
   - List of unbound optional location IDs
   - Calculate isPlayable based on whether all required locations are bound

4. Add method to check case compatibility before full binding:
   - canBindCase(CaseTemplate template, Map<StoryRole, int> availableRoleCounts) -> bool
   - Quick check if neighborhood has minimum required locations

Create provider in lib/providers/case_provider.dart:
- bindingServiceProvider
- boundCaseProvider(CaseTemplate, List<POI>, LatLng) as FutureProvider

Write tests with mock POI data covering:
- Successful full binding
- Partial binding (optional locations missing)
- Failed binding (required location missing)
- Distance-based selection (closer POIs preferred)
- No POI reuse across locations
```

---

## Prompt 7: Sample Case Data -- DONE

```
Create a complete sample case in lib/data/cases/vanishing_violinist.dart:

Generate and implement "The Vanishing Violinist" case:

1. Case overview:
   - Violinist Maria Lindgren disappeared after a performance
   - Her husband Erik is the perpetrator (insurance fraud motive)
   - Par visits: 4

2. Locations (7 total, 4 required):
   - cafe_practice (information, required) - where Maria practiced
   - orchestra_hall (suspectWork, required) - rehearsal space
   - husband_office (suspectWork, required) - Erik's workplace
   - park_meeting (hidden, required) - secret meeting spot
   - police_station (authority, optional) - get official records
   - rival_apartment (witness, optional) - red herring
   - antique_shop (atmosphere, optional) - flavor

3. Characters (3):
   - Jan the barista at cafe
   - Henrik Berg the conductor at orchestra hall
   - Erik Lindgren the husband at his office
   - Each with initial dialogue and conditional dialogue triggered by specific clues

4. Clues (5+):
   - Schedule clue at cafe (reveals park_meeting)
   - Argument testimony from barista (requires schedule)
   - Insurance records at police (requires argument)
   - Park witness testimony (requires schedule)
   - Red herring about jealous rival

5. Solution:
   - Perpetrator: Erik
   - Key evidence: insurance, park_witness, argument
   - Optimal path: cafe → park → police → husband_office

Export as a constant: vanishingViolinistCase

Make the case content atmospheric and engaging - this is the demo case that will show off the game.
```

---

## Prompt 8: Game Logic Service -- DONE

```
Create the game logic service in lib/services/game_service.dart:

1. Create GameService that manages game state transitions:

   Methods:
   - startCase(BoundCase boundCase) -> GameState
     Creates initial state with starting location unlocked
   
   - visitLocation(GameState state, String locationId, LatLng playerPos, BoundCase boundCase) -> GameState?
     Validates player is within range, marks visited, returns updated state or null if invalid
   
   - discoverClue(GameState state, String clueId, BoundCase boundCase) -> GameState
     Checks prerequisites met, adds to discovered clues, unlocks revealed locations
   
   - canDiscoverClue(GameState state, Clue clue) -> bool
     Checks if all prerequisites are in discoveredClues
   
   - getAvailableClues(GameState state, String locationId, BoundCase boundCase) -> List<Clue>
     Returns clues at location that can be discovered (prerequisites met, not already discovered)
   
   - getCharacterDialogue(GameState state, Character character) -> String
     Returns appropriate dialogue based on discovered clues
   
   - submitSolution(GameState state, String accusedId, BoundCase boundCase) -> SolutionResult
     Compares to correct solution, calculates score

2. Create SolutionResult class:
   - isCorrect: bool
   - correctPerpetrator: String
   - playerVisits: int
   - optimalVisits: int
   - score: int (calculate based on visits vs par)
   - essentialCluesFound: int
   - totalEssentialClues: int

3. Scoring formula:
   - Base score: 100 points if correct perpetrator
   - Efficiency bonus: +10 per visit under par
   - Efficiency penalty: -5 per visit over par
   - Evidence bonus: +5 per essential clue found
   - Minimum score: 0

Create providers in lib/providers/game_state_provider.dart:
- gameServiceProvider
- activeGameStateProvider (StateNotifier for current game)
- Persist state to Hive on changes

Write comprehensive tests for all game logic.
```

---

## Prompt 9: Location Service -- DONE

```
Create the GPS location service in lib/services/location_service.dart:

1. Create LocationService wrapping the geolocator package:

   Methods:
   - checkPermission() -> Future<LocationPermission>
   - requestPermission() -> Future<LocationPermission>
   - isLocationServiceEnabled() -> Future<bool>
   - getCurrentPosition() -> Future<Position>
   - getPositionStream({int distanceFilter = 10}) -> Stream<Position>

2. Handle all permission states:
   - denied → request permission
   - deniedForever → show settings prompt
   - whileInUse / always → proceed

3. Convert geolocator Position to LatLng for consistency with flutter_map

4. Create a LocationState class:
   - status: enum (unknown, checking, denied, deniedForever, disabled, ready)
   - currentPosition: LatLng?
   - lastUpdated: DateTime?
   - error: String?

Create providers in lib/providers/location_provider.dart:
- locationServiceProvider
- locationStateProvider (StreamProvider that manages permission + position)
- currentPositionProvider (derived, just the LatLng)

Handle the case where user moves - update provider when position changes significantly.
```

---

## Prompt 10: Basic UI - App Shell, Theme, and Navigation -- DONE

```
Create the app shell, Police Gazette theme, and navigation structure:

1. Create the theme files in lib/theme/:

   gazette_colors.dart:
   - Define the color palette as specified in CLAUDE.md
   - Parchment, paper, ink colors
   - Blood red accent, copper decorative color
   
   gazette_typography.dart:
   - Use google_fonts package
   - Primary: Old Standard TT for body text
   - Headlines: Playfair Display for dramatic headers
   - Evidence: Special Elite for typewriter-style clue text
   - Define TextStyle constants for masthead, headline, subheadline, body, caption, evidence
   
   gazette_theme.dart:
   - Create ThemeData with the gazette aesthetic
   - Parchment background, dark ink text
   - Custom AppBar styling (dark with cream text)
   - Card themes with subtle borders
   - Button themes (solid dark or outlined)
   - Configure both light theme (primary) and optional dark theme

2. Update lib/app.dart:
   - Set up MaterialApp.router with GoRouter
   - Apply the gazette theme
   - Configure custom scroll behavior if needed

3. Set up GoRouter in lib/app.dart or separate router file:
   Routes:
   - / → HomeScreen (case selection)
   - /case/:caseId/setup → CaseSetupScreen (loading, binding)
   - /case/:caseId/play → MapScreen (main gameplay)
   - /case/:caseId/location/:locationId → LocationScreen
   - /case/:caseId/notebook → NotebookScreen
   - /case/:caseId/solve → SolutionScreen

4. Create placeholder screens in lib/screens/:
   - Each screen should be a ConsumerWidget (for Riverpod)
   - Show screen name with gazette-styled header
   - Include basic AppBar with navigation

5. Create common gazette-styled widgets in lib/widgets/common/:
   - GazetteCard: Parchment card with thin border, optional corner ornaments
   - GazetteButton: Period-appropriate button styling
   - GazetteDivider: Decorative horizontal rule with ornaments
   - GazetteHeader: Styled section header with rules above/below

Verify navigation works and theme is applied consistently.
```

---

## Prompt 11: Home Screen -- DONE

```
Create the home screen in lib/screens/home_screen.dart with Police Gazette styling:

1. Masthead header:
   - "HUE & CRY" in large Playfair Display, preferably with decorative elements
   - Subtitle: "Being a Chronicle of Mystery & Crime" in italic
   - Decorative horizontal rules above and below
   - Consider a simple woodcut-style logo/icon

2. Show a list of available cases styled as newspaper front pages:
   - For MVP, just show the Vanishing Violinist case
   - Design the list to support multiple cases later

3. Each case card should look like a newspaper headline:
   - Decorative border (gazette card style)
   - Title as dramatic headline: "THE VANISHING VIOLINIST"
   - Subtitle in italic: "A Most Peculiar Disappearance"
   - Difficulty shown as stars or period-appropriate indicator
   - Estimated duration: "Requiring approximately 45 minutes of enquiry"
   - Brief teaser in newspaper prose style

4. Tapping a case shows a bottom sheet or dialog styled as a case file:
   - "THE PARTICULARS OF THE CASE" header
   - Full briefing text in newspaper column style
   - "COMMENCE INVESTIGATION" button
   - "DISMISS" or back option

5. "COMMENCE INVESTIGATION" navigates to /case/:caseId/setup

6. Create reusable CaseCard widget in lib/widgets/case/

The whole screen should feel like opening a 19th century crime gazette.
```

---

## Prompt 12: Case Setup Screen -- DONE

```
Create the case setup screen in lib/screens/case_setup_screen.dart:

This screen handles the async loading process when starting a case.

1. On mount, orchestrate this sequence:
   a. Check/request location permission
   b. Get current position
   c. Fetch POIs from Overpass (show progress)
   d. Classify POIs
   e. Bind case template to POIs
   f. If successful, initialize game state and navigate to map
   g. If failed, show error with retry option

2. Show loading states with gazette-styled atmospheric text:
   - "OBTAINING YOUR WHEREABOUTS..." (with animated ellipsis)
   - "SURVEYING THE DISTRICT..."
   - "IDENTIFYING PERSONS OF INTEREST..."
   - "PREPARING YOUR CASE FILE..."
   Use decorative dividers between steps, show checkmarks for completed steps.

3. Handle errors gracefully with period-appropriate messaging:
   - Location permission denied: "Alas! We cannot proceed without knowledge of your location. Pray adjust your settings."
   - Location services disabled: "Your device's location services appear dormant."
   - Overpass fetch failed: "The telegraph lines are down. Shall we try again?"
   - Binding failed: "This district lacks sufficient locations of interest. Perhaps venture to a more populous area?"

4. Platform-specific handling:
   - On web: Note that browser location may be less precise
   - Consider offering "Demo Mode" on web that uses a fixed location for testing

5. Show a summary before proceeding (styled as a case file):
   - "DISTRICT SURVEY COMPLETE"
   - "Locations catalogued: X"
   - "Investigation sites identified: Y"
   - Optional: show mini-map preview of bound locations

6. "PROCEED TO INVESTIGATION" button in gazette style

Create a LoadingStep widget for consistent step display with gazette aesthetic.
```

---

## Prompt 13: Map Screen -- DONE

```
Create the main map screen in lib/screens/map_screen.dart:

1. Full-screen flutter_map with OpenStreetMap tiles:
   - Consider using a sepia/vintage map tile style if available (e.g., Stamen Toner or custom styled tiles)
   - Or apply a subtle sepia ColorFilter over standard tiles
   - Center on player's current position
   - Appropriate zoom level to show nearby locations (zoom 15-16)

2. Display markers for bound locations:
   - Design markers with gazette aesthetic (not modern pins)
   - Consider: small flags, newspaper icons, or vintage map markers
   - Marker states:
     - Locked (not yet revealed): Faded/gray, perhaps with "?" 
     - Available (unlocked, not visited): Bold, highlighted with subtle glow
     - Visited: Checkmark overlay, muted colors
   - Use custom marker widgets, not just icons

3. Player position marker:
   - Distinctive design (perhaps a magnifying glass or detective silhouette)
   - Subtle pulse animation
   - Always renders on top

4. Bottom panel styled as gazette newspaper footer:
   - Case title in headline style
   - "Locations visited: X of Y"
   - "Clues discovered: X of Y"  
   - Quick access button to notebook (quill icon?)

5. Tapping a location marker:
   - If within UNLOCK_RADIUS: navigate to location screen
   - If too far: show gazette-styled tooltip with distance
     "You are X yards distant. Draw nearer to investigate."

6. Floating action buttons or period-styled menu:
   - Re-center on player (compass icon)
   - Open notebook (book/quill icon)
   - "MAKE ACCUSATION" button (scales of justice icon) - styled prominently

7. Handle both Android GPS and web browser geolocation.

Create marker widgets in lib/widgets/map/:
- PlayerMarker with gazette styling
- LocationMarker with state variants
```

---

## Prompt 14: Location Screen -- DONE

```
Create the location investigation screen in lib/screens/location_screen.dart:

Style as a gazette "special report" about this location.

1. Header section (styled as newspaper article header):
   - Location display name in headline style
   - Description from template (interpolated) as subheadline/lede
   - "DISTANCE: X yards" indicator
   - Visual banner if player is "at" location: "YOU HAVE ARRIVED"

2. If player is within visit radius, show investigation content:

   a. "EVIDENCE" section (clues available):
      - List clues at this location that can be discovered
      - Each clue styled as a gazette card with:
        - Clue type icon (key, document, eye, etc.)
        - Title in bold
        - Brief preview text
      - Tapping reveals full discovery text in modal/expanded view
      - "ADD TO CASEBOOK" button marks as discovered

   b. "PERSONS OF INTEREST" section (if NPCs present):
      - Character name and role as subheading
      - Character description in italic
      - Dialogue in quoted block style
      - If character gives testimony clue: "MAKE NOTE OF THIS" button
      - Show different dialogue if player has relevant discovered clues

3. If player is too far:
   - Show distance remaining prominently
   - "You must draw nearer to conduct your enquiries"
   - Optional: compass direction indicator

4. "RETURN TO MAP" button in footer

5. Clue discovery feedback:
   - Brief "NOTED!" or "EVIDENCE SECURED" animation
   - If clue reveals new locations: "NEW LOCATION DISCOVERED!" notification banner
   - Subtle typewriter sound effect (optional for MVP)

Create widgets:
- ClueCard in lib/widgets/case/ with gazette styling
- CharacterCard in lib/widgets/case/ with portrait frame aesthetic
- EvidenceModal for expanded clue view
```

---

## Prompt 15: Notebook Screen -- DONE

```
Create the notebook screen in lib/screens/notebook_screen.dart:

Style as a detective's casebook with gazette newspaper clippings pasted in.

1. Header: "YOUR CASEBOOK" with decorative rules

2. Tab or section structure (styled as tabbed dividers):
   - EVIDENCE (discovered clues)
   - LOCATIONS (places visited)
   - PERSONS (characters encountered)

3. EVIDENCE tab:
   - List discovered clues as "pasted newspaper clippings"
   - Each entry in a slightly tilted gazette card (subtle rotation)
   - Shows:
     - Clue title as mini-headline
     - Type indicator (small icon)
     - Location where found
     - Notebook summary text
   - Tapping expands to show full discovery text
   - Consider handwritten-style annotations

4. LOCATIONS tab:
   - List of all unlocked locations
   - Styled as a gazette "directory" or "index"
   - Visited: checkmark, full details
   - Not yet visited: faded, "REQUIRES INVESTIGATION"
   - Show which clues (if any) were found at each

5. PERSONS tab:
   - Character portraits (placeholder frames for MVP)
   - Name and role as subheading
   - Key quotes from their testimony
   - "SUSPECT?" indicator that player could toggle (optional)

6. Navigation:
   - "RETURN TO INVESTIGATION" button
   - "MAKE ACCUSATION" button (prominent, perhaps with blood-red accent)

7. Design touches:
   - Parchment/aged paper background
   - Subtle coffee stain or ink blot decorations (optional)
   - Decorative corner brackets on cards
   - Consider newspaper column layout for text-heavy sections

Make this feel like a physical scrapbook of collected evidence.
```

---

## Prompt 16: Solution Screen -- DONE

```
Create the solution/accusation screen in lib/screens/solution_screen.dart:

Style as a dramatic gazette "EXTRA! EXTRA!" special edition.

1. Two phases: accusation and results

ACCUSATION PHASE:
2. Header: "THE ACCUSATION" with dramatic styling

3. Prompt styled as formal legal document:
   "Having gathered the evidence, whom do you accuse of this most heinous crime?"

4. Display all characters as "WANTED" style cards:
   - Portrait frame (placeholder silhouette for MVP)
   - Character name in bold
   - Their role and where encountered
   - Radio button or tap to select
   - Selected card gets prominent border/glow

5. Optional motive field styled as testimony:
   "State your case: What was their motive?"
   (Typewriter-style text input)

6. "SUBMIT ACCUSATION" button in blood-red accent
   - Confirmation dialog styled as formal declaration:
     "You hereby accuse [NAME] of the crime. This decision is FINAL. Proceed?"

RESULTS PHASE:
7. Dramatic reveal with gazette "EXTRA" styling:

   If correct:
   - "CASE SOLVED!" banner with decorative flourishes
   - "JUSTICE PREVAILS IN THE MATTER OF [CASE NAME]"
   - Full solution story as newspaper article
   - Score breakdown styled as official report:
     - "Locations visited: X (Scotland Yard solved it in Y)"
     - "Efficiency rating: EXCELLENT/GOOD/ADEQUATE/POOR"
     - "Evidence secured: X of Y essential clues"
     - "Final score: XXX points"

   If incorrect:
   - "THE GUILTY PARTY ESCAPES!" dramatic headline
   - "Alas, [ACCUSED] was not the perpetrator..."
   - Reveal correct answer as "shocking revelation"
   - Show key evidence that pointed to true culprit
   - Encourage replay: "Perhaps a fresh investigation is warranted?"

8. After results:
   - "RETURN TO FRONT PAGE" button (go home)
   - "REVIEW CASEBOOK" button (see what you found)

Add dramatic flair—this is the climax! Consider:
- Typewriter text animation for the reveal
- Paper unfold/flip animation
- Stamp effect for "CASE CLOSED"
```

---

## Prompt 17: Polish and Integration

```
Review and polish the complete app for both Android and Web:

1. State persistence:
   - Ensure game state saves to Hive on every change
   - On app launch, check for in-progress game
   - Offer to resume or start fresh (styled as gazette dialog)

2. Error handling throughout:
   - Network errors (Overpass) - gazette-styled error cards
   - GPS failures or timeouts
   - Edge cases in game logic
   - All error messages in period-appropriate voice

3. Loading states:
   - Add shimmer/skeleton loaders with gazette aesthetic
   - Ensure no blank screens during async operations
   - Consider newspaper "printing" animation

4. Empty states:
   - No clues yet: "Your casebook awaits its first entry..."
   - No locations unlocked: "The investigation has yet to begin..."
   - Style these with gazette flair

5. Platform-specific polish:
   
   Android:
   - Test GPS accuracy and updates
   - Handle app backgrounding gracefully
   - Test on various screen sizes
   
   Web:
   - Ensure responsive layout for desktop browsers
   - Handle browser geolocation limitations gracefully
   - Test keyboard navigation
   - Consider touch vs mouse interactions
   - Test on Chrome, Firefox, Safari

6. Accessibility:
   - Semantic labels on all interactive elements
   - Sufficient color contrast (important with sepia palette!)
   - Screen reader support for key flows
   - Test with TalkBack (Android) and screen readers (web)

7. Performance:
   - Don't re-fetch POIs unnecessarily
   - Efficient marker rendering on map
   - Throttle location updates appropriately
   - Optimize font loading (especially for web)

8. Final testing checklist:
   - Fresh install flow (Android)
   - First visit flow (Web)
   - Complete case playthrough on both platforms
   - Interrupted game resume
   - Permission denied scenarios
   - No internet scenario
   - Walking simulation (for indoor testing)

9. Web-specific considerations:
   - Add manifest.json for PWA support
   - Appropriate favicon with gazette aesthetic
   - Meta tags for social sharing
   - Loading splash screen
```

---

## Prompt 18: Debug Mode and Web Demo Mode

```
Create debug/testing features and a web demo mode:

1. Debug overlay accessible via:
   - Long press on app title (3 seconds), or
   - ?debug=true URL parameter on web
   - Hidden settings toggle

2. Debug features (both platforms):

   a. Fake GPS position:
      - Show a draggable marker on map
      - Use this position instead of real GPS
      - Toggle between real and fake GPS

   b. Teleport to location:
      - Dropdown of all bound locations
      - "Teleport" button sets fake position to that location

   c. Skip proximity checks:
      - Toggle to interact with any location regardless of distance

   d. Reveal all locations:
      - Button to unlock all locations (ignore clue reveals)

   e. Auto-discover clues:
      - Button to mark all clues at current location as discovered

3. Web Demo Mode (special for web platform):
   
   Since web users may not want to walk around, offer:
   
   a. "ARMCHAIR DETECTIVE" mode on case setup:
      - Uses a predefined location (e.g., central London, Stockholm, NYC)
      - Pre-binds to real POIs in that area
      - All locations immediately accessible (no walking required)
      - Still requires solving the puzzle
   
   b. Virtual walking:
      - Click on map to "walk" there
      - Brief animation of movement
      - Location unlocks when you "arrive"

4. Visual indicator when debug/demo mode is active:
   - Gazette-styled banner: "DEMONSTRATION EDITION" or "DEBUG MODE ENGAGED"

5. Build configuration:
   - Debug mode available in debug builds
   - Demo mode available in all web builds
   - Can be disabled via environment variable for production

This is essential for:
- Testing without physically walking
- Demos and presentations
- Web users who want to try the game from their desk
- Development iteration speed
```

---

## Bonus Prompt: Case Authoring Guide

```
Create a markdown guide for authoring new cases: docs/CASE_AUTHORING.md

Include:

1. Overview of Hue & Cry case structure and how binding works

2. Step-by-step guide to creating a new case:
   - Start with the solution (perpetrator, motive, method)
   - Work backwards to determine what evidence proves it
   - Design the clue dependency graph
   - Assign clues to abstract location types
   - Create NPCs to deliver testimony clues
   - Add red herrings and atmosphere
   - Balance required vs optional locations
   - Set par visit count

3. Writing tips:
   - Keep descriptions location-agnostic
   - Use {location:id} interpolation
   - Write engaging dialogue in period-appropriate voice
   - Make clue connections logical but not obvious
   - Embrace the gazette newspaper style in all text

4. Testing checklist:
   - Verify case validates (no broken references)
   - Test binding against various neighborhoods
   - Playtest the full case on both Android and web
   - Check solution is discoverable
   - Test in Armchair Detective mode

5. Example template JSON/Dart structure to copy

This will be useful if you want to create more cases later or open case authoring to others.
```