Player format reference:

| Property name | Type   | Starting Values    | Notes                                                                                         |
|---------------|--------|--------------------|-----------------------------------------------------------------------------------------------|
| sprite        | Number | char-dependent     | Sprite for graphical purposes                                                                 |
| speed         | Number | constant           | Determines speed in running levels.                                                           |
| lives         | Number | 3                  | -1 on each death. Determines if the player can "continue" .                                   |
| building      | String | "mechung_building" | snake case version of the name of the building the player is currently in                     |
| ingenuity     | Number | char-dependent     | Number of choices given to the player during dialogue                                         |
| charisma      | Number | char-dependent     | Increases effectiveness of discussion responses. Decreases risk.                              |
| acuity        | Number | char-dependent?    | Increases the amount of time in seconds given to the player during dialogue                   |
| honesty       | Number | 0                  | Your honesty rating. Decreases for lies, increases for truths.                                |
