/// Categories mapping real POIs to narrative functions in the game.
/// 
/// These roles determine how a real-world location can be used
/// within the mystery narrative.
enum StoryRole {
  /// Parks, alleys, parking areas, waterfronts - where crimes occur
  crimeScene,

  /// Residential areas, cafés, hotels - people who saw something
  witness,

  /// Offices, shops, commercial buildings - where suspects work
  suspectWork,

  /// Cafés, bars, libraries, hairdressers - gossip and intel sources
  information,

  /// Police, hospitals, government buildings - official sources
  authority,

  /// Churches, cemeteries, secluded areas - secret meeting spots
  hidden,

  /// General flavor locations, red herrings
  atmosphere,
}
