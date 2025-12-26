# Hue & Cry Case Authoring Guide

## 1. Overview: Case Structure & Binding

Hue & Cry cases are authored as **abstract templates**. Each case defines:
- A mystery to solve (who, why, how)
- Abstract locations (e.g., "a café", "a park")
- Clues, characters, and dialogue

**At runtime:**
- The app binds each abstract location to a real-world POI (Point of Interest) in the player's neighborhood using OpenStreetMap data.
- Players physically visit these locations to unlock clues and progress.

## 2. Step-by-Step: Creating a New Case

### 1. Start with the Solution
- Decide the perpetrator, their motive, and the method.
- Write the solution block first (see example below).

### 2. Work Backwards: Evidence
- List the key clues that prove the solution ("keyEvidence").
- Decide what information the player must discover to solve the case.

### 3. Design the Clue Dependency Graph
- Map out which clues require others to be found first ("prerequisites").
- Ensure there are logical paths to the solution, with some optional/alternate routes.

### 4. Assign Clues to Abstract Locations
- For each clue, choose a location type (e.g., café, park, office).
- Use location requirements that can be matched to real POIs (see StoryRole enum).

### 5. Create NPCs for Testimony
- Write characters who deliver testimony clues.
- Place them at appropriate locations.
- Give each NPC initial and conditional dialogue.

### 6. Add Red Herrings & Atmosphere
- Include non-essential clues, flavor text, and optional locations to enrich the world.
- Use "isRedHerring" and "atmosphere" roles.

### 7. Balance Required vs Optional Locations
- Mark essential locations as `required: true`.
- Add optional locations for depth and replayability.

### 8. Set Par Visit Count
- Estimate the minimum number of visits needed to solve the case efficiently ("parVisits").

## 3. Writing Tips
- **Keep descriptions location-agnostic:** Avoid naming real places; use templates like "a quiet café where artists gather".
- **Use `{location:id}` interpolation:** Reference locations in text using curly braces (e.g., `{location:park_meeting}`).
- **Engaging, period-appropriate dialogue:** Write in the voice of a 19th-century gazette or penny dreadful.
- **Logical, not obvious:** Make clue connections fair but not too easy.
- **Embrace the Gazette style:** Use dramatic headlines, ornate language, and newspaper conventions throughout.

## 4. Testing Checklist
- [ ] Case validates (no missing or broken references)
- [ ] Binding works in different neighborhoods (try urban & rural)
- [ ] Playtest full case on Android and Web
- [ ] Solution is discoverable but not trivial
- [ ] Test in Armchair Detective mode (no GPS)

## 5. Example Case Template (JSON)

```json
{
  "id": "vanishing_violinist",
  "title": "THE VANISHING VIOLINIST",
  "subtitle": "A Most Peculiar Disappearance Confounds the Authorities",
  "teaser": "Three days past, the acclaimed violinist Maria Lindgren departed a private engagement and has not been seen since. Her prized Stradivarius was discovered abandoned in her carriage—an instrument she was known never to let leave her sight. The circumstances demand investigation.",
  "briefing": "...",
  "difficulty": 2,
  "estimatedMinutes": 45,
  "parVisits": 4,
  "locations": {
    "cafe_practice": {
      "id": "cafe_practice",
      "role": "information",
      "preferredTags": ["amenity=cafe", "amenity=restaurant"],
      "required": true,
      "descriptionTemplate": "a quiet establishment where artists gather"
    },
    // ... more locations ...
  },
  "characters": [
    {
      "id": "jan_barista",
      "name": "Jan Kowalski",
      "role": "Proprietor",
      "locationId": "cafe_practice",
      "description": "A stout fellow ...",
      "initialDialogue": "\"Ah, you ask about Mrs. Lindgren!...\"",
      "conditionalDialogue": {
        "clue_schedule": "...",
        "clue_park_witness": "..."
      }
    }
    // ... more characters ...
  ],
  "clues": [
    {
      "id": "clue_schedule",
      "type": "record",
      "locationId": "cafe_practice",
      "title": "Maria's Schedule",
      "discoveryText": "You find a neatly written schedule ...",
      "notebookSummary": "Maria's daily routine ...",
      "prerequisites": [],
      "reveals": ["park_meeting"],
      "characterId": "jan_barista",
      "isEssential": true,
      "isRedHerring": false
    }
    // ... more clues ...
  ],
  "solution": {
    "perpetratorId": "erik_husband",
    "motive": "INSURANCE FRAUD & FINANCIAL DESPERATION ...",
    "method": "Erik planned to stage Maria's disappearance ...",
    "keyEvidence": ["clue_insurance", "clue_park_witness", "clue_argument"],
    "optimalPath": ["cafe_practice", "park_meeting", "police_station", "husband_office"]
  }
}
```

For more details, see the project README and existing case files.
