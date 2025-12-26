# Hue & Cry

>A location-based detective game of mystery, movement, and deduction.

## Overview
Hue & Cry is a Flutter-powered, narrative-driven detective game. Players solve mysteries by visiting real-world locations, gathering clues, and piecing together the solution. Each case is authored as an abstract template and dynamically bound to local Points of Interest (POIs) using OpenStreetMap data.

## Gameplay
- Explore your neighborhood to unlock clues and testimonies
- Interrogate suspects and witnesses
- Piece together the solution from evidence
- Play in GPS or Armchair Detective mode

## Authoring New Cases
See [docs/CASE_AUTHORING.md](docs/CASE_AUTHORING.md) for a comprehensive guide on writing new mysteries, including:
- Case structure and binding
- Step-by-step authoring process
- Writing tips and best practices
- Testing checklist
- Example case template

## Development
- Built with Flutter, Riverpod, Dio, Hive, and custom GazetteTypography
- Supports Android, Web, iOS, Windows, macOS, and Linux

## Contributing
Contributions are welcome! Please:
- Follow the GazetteTypography system for all text
- Add/maintain unit tests for all logic
- Review the authoring guide before submitting new cases

## Testing
- Run all unit tests: `flutter test`
- Playtest on Android and Web for best coverage

## License
MIT
