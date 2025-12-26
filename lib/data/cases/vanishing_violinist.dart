import '../../models/case_template.dart';
import '../../models/character.dart';
import '../../models/clue.dart';
import '../../models/location_requirement.dart';
import '../../models/solution.dart';
import '../../models/story_role.dart';

/// "The Vanishing Violinist" - Demo case for Hue & Cry
///
/// A tale of disappearance, insurance fraud, and matrimonial treachery
/// in the tradition of the finest Victorian mysteries.
///
/// **Synopsis:**
/// The acclaimed violinist Maria Lindgren vanished three days past,
/// following a private engagement at a gentleman's residence. Her
/// husband Erik, a merchant of middling success, has offered a
/// substantial reward for information. But as any seasoned detective
/// knows, the spouse is always the first suspect...
///
/// **The Truth:**
/// Erik Lindgren, drowning in debt from failed speculations, took out
/// a substantial life insurance policy on his wife six months prior.
/// He arranged for Maria to "disappear" after her performance, planning
/// to claim her dead after a suitable interval. Maria, however, had
/// discovered his scheme and fled to safety, leaving behind clues
/// for an astute investigator to uncover.
const vanishingViolinistCase = CaseTemplate(
  id: 'vanishing_violinist',
  title: 'THE VANISHING VIOLINIST',
  subtitle: 'A Most Peculiar Disappearance Confounds the Authorities',
  briefing: '''
═══════════════════════════════════════════════════════════════════════════

                    ❧ EXTRAORDINARY DISAPPEARANCE ❧
                        
Three days past, the acclaimed violinist MARIA LINDGREN was last seen 
departing a private engagement at the residence of Lord Ashworth. The 
celebrated musician, known throughout the city for her haunting 
performances of Paganini's Caprices, has vanished without trace.

Her husband, Mr. ERIK LINDGREN, a merchant of respectable standing, has 
posted a reward of FIFTY POUNDS for information leading to her safe 
return. "My beloved wife would never abandon her music," Mr. Lindgren 
stated to this correspondent, his voice thick with apparent grief.

The constabulary report no signs of foul play at the scene, yet the 
circumstances remain passing strange. Mrs. Lindgren's prized Stradivarius 
violin was found abandoned in the carriage she had engaged for the 
evening—an instrument she was known never to let leave her sight.

INVESTIGATORS ARE ENCOURAGED to make enquiries at establishments 
frequented by the missing woman, and to interview those who knew 
her habits most intimately.

The game is afoot!

═══════════════════════════════════════════════════════════════════════════
''',
  difficulty: 2,
  estimatedMinutes: 45,
  parVisits: 4,
  locations: {
    // ═══════════════════════════════════════════════════════════════════════
    // REQUIRED LOCATIONS (4)
    // ═══════════════════════════════════════════════════════════════════════

    'cafe_practice': LocationRequirement(
      id: 'cafe_practice',
      role: StoryRole.information,
      preferredTags: ['amenity=cafe', 'amenity=restaurant'],
      required: true,
      descriptionTemplate: 'a quiet establishment where artists gather',
    ),

    'orchestra_hall': LocationRequirement(
      id: 'orchestra_hall',
      role: StoryRole.suspectWork,
      preferredTags: ['amenity=theatre', 'amenity=arts_centre'],
      fallbackRole: StoryRole.atmosphere,
      required: true,
      descriptionTemplate: 'the grand hall where the orchestra rehearses',
    ),

    'husband_office': LocationRequirement(
      id: 'husband_office',
      role: StoryRole.suspectWork,
      preferredTags: ['office=company', 'office=estate_agent', 'shop=trade'],
      required: true,
      descriptionTemplate: "the husband's place of business",
    ),

    'park_meeting': LocationRequirement(
      id: 'park_meeting',
      role: StoryRole.hidden,
      preferredTags: ['leisure=park', 'leisure=garden'],
      fallbackRole: StoryRole.crimeScene,
      required: true,
      descriptionTemplate: 'a secluded spot away from prying eyes',
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // OPTIONAL LOCATIONS (3)
    // ═══════════════════════════════════════════════════════════════════════

    'police_station': LocationRequirement(
      id: 'police_station',
      role: StoryRole.authority,
      preferredTags: ['amenity=police', 'amenity=townhall'],
      fallbackRole: StoryRole.information,
      required: false,
      descriptionTemplate: 'the local constabulary offices',
    ),

    'rival_apartment': LocationRequirement(
      id: 'rival_apartment',
      role: StoryRole.witness,
      preferredTags: ['building=apartments', 'building=residential'],
      fallbackRole: StoryRole.atmosphere,
      required: false,
      descriptionTemplate: 'lodgings of dubious reputation',
    ),

    'antique_shop': LocationRequirement(
      id: 'antique_shop',
      role: StoryRole.atmosphere,
      preferredTags: ['shop=antiques', 'shop=pawnbroker'],
      required: false,
      descriptionTemplate: 'a dusty emporium of curiosities',
    ),
  },
  characters: [
    // ═══════════════════════════════════════════════════════════════════════
    // JAN KOWALSKI - The Observant Barista
    // ═══════════════════════════════════════════════════════════════════════
    Character(
      id: 'jan_barista',
      name: 'Jan Kowalski',
      role: 'Proprietor',
      locationId: 'cafe_practice',
      description: '''
A stout fellow of Polish extraction, with a magnificent mustache 
and an apron perpetually stained with coffee. Jan has operated 
this establishment for fifteen years and knows every regular 
patron's habits with uncanny precision.
''',
      initialDialogue: '''
"Ah, you ask about Mrs. Lindgren! Such a tragedy, such a tragedy."

Jan polishes a cup with practiced efficiency, his eyes growing distant.

"Every morning, nine o'clock sharp, she would take her usual table 
by the window. Always ordered a schwarzer kaffee—black coffee, 
no sugar. Said it kept her fingers nimble for practice."

He leans closer, lowering his voice conspiratorially.

"But these past weeks? Something was troubling her. I could see it 
in her eyes. She was distracted, always looking at the door as if 
expecting someone. And there were letters—she would read them and 
grow pale as a ghost."

"If you want to know her schedule, I kept it written down. She 
asked me to, in case anyone came looking for her..."
''',
      conditionalDialogue: {
        'clue_schedule': '''
"You found the schedule, yes? Good, good."

Jan's expression darkens.

"There is something else I should tell you. Three days before she 
vanished, I heard them arguing—Mrs. Lindgren and her husband. 
Right here, at that very table."

He gestures to a corner booth.

"Mr. Lindgren, he was shouting about money. About debts. I heard 
him say 'the policy will solve everything.' She was crying, 
asking him what he meant. Then he grabbed her arm—not gentle, 
you understand—and they left."

"I should have said something to the police, but..." He shrugs 
helplessly. "Who listens to a coffee man?"
''',
        'clue_park_witness': '''
"You spoke to the flower seller? Then you know she was alive 
after everyone thought she vanished!"

Jan slaps the counter triumphantly.

"I knew something was wrong. The husband, he came here the day 
after she 'disappeared,' asking if she had said anything to me. 
His eyes..." Jan shudders. "Cold. Like a dead fish. Not the eyes 
of a worried husband."
''',
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // HENRIK BERG - The Distinguished Conductor
    // ═══════════════════════════════════════════════════════════════════════
    Character(
      id: 'henrik_conductor',
      name: 'Henrik Berg',
      role: 'Principal Conductor',
      locationId: 'orchestra_hall',
      description: '''
A tall, imperious gentleman with silver hair swept back from a 
high forehead. Maestro Berg carries himself with the confidence 
of a man who has conducted before crowned heads of Europe. His 
hands, when not holding a baton, move constantly as if directing 
invisible musicians.
''',
      initialDialogue: '''
"Mrs. Lindgren's disappearance is a catastrophe—for art, you 
understand. Her technique was extraordinary. Irreplaceable."

The Maestro paces before the empty orchestra pit, his footsteps 
echoing in the cavernous hall.

"She joined our company three seasons past. From the first 
rehearsal, I knew she was destined for greatness. Such passion! 
Such precision!"

He pauses, turning to face you with penetrating grey eyes.

"As for her personal life, I make it a policy not to involve 
myself in such matters. Musicians are temperamental creatures. 
Drama follows them like shadow follows light."

"Though I will say this—she seemed troubled of late. Distracted 
during rehearsals. Most unlike her."
''',
      conditionalDialogue: {
        'clue_argument': '''
The Maestro's composure cracks slightly.

"Arguments with her husband? I am not surprised. The man is 
a philistine who understood nothing of her art."

He lowers his voice to a theatrical whisper.

"Between us, she confided certain... concerns. About their 
finances. About policies and documents she had discovered. 
I urged her to speak with the authorities, but she was 
frightened of him."

"She said, 'Henrik, if anything happens to me, look to Erik.' 
I thought it mere artistic dramatics at the time..."
''',
        'clue_insurance': '''
"Insurance fraud? Mon Dieu!"

The Maestro sinks into a velvet seat, suddenly looking his age.

"It makes terrible sense now. The arguments. Her fear. The 
way he would come to rehearsals, watching her like a hawk 
watches a mouse."

"She was planning to leave him, you know. She told me she had 
found somewhere safe to go, somewhere he would never find her. 
Perhaps... perhaps she succeeded?"
''',
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // ERIK LINDGREN - The Guilty Husband
    // ═══════════════════════════════════════════════════════════════════════
    Character(
      id: 'erik_husband',
      name: 'Erik Lindgren',
      role: 'Import Merchant',
      locationId: 'husband_office',
      description: '''
A man of perhaps forty years, with thinning hair and the soft 
hands of one who has never done physical labor. Erik Lindgren 
wears expensive clothes that hang poorly on his frame, as if 
purchased in more prosperous times. His smile never quite 
reaches his eyes.
''',
      initialDialogue: '''
"Another investigator? The police have already questioned me 
thoroughly, I assure you."

Erik Lindgren rises from behind a desk cluttered with papers, 
his handshake clammy and brief.

"My dear Maria was the light of my life. We had seventeen 
years of perfect happiness together. Perfect."

His eyes dart to a framed photograph on his desk—a beautiful 
woman with dark hair and intelligent eyes, holding a violin.

"I have offered a substantial reward for her return. Fifty 
pounds! What more can a devoted husband do?"

"The police believe she was abducted for ransom, but no 
demands have come. It is... most distressing."
''',
      conditionalDialogue: {
        'clue_insurance': '''
Erik's face goes pale, then flushes an ugly red.

"Where did you get that information? That is private! 
Confidential business!"

He struggles to compose himself.

"The policy was... a prudent measure. My wife's hands were 
her livelihood. Any wise husband would insure against 
accident or illness. There is nothing sinister about it!"

"I demand you leave my office immediately. I shall be 
speaking with my solicitors about this harassment!"
''',
        'clue_park_witness': '''
"ALIVE? That is preposterous! Who told you such lies?"

Erik's composure shatters completely. He grips the edge of 
his desk, knuckles white.

"The flower seller is mistaken. Confused. My wife vanished 
three days ago—that is the official record! I have 
witnesses who saw her enter that carriage and never emerge!"

"You... you are trying to deny me my rightful compensation! 
This is slander! I will see you ruined for this!"

He is practically frothing now, all pretense of grief 
abandoned.
''',
        'clue_argument': '''
"Jan Kowalski is a foreign liar who should mind his own 
business!"

Erik slams his fist on the desk.

"My wife and I had... minor disagreements. What married 
couple does not? But to suggest I would harm her is 
outrageous! I loved her!"

"The debts are temporary setbacks. My shipping investments 
will pay off any day now. Any day..."

His voice trails off, and for a moment you see genuine 
desperation in his eyes.
''',
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // ANNA MORAVEC - The Supposed Rival (Red Herring)
    // ═══════════════════════════════════════════════════════════════════════
    Character(
      id: 'anna_rival',
      name: 'Anna Moravec',
      role: 'Second Violinist',
      locationId: 'rival_apartment',
      description: '''
A thin, nervous woman with ink-stained fingers and an 
unfortunate overbite. Anna Moravec lives in modest lodgings 
that speak to a musician's uncertain income. She startles 
easily and wrings her hands constantly as she speaks.
''',
      initialDialogue: '''
"You think I had something to do with Maria's disappearance? 
That is absurd! Yes, we were rivals—of course we were rivals! 
She had the first chair, and I had worked years longer!"

Anna paces her cramped sitting room, nearly tripping over 
stacks of sheet music.

"But jealousy is not murder! I am a musician, not a 
criminal!"

She pauses, clutching a handkerchief.

"I will admit, I was not... kind to her. I spread rumors 
about her technique. Petty things. But I never wished 
her harm."

"If you want a suspect, look to that husband of hers. 
The way he looked at her sometimes... like she was 
property to be sold."
''',
      conditionalDialogue: {
        'clue_schedule': '''
"Her schedule? Yes, I knew her routine. Everyone in the 
orchestra did. She was insufferably predictable."

Anna's lips twist in a bitter smile.

"Coffee at nine, practice from ten to one, rehearsal at 
three. Like clockwork. The only variation was those 
mysterious walks in the park."

"She thought no one noticed, but I saw her once, meeting 
a man near the old fountain. Not her husband—someone 
else. A lawyer, perhaps? He carried a briefcase."
''',
        'clue_park_witness': '''
"ALIVE? Oh, thank heavens!"

Anna bursts into tears—genuine ones, it seems.

"I have not slept since she vanished. The guilt of my 
jealousy was eating me alive! To think I might never 
have apologized for my pettiness..."

She blows her nose loudly.

"I always knew she was too clever to let that dreadful 
husband of hers have the last word. If anyone could 
escape and start anew, it would be Maria."
''',
      },
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // SERGEANT MORRISON - The Weary Policeman
    // ═══════════════════════════════════════════════════════════════════════
    Character(
      id: 'sergeant_morrison',
      name: 'Sergeant William Morrison',
      role: 'Police Sergeant',
      locationId: 'police_station',
      description: '''
A heavyset man with impressive mutton-chop whiskers and the 
weathered face of one who has seen too much of human nature. 
Sergeant Morrison moves with the deliberate pace of a veteran 
officer who knows that rushing rarely helps.
''',
      initialDialogue: '''
"The Lindgren case? Aye, a peculiar business indeed."

The Sergeant shuffles through papers on his cluttered desk.

"Woman vanishes after a society engagement, leaves behind 
her precious violin. No ransom note, no witnesses to any 
struggle. The husband seems appropriately distraught."

He gives you a knowing look.

"Though between us, something about his story doesn't sit 
right. Too smooth, if you take my meaning. Rehearsed."

"Unfortunately, without evidence of foul play, there's 
little we can do officially. But if you were to find 
something... well, I'd be most interested to hear of it."
''',
      conditionalDialogue: {
        'clue_argument': '''
"An argument about money? Now that is interesting..."

The Sergeant pulls out a fresh notebook.

"We had reports of Mr. Lindgren's financial difficulties 
some months back. Unpaid bills, creditors making threats. 
He claimed it was all sorted, but..."

He taps his nose meaningfully.

"Men in debt do desperate things. I've seen it a hundred 
times. Let me check our records for anything on the 
insurance angle."
''',
        'clue_schedule': '''
"A secret meeting place? The park, you say?"

Sergeant Morrison heaves himself up from his chair.

"That would explain the flower seller's report. Old Mrs. 
Chen, down by the fountain—she mentioned seeing a woman 
matching Mrs. Lindgren's description, day after she 
supposedly vanished."

"I dismissed it as fancy, but if she had a regular 
meeting spot there... Worth another look, I'd say."
''',
      },
    ),
  ],
  clues: [
    // ═══════════════════════════════════════════════════════════════════════
    // CLUE 1: Maria's Schedule (Starting Point)
    // ═══════════════════════════════════════════════════════════════════════
    Clue(
      id: 'clue_schedule',
      type: ClueType.physical,
      locationId: 'cafe_practice',
      title: "Maria's Practice Schedule",
      discoveryText: '''
════════════════════════════════════════════════════════════════════════════
                        ❧ EVIDENCE DISCOVERED ❧
════════════════════════════════════════════════════════════════════════════

Hidden beneath the sugar bowl at Maria's usual table, you discover 
a folded piece of paper in feminine handwriting:

    ╭─────────────────────────────────────────────────╮
    │  IF YOU ARE READING THIS, SOMETHING HAS GONE    │
    │  WRONG. FIND ME AT THE USUAL PLACE - BY THE     │
    │  OLD FOUNTAIN IN THE PARK. COME ALONE.          │
    │                                                 │
    │  P.S. - Jan knows more than he has said.        │
    │         Ask him about the argument.             │
    │                                        - M.L.   │
    ╰─────────────────────────────────────────────────╯

The paper is dated two days before Maria's disappearance.

════════════════════════════════════════════════════════════════════════════
''',
      notebookSummary:
          'Found a note from Maria hidden at the café, mentioning a meeting place by "the old fountain in the park" and urging to ask Jan about "the argument."',
      prerequisites: [],
      reveals: ['park_meeting'],
      isEssential: true,
      isRedHerring: false,
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // CLUE 2: The Argument (Requires Schedule)
    // ═══════════════════════════════════════════════════════════════════════
    Clue(
      id: 'clue_argument',
      type: ClueType.testimony,
      locationId: 'cafe_practice',
      characterId: 'jan_barista',
      title: 'Testimony: The Argument',
      discoveryText: '''
════════════════════════════════════════════════════════════════════════════
                        ❧ TESTIMONY RECORDED ❧
════════════════════════════════════════════════════════════════════════════

Jan Kowalski recounts a heated argument between Maria and Erik 
Lindgren, witnessed three days before her disappearance:

KEY POINTS:
  • Erik was shouting about debts and financial troubles
  • He mentioned "the policy will solve everything"
  • He physically grabbed Maria's arm
  • She was crying and asked "what do you mean?"

This testimony suggests Erik may have been planning something 
related to an insurance policy.

════════════════════════════════════════════════════════════════════════════
''',
      notebookSummary:
          'Jan witnessed Erik and Maria arguing about debts. Erik said "the policy will solve everything" and grabbed her arm roughly.',
      prerequisites: ['clue_schedule'],
      reveals: ['police_station'],
      isEssential: true,
      isRedHerring: false,
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // CLUE 3: Insurance Records (Requires Argument)
    // ═══════════════════════════════════════════════════════════════════════
    Clue(
      id: 'clue_insurance',
      type: ClueType.record,
      locationId: 'police_station',
      characterId: 'sergeant_morrison',
      title: 'Insurance Policy Records',
      discoveryText: '''
════════════════════════════════════════════════════════════════════════════
                        ❧ OFFICIAL RECORD ❧
════════════════════════════════════════════════════════════════════════════

Sergeant Morrison produces a document from the records office:

    ╭─────────────────────────────────────────────────╮
    │     METROPOLITAN INSURANCE COMPANY              │
    │     POLICY #4471-B                              │
    │                                                 │
    │     INSURED: Maria Lindgren                     │
    │     BENEFICIARY: Erik Lindgren (husband)        │
    │     COVERAGE: Death or Disappearance            │
    │     AMOUNT: £5,000                              │
    │     DATE ISSUED: 6 months prior                 │
    │                                                 │
    │     NOTE: Claim filed by beneficiary            │
    │           on day of disappearance               │
    ╰─────────────────────────────────────────────────╯

"Filing a claim on the same day," the Sergeant mutters. 
"Most devoted husbands wait at least a week to give up hope."

════════════════════════════════════════════════════════════════════════════
''',
      notebookSummary:
          'Erik took out a £5,000 insurance policy on Maria six months ago and filed a claim on the SAME DAY she vanished. Highly suspicious.',
      prerequisites: ['clue_argument'],
      reveals: [],
      isEssential: true,
      isRedHerring: false,
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // CLUE 4: Park Witness (Requires Schedule)
    // ═══════════════════════════════════════════════════════════════════════
    Clue(
      id: 'clue_park_witness',
      type: ClueType.testimony,
      locationId: 'park_meeting',
      title: 'The Flower Seller\'s Account',
      discoveryText: '''
════════════════════════════════════════════════════════════════════════════
                        ❧ WITNESS STATEMENT ❧
════════════════════════════════════════════════════════════════════════════

Near the old fountain, you encounter Mrs. Chen, an elderly flower 
seller who has occupied this spot for decades.

"The violin lady? Oh yes, I see her many times. Beautiful woman, 
always kind to me. Buy flowers for her practice room."

Mrs. Chen's eyes light up with certainty.

"I see her YESTERDAY! Yes, yesterday morning, very early. She 
come to fountain, meet a man in a dark coat. They talk quiet, 
then she give him envelope. He give her papers."

"She look... relieved. Happy even. Then she walk away toward 
the train station. Carrying a small bag."

Mrs. Chen frowns. "But newspapers say she vanish three days 
ago. I know what I see. Yesterday. She is alive."

════════════════════════════════════════════════════════════════════════════
''',
      notebookSummary:
          'Mrs. Chen, the flower seller, SAW MARIA ALIVE yesterday morning at the park fountain! She met a man, exchanged papers, then walked toward the train station. Maria ESCAPED.',
      prerequisites: ['clue_schedule'],
      reveals: [],
      isEssential: true,
      isRedHerring: false,
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // CLUE 5: The Jealous Rival (Red Herring)
    // ═══════════════════════════════════════════════════════════════════════
    Clue(
      id: 'clue_rival_rumor',
      type: ClueType.testimony,
      locationId: 'rival_apartment',
      characterId: 'anna_rival',
      title: 'The Rival\'s Jealousy',
      discoveryText: '''
════════════════════════════════════════════════════════════════════════════
                        ❧ DUBIOUS TESTIMONY ❧
════════════════════════════════════════════════════════════════════════════

Anna Moravec, second violin at the orchestra, speaks at length 
about her rivalry with Maria Lindgren.

"She stole my position! I had seniority—years of seniority! 
But the Maestro only had eyes for her 'superior technique.'"

Anna produces old concert programs, letters of complaint she 
wrote to the orchestra board, even a list of "Maria's flaws."

"I documented everything. Her missed notes, her temperamental 
outbursts, her... her..." Anna dissolves into bitter tears.

While clearly consumed by professional jealousy, Anna seems 
genuinely shocked by Maria's disappearance and bears no signs 
of involvement beyond petty envy.

════════════════════════════════════════════════════════════════════════════
''',
      notebookSummary:
          'Anna Moravec was jealous of Maria, but her rivalry appears purely professional. She seems genuinely relieved to hear Maria may be alive.',
      prerequisites: [],
      reveals: [],
      isEssential: false,
      isRedHerring: true,
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // CLUE 6: Conductor's Insight (Optional)
    // ═══════════════════════════════════════════════════════════════════════
    Clue(
      id: 'clue_conductor_fear',
      type: ClueType.testimony,
      locationId: 'orchestra_hall',
      characterId: 'henrik_conductor',
      title: 'The Maestro\'s Confidence',
      discoveryText: '''
════════════════════════════════════════════════════════════════════════════
                        ❧ PRIVATE CONVERSATION ❧
════════════════════════════════════════════════════════════════════════════

Maestro Henrik Berg shares a confidential exchange he had with 
Maria Lindgren during a recent rehearsal:

"She came to me in tears one evening, after the others had left. 
She said, 'Henrik, I have discovered something terrible about 
Erik. Something that puts my life in danger.'"

The Maestro steeples his fingers.

"I urged her to go to the police, but she was afraid they would 
not believe her. She said she had a plan—a way to escape and 
start fresh somewhere he could never find her."

"I gave her the name of a solicitor I trust, a man who specializes 
in helping women flee dangerous domestic situations. Perhaps 
that is who the flower seller saw her meeting."

════════════════════════════════════════════════════════════════════════════
''',
      notebookSummary:
          'Maestro Berg confirms Maria feared for her life and was planning an escape. He connected her with a solicitor who helps women flee dangerous husbands.',
      prerequisites: [],
      reveals: [],
      isEssential: false,
      isRedHerring: false,
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // CLUE 7: Antique Shop Lead (Atmosphere)
    // ═══════════════════════════════════════════════════════════════════════
    Clue(
      id: 'clue_pawn_ticket',
      type: ClueType.physical,
      locationId: 'antique_shop',
      title: 'The Pawn Ticket',
      discoveryText: '''
════════════════════════════════════════════════════════════════════════════
                        ❧ CURIOUS DISCOVERY ❧
════════════════════════════════════════════════════════════════════════════

The proprietor of the antique shop, a wizened man with spectacles 
thick as bottle-bottoms, peers at you over a display of pocket 
watches.

"Erik Lindgren? Oh yes, he was here. Not a week past."

He produces a ledger, running a gnarled finger down the entries.

"Sold me his wife's jewelry. Said she had given permission to 
liquidate some assets for their 'investments.' A pearl necklace, 
gold earrings, a diamond brooch."

He shakes his head sadly.

"I gave him a fair price—perhaps too fair. Fifty pounds for 
the lot. He seemed... desperate. Kept looking over his shoulder 
as if afraid someone would see him."

════════════════════════════════════════════════════════════════════════════
''',
      notebookSummary:
          'Erik sold Maria\'s jewelry at the antique shop for £50 just before she vanished. Further evidence of his financial desperation.',
      prerequisites: [],
      reveals: [],
      isEssential: false,
      isRedHerring: false,
    ),
  ],
  solution: Solution(
    perpetratorId: 'erik_husband',
    motive: '''
INSURANCE FRAUD & FINANCIAL DESPERATION

Erik Lindgren, drowning in debt from failed shipping investments, 
took out a £5,000 life insurance policy on his wife six months 
before her "disappearance." He planned to stage her death and 
collect the substantial payout.

However, Maria discovered his scheme and, with the help of a 
solicitor recommended by Maestro Berg, orchestrated her own 
escape. She is alive and has fled to safety, leaving behind 
evidence to expose her husband's fraud.
''',
    method: '''
Erik planned to stage Maria's disappearance after her performance 
at Lord Ashworth's residence, making it appear as an abduction. 
He left her violin in the carriage to suggest foul play.

Maria, however, had anticipated his move. She slipped away on 
her own terms, meeting with her solicitor to finalize travel 
documents before boarding a train to parts unknown.
''',
    keyEvidence: [
      'clue_insurance',
      'clue_park_witness',
      'clue_argument',
    ],
    optimalPath: [
      'cafe_practice',
      'park_meeting',
      'police_station',
      'husband_office',
    ],
  ),
);
