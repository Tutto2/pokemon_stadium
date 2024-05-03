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
      Pokemon.new(
        name: "Pikachu",
        types: [Types::ELECTRIC],
        stats: [
          Stats.new(name: :hp, base_value: 35 ),
          Stats.new(name: :atk, base_value: 55 ),
          Stats.new(name: :def, base_value: 40 ),
          Stats.new(name: :sp_atk, base_value: 50 ),
          Stats.new(name: :sp_def, base_value: 50 ),
          Stats.new(name: :spd, base_value: 90 )
        ],
        gender: :female,
        weight: 6,
        attacks: [
          VoltTackleMove.learn,
          DischargeMove.learn,
          ThunderWaveMove.learn,
          MetronomeMove.learn
        ]
      )
    when "Squirtle"
      Pokemon.new(
        name: "Squirtle",
        types: [Types::WATER],
        stats: [
          Stats.new(name: :hp, base_value: 44 ),
          Stats.new(name: :atk, base_value: 48 ),
          Stats.new(name: :def, base_value: 65 ),
          Stats.new(name: :sp_atk, base_value: 50 ),
          Stats.new(name: :sp_def, base_value: 64 ),
          Stats.new(name: :spd, base_value: 43 )
        ],
        gender: :male,
        weight: 9,
        attacks: [
          OutrageMove.learn,
          HydroPumpMove.learn,
          BlizzardMove.learn,
          ProtectMove.learn
        ]
      )
    when "Jigglypuff"
      Pokemon.new(
        name: "Jigglypuff",
        types: [Types::NORMAL, Types::FAIRY],
        stats: [
          Stats.new(name: :hp, base_value: 115 ),
          Stats.new(name: :atk, base_value: 45 ),
          Stats.new(name: :def, base_value: 15 ),
          Stats.new(name: :sp_atk, base_value: 45 ),
          Stats.new(name: :sp_def, base_value: 25 ),
          Stats.new(name: :spd, base_value: 20 )
        ],
        gender: :female,
        weight: 5.5,
        attacks: [
          HyperVoiceMove.learn,
          DoubleEdgeMove.learn,
          CopycatMove.learn,
          SweetKissMove.learn
        ]
      )
    when "Snorlax"
      Pokemon.new(
        name: "Snorlax",
        types: [Types::NORMAL],
        stats: [
          Stats.new(name: :hp, base_value: 160 ),
          Stats.new(name: :atk, base_value: 110 ),
          Stats.new(name: :def, base_value: 65 ),
          Stats.new(name: :sp_atk, base_value: 65 ),
          Stats.new(name: :sp_def, base_value: 110 ),
          Stats.new(name: :spd, base_value: 30 )
        ],
        gender: :male,
        weight: 460,
        attacks: [
          FacadeMove.learn,
          PsychUpMove.learn,
          CounterMove.learn,
          SuckerPunchMove.learn
        ]
      )
    when "Milotic"
      Pokemon.new(
        name: "Milotic",
        types: [Types::WATER],
        stats: [
          Stats.new(name: :hp, base_value: 95 ),
          Stats.new(name: :atk, base_value: 60 ),
          Stats.new(name: :def, base_value: 79 ),
          Stats.new(name: :sp_atk, base_value: 100 ),
          Stats.new(name: :sp_def, base_value: 125 ),
          Stats.new(name: :spd, base_value: 81 )
          ],
        gender: :female,
        weight: 162,
        attacks: [
          HydroPumpMove.learn,
          ScaldMove.learn,
          MirrorCoatMove.learn,
          RecoverMove.learn
        ]
      )
    when "Golem"
      Pokemon.new(
        name: "Golem",
        types: [Types::ROCK, Types::GROUND],
        stats: [
          Stats.new(name: :hp, base_value: 80 ),
          Stats.new(name: :atk, base_value: 120 ),
          Stats.new(name: :def, base_value: 130 ),
          Stats.new(name: :sp_atk, base_value: 55 ),
          Stats.new(name: :sp_def, base_value: 65 ),
          Stats.new(name: :spd, base_value: 45 )
        ],
        gender: :male,
        weight: 300,
        attacks: [
          EarthquakeMove.learn,
          ExplosionMove.learn,
          RolloutMove.learn,
          DefenseCurlMove.learn
        ]
      )              
    when "Sceptile"
      Pokemon.new(
        name: "Sceptile",
        types: [Types::GRASS],
        stats: [
          Stats.new(name: :hp, base_value: 70 ),
          Stats.new(name: :atk, base_value: 85 ),
          Stats.new(name: :def, base_value: 65 ),
          Stats.new(name: :sp_atk, base_value: 105 ),
          Stats.new(name: :sp_def, base_value: 85 ),
          Stats.new(name: :spd, base_value: 120 )
        ],
        gender: :male,
        weight: 52.2,
        attacks: [
          GigaDrainMove.learn,
          FrenzyPlantMove.learn,
          LeafStormMove.learn,
          SubstituteMove.learn
        ]
      )
    when "Mew"
      Pokemon.new(
        name: "Mew",
        types: [Types::PSYCHIC],
        stats: [
          Stats.new(name: :hp, base_value: 100 ),
          Stats.new(name: :atk, base_value: 100 ),
          Stats.new(name: :def, base_value: 100 ),
          Stats.new(name: :sp_atk, base_value: 100 ),
          Stats.new(name: :sp_def, base_value: 100 ),
          Stats.new(name: :spd, base_value: 100 )
        ],
        weight: 4,
        attacks: [
          SacredFireMove.learn,
          FutureSightMove.learn,
          GrowthMove.learn,
          BatonPassMove.learn
        ]
      )
    when "Ditto"
      Pokemon.new(
        name: "Ditto",
        types: [Types::NORMAL],
        stats: [
          Stats.new(name: :hp, base_value: 48 ),
          Stats.new(name: :atk, base_value: 48 ),
          Stats.new(name: :def, base_value: 48 ),
          Stats.new(name: :sp_atk, base_value: 48 ),
          Stats.new(name: :sp_def, base_value: 48 ),
          Stats.new(name: :spd, base_value: 48 )
        ],
        weight: 4,
        attacks: [
          TransformMove.learn
        ]
      )             
    when "Dragapult"
      Pokemon.new(
        name: "Dragapult",
        types: [Types::DRAGON, Types::GHOST],
        stats: [
          Stats.new(name: :hp, base_value: 88 ),
          Stats.new(name: :atk, base_value: 120 ),
          Stats.new(name: :def, base_value: 75 ),
          Stats.new(name: :sp_atk, base_value: 100 ),
          Stats.new(name: :sp_def, base_value: 75 ),
          Stats.new(name: :spd, base_value: 142 )
        ],
        gender: :male,
        weight: 50,
        attacks: [
          PhantomForceMove.learn,
          DragonDartsMove.learn,
          UTurnMove.learn,
          DragonDanceMove.learn
        ]
      )
    when "Kommo-o"
      Pokemon.new(
        name: "Kommo-o",
        types: [Types::DRAGON, Types::FIGHTING],
        stats: [
          Stats.new(name: :hp, base_value: 75 ),
          Stats.new(name: :atk, base_value: 110 ),
          Stats.new(name: :def, base_value: 125 ),
          Stats.new(name: :sp_atk, base_value: 100 ),
          Stats.new(name: :sp_def, base_value: 105 ),
          Stats.new(name: :spd, base_value: 85 )
        ],
        gender: :male,
        weight: 78.2,
        attacks: [
          CloseCombatMove.learn,
          ClangingScalesMove.learn,
          BoomburstMove.learn,
          ClangorusSoulMove.learn
        ]
        )            
    when "Baxcalibur"
      Pokemon.new(
        name: "Baxcalibur",
        types: [Types::DRAGON, Types::ICE],
        stats: [
          Stats.new(name: :hp, base_value: 115 ),
          Stats.new(name: :atk, base_value: 145 ),
          Stats.new(name: :def, base_value: 92 ),
          Stats.new(name: :sp_atk, base_value: 75 ),
          Stats.new(name: :sp_def, base_value: 86 ),
          Stats.new(name: :spd, base_value: 87 )
        ],
        gender: :female,
        weight: 210,
        attacks: [
          IcicleCrashMove.learn,
          GlaiveRushMove.learn,
          IceShardMove.learn,
          FocusEnergyMove.learn
        ]
      )            
    when "Ogerpon (Fire)"
      Pokemon.new( 
        name: "Ogerpon",
        types: [Types::GRASS, Types::FIRE],
        stats: [
          Stats.new(name: :hp, base_value: 80 ),
          Stats.new(name: :atk, base_value: 120 ),
          Stats.new(name: :def, base_value: 84 ),
          Stats.new(name: :sp_atk, base_value: 60 ),
          Stats.new(name: :sp_def, base_value: 96 ),
          Stats.new(name: :spd, base_value: 110 )
        ],
        gender: :male,
        weight: 39.8,
        attacks: [
          SappySeedMove.learn,
          SpikyShieldMove.learn,
          IvyCudgelMove.learn,
          FlareBlitzMove.learn
        ]
      ) 
    when "Tinkaton"
      Pokemon.new(
        name: "Tinkaton",
        types: [Types::FAIRY, Types::STEEL],
        stats: [
          Stats.new(name: :hp, base_value: 85 ),
          Stats.new(name: :atk, base_value: 75 ),
          Stats.new(name: :def, base_value: 77 ),
          Stats.new(name: :sp_atk, base_value: 70),
          Stats.new(name: :sp_def, base_value: 105),
          Stats.new(name: :spd, base_value: 94)
        ],
        gender: :male,
        weight: 112.8,
        attacks: [
          PlayRoughMove.learn,
          MetronomeMove.learn,
          GigatonHammerMove.learn,
          SwordDanceMove.learn
        ]
      )
    when "Gengar"
      Pokemon.new(
        name: "Gengar",
        types: [Types::GHOST, Types::POISON],
        stats: [
          Stats.new(name: :hp, base_value: 60 ),
          Stats.new(name: :atk, base_value: 65 ),
          Stats.new(name: :def, base_value: 60 ),
          Stats.new(name: :sp_atk, base_value: 130),
          Stats.new(name: :sp_def, base_value: 75),
          Stats.new(name: :spd, base_value: 110)
        ],
        gender: :male,
        weight: 40.5,
        attacks: [
          ShadowBallMove.learn,
          SludgeBombMove.learn,
          ConfuseRayMove.learn,
          SpiteMove.learn
        ]
      )
    when "Ceruledge"
      Pokemon.new(
        name: "Ceruledge",
        types: [Types::GHOST, Types::FIRE],
        stats: [
          Stats.new(name: :hp, base_value: 75 ),
          Stats.new(name: :atk, base_value: 125 ),
          Stats.new(name: :def, base_value: 80 ),
          Stats.new(name: :sp_atk, base_value: 60 ),
          Stats.new(name: :sp_def, base_value: 100),
          Stats.new(name: :spd, base_value: 85)
        ],
        gender: :male,
        weight: 62,
        attacks: [
          ShadowClawMove.learn,
          BitterBladeMove.learn,
          SolarBladeMove.learn,
          ShadowSneakMove.learn
        ]
      )
    when "Poltchageist"
      Pokemon.new(
        name: "Poltchageist",
        types: [Types::GHOST, Types::GRASS],
        stats: [
          Stats.new(name: :hp, base_value: 40 ),
          Stats.new(name: :atk, base_value: 45 ),
          Stats.new(name: :def, base_value: 45 ),
          Stats.new(name: :sp_atk, base_value: 74 ),
          Stats.new(name: :sp_def, base_value: 54),
          Stats.new(name: :spd, base_value: 50)
        ],
        weight: 1.1,
        attacks: [  
          FoulPlayMove.learn,
          PainSplitMove.learn,
          EndureMove.learn,
          CurseMove.learn
        ]
      )
    when "Gholdengo"
      Pokemon.new(
        name: "Gholdengo",
        types: [Types::GHOST, Types::STEEL],
        stats: [
          Stats.new(name: :hp, base_value: 87 ),
          Stats.new(name: :atk, base_value: 60 ),
          Stats.new(name: :def, base_value: 95 ),
          Stats.new(name: :sp_atk, base_value: 133 ),
          Stats.new(name: :sp_def, base_value: 91),
          Stats.new(name: :spd, base_value: 84)
        ],
        gender: :male,
        weight: 30,
        attacks: [
          PsyshockMove.learn,
          ShadowBallMove.learn,
          MakeItRainMove.learn,
          MetalSoundMove.learn
        ]
      )
    when "Zoroark-hisui"
      Pokemon.new(
        name: "Zoroark-hisui",
        types: [Types::GHOST, Types::NORMAL],
        stats: [
          Stats.new(name: :hp, base_value: 55 ),
          Stats.new(name: :atk, base_value: 100 ),
          Stats.new(name: :def, base_value: 60 ),
          Stats.new(name: :sp_atk, base_value: 125 ),
          Stats.new(name: :sp_def, base_value: 60),
          Stats.new(name: :spd, base_value: 110)
        ],
        gender: :male,
        weight: 73,
        attacks: [
          SuckerPunchMove.learn,
          BitterMaliceMove.learn,
          HexMove.learn,
          WillOWispMove.learn
        ]
      )
    when "Dracanfly"
      Pokemon.new(
        name: "Dracanfly",
        types: [Types::DRAGON, Types::BUG],
        stats: [
          Stats.new(name: :hp, base_value: 75 ),
          Stats.new(name: :atk, base_value: 105 ),
          Stats.new(name: :def, base_value: 45 ),
          Stats.new(name: :sp_atk, base_value: 142 ),
          Stats.new(name: :sp_def, base_value: 90),
          Stats.new(name: :spd, base_value: 143)
        ],
        gender: :male,
        weight: 47,
        attacks: [
          UTurnMove.learn,
          FlamethrowerMove.learn,
          ScalePulseMove.learn,
          DracoMeteorMove.learn
        ]
      )              
    end
    # when "Volkenji"
    #   Pokemon.new(
    #     name: "Volkenji",
    #     types: [Types::ROCK],
    #     stats: [
    #       Stats.new(name: :hp, base_value: 172),
    #       Stats.new(name: :atk, base_value: 65),
    #       Stats.new(name: :def, base_value: 130),
    #       Stats.new(name: :sp_atk, base_value: 93),
    #       Stats.new(name: :sp_def, base_value: 106),
    #       Stats.new(name: :spd, base_value: 34)
    #     ],
    #     gender: :male,
    #     weight: 640,
    #     attacks: [
    #       UTurnMove.learn,
    #       FlamethrowerMove.learn,
    #       ScalePulseMove.learn,
    #       DracoMeteorMove.learn
    #     ]
    #   )              
    # end
  end
end