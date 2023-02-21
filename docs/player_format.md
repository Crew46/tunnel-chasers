Player format reference:

| Property name | Type   | Starting Values    | Notes                                                                                         |
|---------------|--------|--------------------|-----------------------------------------------------------------------------------------------|
| sprite        | Number | char-dependent     | Sprite for graphical purposes                                                                 |
| speed         | Number | constant           | Determines speed in running levels.                                                           |
| lives         | Number | 3                  | -1 on each death. Determines if the player can "continue" .                                   |
| building      | String | "machung_building" | snake case version of the name of the building the player is currently in                     |
| progression   | Table  | {}                 | String to boolean table of important progression aspects ("played_tutorial"=true for example) |
| ingenuity     | Number | char-dependent     | Number of choices given to the player during dialogue                                         |
| charisma      | Number | char-dependent     | Increases effectiveness of discussion responses. Decreases risk.                              |
| acuity        | Number | char-dependent?    | Increases the amount of time given to the player during dialogue                              |
| honesty       | Number | 0                  | Your honesty rating. Decreases for lies, increases for truths.                                |
