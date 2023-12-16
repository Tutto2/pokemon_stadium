curr_dir = File.dirname(__FILE__)
moves_path = File.join(curr_dir, '..', 'moves')
file_paths = Dir.glob(File.join(moves_path, '*.rb'))

require_relative "../pokemon/pokemon"
file_paths.each do |file_path|
  require_relative file_path
end

class Pokedex < Pokemon
  def self.catch(name)
    case name
    when "Pikachu"
      Pokemon.new( name: "Pikachu",
                  types: [Types::ELECTRIC],
                  stats: [Stats.new(name: :hp, base_value: 35 ),
                          Stats.new(name: :atk, base_value: 55 ),
                          Stats.new(name: :def, base_value: 40 ),
                          Stats.new(name: :sp_atk, base_value: 50 ),
                          Stats.new(name: :sp_def, base_value: 50 ),
                          Stats.new(name: :spd, base_value: 90 )
                        ],
                  weight: 6,
                  attacks: [  VoltTackleMove.learn,
                              ZapCannonMove.learn,
                              ThunderWaveMove.learn,
                              AgilityMove.learn
                          ]
                  )
    when "Squirtle"
      Pokemon.new( name: "Squirtle",
                  types: [Types::WATER],
                  stats: [Stats.new(name: :hp, base_value: 44 ),
                          Stats.new(name: :atk, base_value: 48 ),
                          Stats.new(name: :def, base_value: 65 ),
                          Stats.new(name: :sp_atk, base_value: 50 ),
                          Stats.new(name: :sp_def, base_value: 64 ),
                          Stats.new(name: :spd, base_value: 43 )
                        ],
                  weight: 9,
                  attacks: [  HurricaneMove.learn,
                              ShellSmashMove.learn,
                              HydroPumpMove.learn,
                              SwaggerMove.learn
                          ]
                  )
    when "Snorlax"
      Pokemon.new( name: "Snorlax",
                  types: [Types::NORMAL],
                  stats: [Stats.new(name: :hp, base_value: 160 ),
                          Stats.new(name: :atk, base_value: 110 ),
                          Stats.new(name: :def, base_value: 65 ),
                          Stats.new(name: :sp_atk, base_value: 65 ),
                          Stats.new(name: :sp_def, base_value: 110 ),
                          Stats.new(name: :spd, base_value: 30 )
                        ],
                  weight: 460,
                  attacks: [  RestMove.learn,
                              DoubleEdgeMove.learn,
                              CurseMove.learn,
                              SubstituteMove.learn
                          ]
                  )
    when "Milotic"
      Pokemon.new( name: "Milotic",
                  types: [Types::WATER],
                  stats: [Stats.new(name: :hp, base_value: 95 ),
                          Stats.new(name: :atk, base_value: 60 ),
                          Stats.new(name: :def, base_value: 79 ),
                          Stats.new(name: :sp_atk, base_value: 100 ),
                          Stats.new(name: :sp_def, base_value: 125 ),
                          Stats.new(name: :spd, base_value: 81 )
                        ],
                  weight: 162,
                  attacks: [  HydroPumpMove.learn,
                              ScaldMove.learn,
                              ShadowBallMove.learn,
                              RecoverMove.learn
                          ]
                  )
    when "Golem"
      Pokemon.new( name: "Golem",
                  types: [Types::ROCK, Types::GROUND],
                  stats: [Stats.new(name: :hp, base_value: 80 ),
                          Stats.new(name: :atk, base_value: 120 ),
                          Stats.new(name: :def, base_value: 130 ),
                          Stats.new(name: :sp_atk, base_value: 55 ),
                          Stats.new(name: :sp_def, base_value: 65 ),
                          Stats.new(name: :spd, base_value: 45 )
                        ],
                  weight: 300,
                  attacks: [  BodyPressMove.learn,
                              RolloutMove.learn,
                              EarthquakeMove.learn,
                              SwordDanceMove.learn
                          ]
                  )              
    when "Sceptile"
      Pokemon.new( name: "Sceptile",
                  types: [Types::GRASS],
                  stats: [Stats.new(name: :hp, base_value: 70 ),
                          Stats.new(name: :atk, base_value: 85 ),
                          Stats.new(name: :def, base_value: 65 ),
                          Stats.new(name: :sp_atk, base_value: 105 ),
                          Stats.new(name: :sp_def, base_value: 85 ),
                          Stats.new(name: :spd, base_value: 120 )
                        ],
                  weight: 52.2,
                  attacks: [  DracoMeteorMove.learn,
                              GrassKnotMove.learn,
                              LeafStormMove.learn,
                              DoubleTeamMove.learn
                          ]
                  )
    when "Mew"
      Pokemon.new( name: "Mew",
                  types: [Types::PSYCHIC],
                  stats: [Stats.new(name: :hp, base_value: 100 ),
                          Stats.new(name: :atk, base_value: 100 ),
                          Stats.new(name: :def, base_value: 100 ),
                          Stats.new(name: :sp_atk, base_value: 100 ),
                          Stats.new(name: :sp_def, base_value: 100 ),
                          Stats.new(name: :spd, base_value: 100 )
                        ],
                  weight: 4,
                  attacks: [  PsychicMove.learn,
                              SacredFireMove.learn,
                              HypnosisMove.learn,
                              ZapCannonMove.learn
                          ]
                  )             
    when "Dragapult"
      Pokemon.new( name: "Dragapult",
                  types: [Types::DRAGON, Types::GHOST],
                  stats: [Stats.new(name: :hp, base_value: 88 ),
                          Stats.new(name: :atk, base_value: 120 ),
                          Stats.new(name: :def, base_value: 75 ),
                          Stats.new(name: :sp_atk, base_value: 100 ),
                          Stats.new(name: :sp_def, base_value: 75 ),
                          Stats.new(name: :spd, base_value: 142 )
                        ],
                  weight: 50,
                  attacks: [  ShadowClawMove.learn,
                              DragonDartsMove.learn,
                              OutrageMove.learn,
                              DragonDanceMove.learn
                          ]
                  )
    when "Kommo-o"
      Pokemon.new( name: "Kommo-o",
                  types: [Types::DRAGON, Types::FIGHTING],
                  stats: [Stats.new(name: :hp, base_value: 75 ),
                          Stats.new(name: :atk, base_value: 110 ),
                          Stats.new(name: :def, base_value: 125 ),
                          Stats.new(name: :sp_atk, base_value: 100 ),
                          Stats.new(name: :sp_def, base_value: 105 ),
                          Stats.new(name: :spd, base_value: 85 )
                        ],
                  weight: 78.2,
                  attacks: [  CloseCombatMove.learn,
                              ClangingScalesMove.learn,
                              ClangorusSoulMove.learn,
                              FocusPunchMove.learn
                          ]
                  )            
    when "Baxcalibur"
      Pokemon.new( name: "Baxcalibur",
                  types: [Types::DRAGON, Types::ICE],
                  stats: [Stats.new(name: :hp, base_value: 115 ),
                          Stats.new(name: :atk, base_value: 145 ),
                          Stats.new(name: :def, base_value: 92 ),
                          Stats.new(name: :sp_atk, base_value: 75 ),
                          Stats.new(name: :sp_def, base_value: 86 ),
                          Stats.new(name: :spd, base_value: 87 )
                        ],
                  weight: 210,
                  attacks: [  IcicleSpearMove.learn,
                              GlaiveRushMove.learn,
                              IceBallMove.learn,
                              DragonDanceMove.learn
                          ]
                  )            
    when "Ogerpon"
      Pokemon.new( name: "Ogerpon",
                  types: [Types::GRASS, Types::FIRE],
                  stats: [Stats.new(name: :hp, base_value: 80 ),
                          Stats.new(name: :atk, base_value: 120 ),
                          Stats.new(name: :def, base_value: 84 ),
                          Stats.new(name: :sp_atk, base_value: 60 ),
                          Stats.new(name: :sp_def, base_value: 96 ),
                          Stats.new(name: :spd, base_value: 110 )
                        ],
                  weight: 39.8,
                  attacks: [  SeedBombMove.learn,
                              IvyCudgelMove.learn,
                              FlareBlitzMove.learn,
                              SwordDanceMove.learn
                          ]
                  ) 
    when "Tinkaton"
      Pokemon.new( name: "Tinkaton",
                  types: [Types::FAIRY, Types::STEEL],
                  stats: [Stats.new(name: :hp, base_value: 85 ),
                          Stats.new(name: :atk, base_value: 75 ),
                          Stats.new(name: :def, base_value: 77 ),
                          Stats.new(name: :sp_atk, base_value: 70),
                          Stats.new(name: :sp_def, base_value: 105),
                          Stats.new(name: :spd, base_value: 94)
                        ],
                  weight: 112.8,
                  attacks: [  GigatonHammerMove.learn,
                              PlayRoughMove.learn,
                              GyroBallMove.learn,
                              SwordDanceMove.learn
                          ]
                  )
    when "Gengar"
      Pokemon.new( name: "Gengar",
                  types: [Types::GHOST, Types::POISON],
                  stats: [Stats.new(name: :hp, base_value: 60 ),
                          Stats.new(name: :atk, base_value: 65 ),
                          Stats.new(name: :def, base_value: 60 ),
                          Stats.new(name: :sp_atk, base_value: 130),
                          Stats.new(name: :sp_def, base_value: 75),
                          Stats.new(name: :spd, base_value: 110)
                        ],
                  weight: 40.5,
                  attacks: [  ShadowBallMove.learn,
                              SludgeBombMove.learn,
                              ConfuseRayMove.learn,
                              ToxicMove.learn
                          ]
                  )
    when "Ceruledge"
      Pokemon.new( name: "Ceruledge",
                  types: [Types::GHOST, Types::FIRE],
                  stats: [Stats.new(name: :hp, base_value: 75 ),
                          Stats.new(name: :atk, base_value: 125 ),
                          Stats.new(name: :def, base_value: 80 ),
                          Stats.new(name: :sp_atk, base_value: 60 ),
                          Stats.new(name: :sp_def, base_value: 100),
                          Stats.new(name: :spd, base_value: 85)
                        ],
                  weight: 62,
                  attacks: [  FlareBlitzMove.learn,
                              ShadowClawMove.learn,
                              SolarBladeMove.learn,
                              SwordDanceMove.learn
                          ]
                  )
    when "Poltchageist"
      Pokemon.new( name: "Poltchageist",
                  types: [Types::GHOST, Types::GRASS],
                  stats: [Stats.new(name: :hp, base_value: 40 ),
                          Stats.new(name: :atk, base_value: 45 ),
                          Stats.new(name: :def, base_value: 45 ),
                          Stats.new(name: :sp_atk, base_value: 74 ),
                          Stats.new(name: :sp_def, base_value: 54),
                          Stats.new(name: :spd, base_value: 50)
                        ],
                  weight: 1.1,
                  attacks: [  LeafStormMove.learn,
                              ShadowBallMove.learn,
                              FoulPlayMove.learn,
                              GrassKnotMove.learn
                          ]
                  )
    when "Gholdengo"
      Pokemon.new( name: "Gholdengo",
                  types: [Types::GHOST, Types::STEEL],
                  stats: [Stats.new(name: :hp, base_value: 87 ),
                          Stats.new(name: :atk, base_value: 60 ),
                          Stats.new(name: :def, base_value: 95 ),
                          Stats.new(name: :sp_atk, base_value: 133 ),
                          Stats.new(name: :sp_def, base_value: 91),
                          Stats.new(name: :spd, base_value: 84)
                        ],
                  weight: 30,
                  attacks: [  MakeItRainMove.learn,
                              GyroBallMove.learn,
                              ShadowBallMove.learn,
                              DoubleTeamMove.learn
                          ]
                  )
    when "Zoroark-hisui"
      Pokemon.new( name: "Zoroark-hisui",
                  types: [Types::GHOST, Types::NORMAL],
                  stats: [Stats.new(name: :hp, base_value: 55 ),
                          Stats.new(name: :atk, base_value: 100 ),
                          Stats.new(name: :def, base_value: 60 ),
                          Stats.new(name: :sp_atk, base_value: 125 ),
                          Stats.new(name: :sp_def, base_value: 60),
                          Stats.new(name: :spd, base_value: 110)
                        ],
                  weight: 73,
                  attacks: [  FoulPlayMove.learn,
                              TriAttackMove.learn,
                              ShadowBallMove.learn,
                              BitterMaliceMove.learn
                          ]
                  )
    when "Dracanfly"
      Pokemon.new( name: "Dracanfly",
                  types: [Types::DRAGON, Types::BUG],
                  stats: [Stats.new(name: :hp, base_value: 75 ),
                          Stats.new(name: :atk, base_value: 105 ),
                          Stats.new(name: :def, base_value: 45 ),
                          Stats.new(name: :sp_atk, base_value: 142 ),
                          Stats.new(name: :sp_def, base_value: 90),
                          Stats.new(name: :spd, base_value: 143)
                        ],
                  weight: 47,
                  attacks: [  ScalePulseMove.learn,
                              DracoMeteorMove.learn,
                              HydroPumpMove.learn,
                              TriAttackMove.learn
                          ]
                  )              
    end
  end
end
