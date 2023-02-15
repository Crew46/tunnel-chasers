Player format reference:

| Property name | Type   | Starting Values    | Notes                                                                                          |
|---------------|--------|--------------------|------------------------------------------------------------------------------------------------|
| sprite        |        | char-dependent     | Sprite for graphical purposes                                                                  |
| speed         | Number | char-dependent     | Determines speed in sneak/running levels.                                                      |
| lives         | Number | 3                  | -1 on each death. Determines if the player can "continue" .                                    |
| building      | String | "machung_building" | snake case version of the name of the building the player is currently in                      |
| progression   | Table  | {}                 | String to boolean table of important progressions aspects ("played_tutorial"=true for example) |
| eloquence     | Number | char-dependent     | Number of choices given to the player during dialogue                                          |
| charisma      | Number | char-dependent     | Increases effectiveness of discussion responses. Decreases risk.                               |
| adrenaline    | Number | char-dependent     | Increases speed on running levels                                                              |
|               |        |                    |                                                                                                |
