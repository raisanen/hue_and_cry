import 'package:flutter_test/flutter_test.dart';
import 'package:hue_and_cry/models/bound_case.dart';
import 'package:hue_and_cry/models/case_template.dart';
import 'package:hue_and_cry/models/character.dart';
import 'package:hue_and_cry/models/clue.dart';
import 'package:hue_and_cry/models/game_state.dart';
import 'package:hue_and_cry/models/location_requirement.dart';
import 'package:hue_and_cry/models/poi.dart';
import 'package:hue_and_cry/models/solution.dart';
import 'package:hue_and_cry/models/story_role.dart';
import 'package:hue_and_cry/services/game_service.dart';
import 'package:latlong2/latlong.dart';

void main() {
  late GameService gameService;
  late BoundCase testCase;

  // Test locations
  const cafeLocation = LatLng(51.5074, -0.1278);
  const parkLocation = LatLng(51.5080, -0.1285);
  const playerStart = LatLng(51.5070, -0.1275);

  setUp(() {
    gameService = GameService();

    // Create a test case with locations, characters, and clues
    final template = CaseTemplate(
      id: 'test_case',
      title: 'Test Case',
      subtitle: 'A Test Mystery',
      teaser: 'A test mystery teaser.',
      briefing: 'Solve the test mystery.',
      locations: {
        'cafe': const LocationRequirement(
          id: 'cafe',
          role: StoryRole.information,
          descriptionTemplate: 'A cozy café',
          required: true,
        ),
        'park': const LocationRequirement(
          id: 'park',
          role: StoryRole.crimeScene,
          descriptionTemplate: 'A quiet park',
          required: true,
        ),
        'office': const LocationRequirement(
          id: 'office',
          role: StoryRole.suspectWork,
          descriptionTemplate: 'A busy office',
          required: false,
        ),
        'hidden': const LocationRequirement(
          id: 'hidden',
          role: StoryRole.hidden,
          descriptionTemplate: 'A secret location',
          required: false,
        ),
      },
      characters: const [
        Character(
          id: 'barista',
          name: 'Jane',
          role: 'Barista',
          locationId: 'cafe',
          description: 'A friendly barista',
          initialDialogue: 'Hello! What can I get you?',
          conditionalDialogue: {
            'clue_note': 'Oh, you found that note? Let me tell you more...',
            'clue_photo': "I recognize that photo! That's our regular.",
          },
        ),
        Character(
          id: 'suspect',
          name: 'Bob',
          role: 'Office Worker',
          locationId: 'office',
          description: 'A nervous man',
          initialDialogue: 'What do you want?',
        ),
      ],
      clues: const [
        // Clue with no prerequisites at cafe
        Clue(
          id: 'clue_note',
          type: ClueType.physical,
          locationId: 'cafe',
          title: 'Mysterious Note',
          discoveryText: 'You find a note on the table.',
          notebookSummary: 'A note with cryptic writing.',
          prerequisites: [],
          reveals: ['hidden'],
          isEssential: true,
        ),
        // Clue that requires clue_note
        Clue(
          id: 'clue_photo',
          type: ClueType.physical,
          locationId: 'cafe',
          title: 'Old Photo',
          discoveryText: 'A photo falls out of the note.',
          notebookSummary: 'Photo of two people.',
          prerequisites: ['clue_note'],
          reveals: [],
          isEssential: true,
        ),
        // Clue at park with no prereqs
        Clue(
          id: 'clue_footprints',
          type: ClueType.observation,
          locationId: 'park',
          title: 'Footprints',
          discoveryText: 'Strange footprints in the mud.',
          notebookSummary: 'Large footprints heading east.',
          prerequisites: [],
          reveals: ['office'],
          isEssential: false,
        ),
        // Clue at office with prereqs
        Clue(
          id: 'clue_document',
          type: ClueType.record,
          locationId: 'office',
          title: 'Secret Document',
          discoveryText: 'A damning document.',
          notebookSummary: 'Evidence of fraud.',
          prerequisites: ['clue_footprints'],
          reveals: [],
          isEssential: true,
        ),
        // Red herring
        Clue(
          id: 'clue_red_herring',
          type: ClueType.observation,
          locationId: 'park',
          title: 'Red Herring',
          discoveryText: 'Something suspicious that leads nowhere.',
          notebookSummary: 'A misleading clue.',
          prerequisites: [],
          reveals: [],
          isRedHerring: true,
        ),
      ],
      solution: const Solution(
        perpetratorId: 'suspect',
        motive: 'Greed',
        method: 'Fraud',
        keyEvidence: ['clue_note', 'clue_document'],
        optimalPath: ['cafe', 'park', 'office'],
      ),
      parVisits: 3,
      estimatedMinutes: 30,
      difficulty: 2,
    );

    // Create bound locations
    testCase = BoundCase(
      template: template,
      playerStart: playerStart,
      boundLocations: {
        'cafe': BoundLocation(
          templateId: 'cafe',
          poi: const POI(
            osmId: 1,
            name: 'Test Café',
            lat: 51.5074,
            lon: -0.1278,
            osmTags: {'amenity': 'cafe'},
            storyRoles: [StoryRole.information],
          ),
          displayName: 'Test Café',
          distanceFromStart: 50,
        ),
        'park': BoundLocation(
          templateId: 'park',
          poi: const POI(
            osmId: 2,
            name: 'Central Park',
            lat: 51.5080,
            lon: -0.1285,
            osmTags: {'leisure': 'park'},
            storyRoles: [StoryRole.crimeScene],
          ),
          displayName: 'Central Park',
          distanceFromStart: 150,
        ),
        'office': BoundLocation(
          templateId: 'office',
          poi: const POI(
            osmId: 3,
            name: 'Business Center',
            lat: 51.5065,
            lon: -0.1270,
            osmTags: {'office': 'yes'},
            storyRoles: [StoryRole.suspectWork],
          ),
          displayName: 'Business Center',
          distanceFromStart: 100,
        ),
        'hidden': BoundLocation(
          templateId: 'hidden',
          poi: const POI(
            osmId: 4,
            name: 'Secret Spot',
            lat: 51.5060,
            lon: -0.1290,
            osmTags: {'amenity': 'place_of_worship'},
            storyRoles: [StoryRole.hidden],
          ),
          displayName: 'Secret Spot',
          distanceFromStart: 200,
        ),
      },
    );
  });

  group('GameService.startCase', () {
    test('creates initial state with active phase', () {
      final state = gameService.startCase(testCase);

      expect(state.caseId, equals('test_case'));
      expect(state.phase, equals(GamePhase.active));
      expect(state.visitedLocations, isEmpty);
      expect(state.discoveredClues, isEmpty);
      expect(state.visitOrder, isEmpty);
      expect(state.completedAt, isNull);
    });

    test('unlocks first location from optimal path', () {
      final state = gameService.startCase(testCase);

      // 'cafe' is first in optimalPath
      expect(state.unlockedLocations, contains('cafe'));
    });

    test('handles case with no optimal path by using first required location', () {
      final templateNoPath = testCase.template.copyWith(
        solution: const Solution(
          perpetratorId: 'suspect',
          motive: 'Greed',
          method: 'Fraud',
          optimalPath: [],
        ),
      );
      final caseNoPath = testCase.copyWith(template: templateNoPath);

      final state = gameService.startCase(caseNoPath);

      // Should use first required location
      expect(state.unlockedLocations.isNotEmpty, isTrue);
    });

    test('sets startedAt to current time', () {
      final before = DateTime.now();
      final state = gameService.startCase(testCase);
      final after = DateTime.now();

      expect(state.startedAt.isAfter(before.subtract(const Duration(seconds: 1))), isTrue);
      expect(state.startedAt.isBefore(after.add(const Duration(seconds: 1))), isTrue);
    });
  });

  group('GameService.visitLocation', () {
    late GameState initialState;

    setUp(() {
      initialState = gameService.startCase(testCase);
    });

    test('allows visiting unlocked location when in range', () {
      // Player position right at the cafe (within 30m)
      final result = gameService.visitLocation(
        initialState,
        'cafe',
        cafeLocation,
        testCase,
      );

      expect(result, isNotNull);
      expect(result!.visitedLocations, contains('cafe'));
      expect(result.visitOrder, equals(['cafe']));
    });

    test('returns null when location is not unlocked', () {
      // 'hidden' is not unlocked initially
      final result = gameService.visitLocation(
        initialState,
        'hidden',
        const LatLng(51.5060, -0.1290),
        testCase,
      );

      expect(result, isNull);
    });

    test('returns null when player is out of range', () {
      // Player is far from cafe (more than 30m)
      final farPosition = const LatLng(51.5100, -0.1300);
      final result = gameService.visitLocation(
        initialState,
        'cafe',
        farPosition,
        testCase,
      );

      expect(result, isNull);
    });

    test('returns same state when location already visited', () {
      // First visit
      final afterFirst = gameService.visitLocation(
        initialState,
        'cafe',
        cafeLocation,
        testCase,
      )!;

      // Second visit
      final afterSecond = gameService.visitLocation(
        afterFirst,
        'cafe',
        cafeLocation,
        testCase,
      );

      expect(afterSecond, equals(afterFirst));
      expect(afterSecond!.visitOrder.length, equals(1));
    });

    test('returns null for unbound location', () {
      final result = gameService.visitLocation(
        initialState,
        'nonexistent',
        cafeLocation,
        testCase,
      );

      expect(result, isNull);
    });

    test('returns null when game is not active', () {
      final solvedState = initialState.copyWith(phase: GamePhase.solved);

      final result = gameService.visitLocation(
        solvedState,
        'cafe',
        cafeLocation,
        testCase,
      );

      expect(result, isNull);
    });

    test('accumulates visits in order', () {
      // Unlock park first
      var state = initialState.copyWith(
        unlockedLocations: {...initialState.unlockedLocations, 'park'},
      );

      state = gameService.visitLocation(state, 'cafe', cafeLocation, testCase)!;
      state = gameService.visitLocation(state, 'park', parkLocation, testCase)!;

      expect(state.visitOrder, equals(['cafe', 'park']));
      expect(state.visitedLocations, containsAll(['cafe', 'park']));
    });
  });

  group('GameService.canDiscoverClue', () {
    late GameState initialState;

    setUp(() {
      initialState = gameService.startCase(testCase);
    });

    test('returns true for clue with no prerequisites', () {
      final clue = testCase.template.clues.firstWhere((c) => c.id == 'clue_note');

      expect(gameService.canDiscoverClue(initialState, clue), isTrue);
    });

    test('returns false when prerequisites not met', () {
      final clue = testCase.template.clues.firstWhere((c) => c.id == 'clue_photo');

      // clue_photo requires clue_note
      expect(gameService.canDiscoverClue(initialState, clue), isFalse);
    });

    test('returns true when prerequisites are met', () {
      final stateWithPrereq = initialState.copyWith(
        discoveredClues: {'clue_note'},
      );
      final clue = testCase.template.clues.firstWhere((c) => c.id == 'clue_photo');

      expect(gameService.canDiscoverClue(stateWithPrereq, clue), isTrue);
    });

    test('handles multiple prerequisites', () {
      // Create a clue with multiple prereqs for testing
      final clueMultiPrereq = const Clue(
        id: 'multi_prereq',
        type: ClueType.observation,
        locationId: 'park',
        title: 'Multi Prereq Clue',
        discoveryText: 'Found it!',
        notebookSummary: 'A clue.',
        prerequisites: ['clue_note', 'clue_footprints'],
      );

      // Missing both
      expect(gameService.canDiscoverClue(initialState, clueMultiPrereq), isFalse);

      // Has one
      final stateWithOne = initialState.copyWith(
        discoveredClues: {'clue_note'},
      );
      expect(gameService.canDiscoverClue(stateWithOne, clueMultiPrereq), isFalse);

      // Has both
      final stateWithBoth = initialState.copyWith(
        discoveredClues: {'clue_note', 'clue_footprints'},
      );
      expect(gameService.canDiscoverClue(stateWithBoth, clueMultiPrereq), isTrue);
    });
  });

  group('GameService.discoverClue', () {
    late GameState initialState;

    setUp(() {
      initialState = gameService.startCase(testCase);
    });

    test('adds clue to discovered clues', () {
      final state = gameService.discoverClue(initialState, 'clue_note', testCase);

      expect(state.discoveredClues, contains('clue_note'));
    });

    test('unlocks revealed locations', () {
      // clue_note reveals 'hidden'
      final state = gameService.discoverClue(initialState, 'clue_note', testCase);

      expect(state.unlockedLocations, contains('hidden'));
    });

    test('returns unchanged state when clue not found', () {
      final state = gameService.discoverClue(initialState, 'nonexistent', testCase);

      expect(state, equals(initialState));
    });

    test('returns unchanged state when prerequisites not met', () {
      // clue_photo requires clue_note
      final state = gameService.discoverClue(initialState, 'clue_photo', testCase);

      expect(state.discoveredClues, isNot(contains('clue_photo')));
    });

    test('allows discovery when prerequisites met', () {
      final stateWithPrereq = initialState.copyWith(
        discoveredClues: {'clue_note'},
      );
      final state = gameService.discoverClue(stateWithPrereq, 'clue_photo', testCase);

      expect(state.discoveredClues, contains('clue_photo'));
    });

    test('does not add duplicate clue', () {
      final stateWithClue = initialState.copyWith(
        discoveredClues: {'clue_note'},
      );
      final state = gameService.discoverClue(stateWithClue, 'clue_note', testCase);

      expect(state.discoveredClues.length, equals(1));
    });

    test('preserves existing unlocked locations', () {
      final stateWithLocations = initialState.copyWith(
        unlockedLocations: {'cafe', 'park'},
      );
      final state = gameService.discoverClue(stateWithLocations, 'clue_note', testCase);

      expect(state.unlockedLocations, containsAll(['cafe', 'park', 'hidden']));
    });
  });

  group('GameService.getAvailableClues', () {
    late GameState initialState;

    setUp(() {
      initialState = gameService.startCase(testCase);
    });

    test('returns clues at location with met prerequisites', () {
      final clues = gameService.getAvailableClues(initialState, 'cafe', testCase);

      expect(clues.length, equals(1));
      expect(clues.first.id, equals('clue_note'));
    });

    test('excludes clues with unmet prerequisites', () {
      final clues = gameService.getAvailableClues(initialState, 'cafe', testCase);

      // clue_photo requires clue_note
      expect(clues.any((c) => c.id == 'clue_photo'), isFalse);
    });

    test('includes clues when prerequisites met', () {
      final stateWithPrereq = initialState.copyWith(
        discoveredClues: {'clue_note'},
      );
      final clues = gameService.getAvailableClues(stateWithPrereq, 'cafe', testCase);

      expect(clues.any((c) => c.id == 'clue_photo'), isTrue);
    });

    test('excludes already discovered clues', () {
      final stateWithClue = initialState.copyWith(
        discoveredClues: {'clue_note'},
      );
      final clues = gameService.getAvailableClues(stateWithClue, 'cafe', testCase);

      expect(clues.any((c) => c.id == 'clue_note'), isFalse);
    });

    test('returns empty list for location with no clues', () {
      final clues = gameService.getAvailableClues(initialState, 'hidden', testCase);

      expect(clues, isEmpty);
    });

    test('returns multiple available clues at same location', () {
      final stateWithPrereq = initialState.copyWith(
        discoveredClues: {'clue_note'},
      );

      // At cafe: clue_photo should be available (prereq met, not discovered)
      final clues = gameService.getAvailableClues(stateWithPrereq, 'cafe', testCase);

      expect(clues.length, equals(1));
      expect(clues.first.id, equals('clue_photo'));
    });
  });

  group('GameService.getCharacterDialogue', () {
    late GameState initialState;

    setUp(() {
      initialState = gameService.startCase(testCase);
    });

    test('returns initial dialogue when no clues discovered', () {
      final barista = testCase.template.characters
          .firstWhere((c) => c.id == 'barista');

      final dialogue = gameService.getCharacterDialogue(initialState, barista);

      expect(dialogue, equals('Hello! What can I get you?'));
    });

    test('includes conditional dialogue for discovered clues', () {
      final stateWithClue = initialState.copyWith(
        discoveredClues: {'clue_note'},
      );
      final barista = testCase.template.characters
          .firstWhere((c) => c.id == 'barista');

      final dialogue = gameService.getCharacterDialogue(stateWithClue, barista);

      expect(dialogue, contains('Hello! What can I get you?'));
      expect(dialogue, contains('Oh, you found that note?'));
    });

    test('includes multiple conditional dialogues', () {
      final stateWithClues = initialState.copyWith(
        discoveredClues: {'clue_note', 'clue_photo'},
      );
      final barista = testCase.template.characters
          .firstWhere((c) => c.id == 'barista');

      final dialogue = gameService.getCharacterDialogue(stateWithClues, barista);

      expect(dialogue, contains('Oh, you found that note?'));
      expect(dialogue, contains('I recognize that photo!'));
    });

    test('returns only initial dialogue for character with no conditional', () {
      final suspect = testCase.template.characters
          .firstWhere((c) => c.id == 'suspect');

      final dialogue = gameService.getCharacterDialogue(initialState, suspect);

      expect(dialogue, equals('What do you want?'));
    });
  });

  group('GameService.submitSolution', () {
    late GameState initialState;

    setUp(() {
      initialState = gameService.startCase(testCase);
    });

    test('returns correct result when perpetrator matches', () {
      final result = gameService.submitSolution(initialState, 'suspect', testCase);

      expect(result.isCorrect, isTrue);
      expect(result.correctPerpetrator, equals('suspect'));
    });

    test('returns incorrect result when perpetrator does not match', () {
      final result = gameService.submitSolution(initialState, 'barista', testCase);

      expect(result.isCorrect, isFalse);
      expect(result.correctPerpetrator, equals('suspect'));
    });

    test('calculates correct visit counts', () {
      final stateWithVisits = initialState.copyWith(
        visitedLocations: {'cafe', 'park'},
      );

      final result = gameService.submitSolution(stateWithVisits, 'suspect', testCase);

      expect(result.playerVisits, equals(2));
      expect(result.optimalVisits, equals(3)); // parVisits
    });

    test('counts essential clues found', () {
      // Essential clues: clue_note, clue_photo, clue_document
      final stateWithClues = initialState.copyWith(
        discoveredClues: {'clue_note', 'clue_photo'},
      );

      final result = gameService.submitSolution(stateWithClues, 'suspect', testCase);

      expect(result.essentialCluesFound, equals(2));
      expect(result.totalEssentialClues, equals(3));
    });

    test('gives base 100 points for correct answer', () {
      // Exactly at par, no essential clues
      final stateAtPar = initialState.copyWith(
        visitedLocations: {'cafe', 'park', 'office'},
      );

      final result = gameService.submitSolution(stateAtPar, 'suspect', testCase);

      // 100 base + 0 efficiency + 0 evidence = 100
      expect(result.score, equals(100));
    });

    test('gives efficiency bonus for under-par visits', () {
      // 1 visit, par is 3, so 2 under par = +20
      final stateUnderPar = initialState.copyWith(
        visitedLocations: {'cafe'},
      );

      final result = gameService.submitSolution(stateUnderPar, 'suspect', testCase);

      // 100 base + 20 efficiency + 0 evidence = 120
      expect(result.score, equals(120));
    });

    test('gives efficiency penalty for over-par visits', () {
      // 5 visits, par is 3, so 2 over par = -10
      final stateOverPar = initialState.copyWith(
        visitedLocations: {'cafe', 'park', 'office', 'hidden', 'extra'},
      );

      final result = gameService.submitSolution(stateOverPar, 'suspect', testCase);

      // 100 base - 10 penalty + 0 evidence = 90
      expect(result.score, equals(90));
    });

    test('gives evidence bonus for essential clues', () {
      final stateWithAllEssential = initialState.copyWith(
        visitedLocations: {'cafe', 'park', 'office'},
        discoveredClues: {'clue_note', 'clue_photo', 'clue_document'},
      );

      final result = gameService.submitSolution(
          stateWithAllEssential, 'suspect', testCase);

      // 100 base + 0 efficiency + 15 evidence (3 * 5) = 115
      expect(result.score, equals(115));
    });

    test('gives zero score for incorrect with many penalties', () {
      // Wrong answer (0 points) + way over par
      final badState = initialState.copyWith(
        visitedLocations: Set.from(List.generate(30, (i) => 'loc_$i')),
      );

      final result = gameService.submitSolution(badState, 'barista', testCase);

      // Wrong (0 base) + heavy penalty would be negative, clamped to 0
      expect(result.score, equals(0));
    });

    test('minimum score is 0', () {
      // Wrong answer + tons of visits = negative before clamping
      final terribleState = initialState.copyWith(
        visitedLocations: Set.from(List.generate(50, (i) => 'loc_$i')),
      );

      final result = gameService.submitSolution(terribleState, 'barista', testCase);

      expect(result.score, equals(0));
    });

    test('combines all scoring factors correctly', () {
      // Correct + 2 under par + 2 essential clues found
      final goodState = initialState.copyWith(
        visitedLocations: {'cafe'}, // 1 visit, par 3 = 2 under
        discoveredClues: {'clue_note', 'clue_document'}, // 2 essential
      );

      final result = gameService.submitSolution(goodState, 'suspect', testCase);

      // 100 base + 20 efficiency (2*10) + 10 evidence (2*5) = 130
      expect(result.score, equals(130));
    });
  });

  group('GameService.getDiscoveredCluesAtLocation', () {
    late GameState initialState;

    setUp(() {
      initialState = gameService.startCase(testCase);
    });

    test('returns discovered clues at specified location', () {
      final stateWithClues = initialState.copyWith(
        discoveredClues: {'clue_note', 'clue_photo'},
      );

      final clues = gameService.getDiscoveredCluesAtLocation(
          stateWithClues, 'cafe', testCase);

      expect(clues.length, equals(2));
      expect(clues.map((c) => c.id), containsAll(['clue_note', 'clue_photo']));
    });

    test('returns empty list for location with no discovered clues', () {
      final clues = gameService.getDiscoveredCluesAtLocation(
          initialState, 'cafe', testCase);

      expect(clues, isEmpty);
    });

    test('only returns clues at specified location', () {
      final stateWithClues = initialState.copyWith(
        discoveredClues: {'clue_note', 'clue_footprints'},
      );

      final cafeClues = gameService.getDiscoveredCluesAtLocation(
          stateWithClues, 'cafe', testCase);
      final parkClues = gameService.getDiscoveredCluesAtLocation(
          stateWithClues, 'park', testCase);

      expect(cafeClues.length, equals(1));
      expect(cafeClues.first.id, equals('clue_note'));
      expect(parkClues.length, equals(1));
      expect(parkClues.first.id, equals('clue_footprints'));
    });
  });

  group('GameService.getCharactersAtLocation', () {
    test('returns characters at specified location', () {
      final characters = gameService.getCharactersAtLocation('cafe', testCase);

      expect(characters.length, equals(1));
      expect(characters.first.id, equals('barista'));
    });

    test('returns empty list for location with no characters', () {
      final characters = gameService.getCharactersAtLocation('park', testCase);

      expect(characters, isEmpty);
    });

    test('returns multiple characters at same location', () {
      // Create a case with multiple characters at one location
      final multiCharTemplate = testCase.template.copyWith(
        characters: const [
          Character(
            id: 'char1',
            name: 'Alice',
            role: 'Barista',
            locationId: 'cafe',
            description: 'Works mornings',
            initialDialogue: 'Hi!',
          ),
          Character(
            id: 'char2',
            name: 'Bob',
            role: 'Regular',
            locationId: 'cafe',
            description: 'Always here',
            initialDialogue: 'Hello!',
          ),
        ],
      );
      final multiCharCase = testCase.copyWith(template: multiCharTemplate);

      final characters = gameService.getCharactersAtLocation('cafe', multiCharCase);

      expect(characters.length, equals(2));
    });
  });

  group('GameService.hasFoundAllEssentialClues', () {
    late GameState initialState;

    setUp(() {
      initialState = gameService.startCase(testCase);
    });

    test('returns false when no essential clues found', () {
      expect(gameService.hasFoundAllEssentialClues(initialState, testCase), isFalse);
    });

    test('returns false when some essential clues found', () {
      final stateWithSome = initialState.copyWith(
        discoveredClues: {'clue_note', 'clue_photo'},
      );

      expect(gameService.hasFoundAllEssentialClues(stateWithSome, testCase), isFalse);
    });

    test('returns true when all essential clues found', () {
      // Essential: clue_note, clue_photo, clue_document
      final stateWithAll = initialState.copyWith(
        discoveredClues: {'clue_note', 'clue_photo', 'clue_document', 'clue_footprints'},
      );

      expect(gameService.hasFoundAllEssentialClues(stateWithAll, testCase), isTrue);
    });
  });

  group('GameService.completeGame', () {
    late GameState initialState;

    setUp(() {
      initialState = gameService.startCase(testCase);
    });

    test('sets phase to solved', () {
      final completedState = gameService.completeGame(initialState);

      expect(completedState.phase, equals(GamePhase.solved));
    });

    test('sets completedAt timestamp', () {
      final before = DateTime.now();
      final completedState = gameService.completeGame(initialState);
      final after = DateTime.now();

      expect(completedState.completedAt, isNotNull);
      expect(
        completedState.completedAt!.isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(
        completedState.completedAt!.isBefore(after.add(const Duration(seconds: 1))),
        isTrue,
      );
    });

    test('preserves other state', () {
      final stateWithProgress = initialState.copyWith(
        visitedLocations: {'cafe', 'park'},
        discoveredClues: {'clue_note'},
      );

      final completedState = gameService.completeGame(stateWithProgress);

      expect(completedState.visitedLocations, equals({'cafe', 'park'}));
      expect(completedState.discoveredClues, equals({'clue_note'}));
    });
  });

  group('SolutionResult', () {
    test('equality works correctly', () {
      const result1 = SolutionResult(
        isCorrect: true,
        correctPerpetrator: 'suspect',
        playerVisits: 3,
        optimalVisits: 3,
        score: 100,
        essentialCluesFound: 2,
        totalEssentialClues: 3,
      );

      const result2 = SolutionResult(
        isCorrect: true,
        correctPerpetrator: 'suspect',
        playerVisits: 3,
        optimalVisits: 3,
        score: 100,
        essentialCluesFound: 2,
        totalEssentialClues: 3,
      );

      expect(result1, equals(result2));
    });

    test('toString provides readable output', () {
      const result = SolutionResult(
        isCorrect: true,
        correctPerpetrator: 'suspect',
        playerVisits: 3,
        optimalVisits: 3,
        score: 100,
        essentialCluesFound: 2,
        totalEssentialClues: 3,
      );

      final str = result.toString();

      expect(str, contains('isCorrect: true'));
      expect(str, contains('score: 100'));
    });
  });
}
