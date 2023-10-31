require_relative "type_factory"
require_relative "stats"
require_relative "conditions"
require_relative "moves"
require "pry"

class Pokemon
  attr_reader :name, :types, :attacks, :lvl, :weight
  attr_accessor :stats, :condition
  def initialize(name:, types:, stats:, weight:, attacks:, lvl: 50)
    @name = name
    @types = types
    @stats = stats
    @weight = weight
    @attacks = attacks
    @lvl = lvl
    @stats.push(
      Stats.new(name: :evs, base_value: 1),
      Stats.new(name: :acc, base_value: 1)
    )
    @stats.each {|stat| stat.calc_value(lvl) }

    # @condition = condition
  end

  def fainted?
    hp_value <= 0
  end

  def view_attacks
    @attacks.each.with_index(1) do |atk, index|
      puts "#{index}- #{atk.attack_name}"
    end
  end

  def attack!(atk_index, target)
    @curr_attk = @attacks[atk_index-1]
    @curr_attk.perform(self, target)
  end

  def status
    puts "#{@name} - #{hp_value} / #{hp_total} hp (#{types.map(&:to_s).join("/")})"
    stats.each do |stat|
      puts "#{stat.name} #{stat.curr_value} / #{stat.initial_value} / #{stat.stage}"
    end
    nil
  end

  def atk_priority(attk_num)
    atk = @attacks[attk_num-1]
    AtkPriority.new(atk.priority, spd_value)
  end
 
  def to_s
    @name
  end

  def ==(other)
    @name == other.name
  end

  ::Stats::POSSIBLE_STATS.each do |stat|
    define_method("hp_total") do
      stats.find(&:hp?).initial_value
    end if stat == :hp

    define_method("#{stat}_value") do
      stats.find(&:"#{stat}?").curr_value
    end

    define_method(stat) do
      stats.find(&:"#{stat}?")
    end
  end
end

class AtkPriority
  attr_reader :priority, :speed
  def initialize(priority, speed)
    @priority = priority
    @speed = speed
  end

  def <=>(other)
    if self.priority > other.priority
      -1
    elsif self.priority < other.priority
      1
    else
      other.speed <=> self.speed
    end
  end
end

class PokeFactory < Pokemon
  def self.catch(name)
    case name
    when "Pikachu"
      Pokemon.new( name: "Pikachu",
                  types: [PokemonType::ELECTRIC],
                  stats: [Stats.new(name: :hp, base_value: 35 ),
                          Stats.new(name: :atk, base_value: 55 ),
                          Stats.new(name: :def, base_value: 40 ),
                          Stats.new(name: :sp_atk, base_value: 50 ),
                          Stats.new(name: :sp_def, base_value: 50 ),
                          Stats.new(name: :spd, base_value: 90 ),                          
                        ],
                  weight: 
                  attacks: [  ElectroBallMove.learn,
                              DischargeMove.learn,
                              ExtremeSpeedMove.learn,
                              AgilityMove.learn
                          ]
                  )
    when "Squirtle"
      Pokemon.new( name: "Squirtle",
                  types: [PokemonType::WATER],
                  stats: [Stats.new(name: :hp, base_value: 44 ),
                          Stats.new(name: :atk, base_value: 48 ),
                          Stats.new(name: :def, base_value: 65 ),
                          Stats.new(name: :sp_atk, base_value: 50 ),
                          Stats.new(name: :sp_def, base_value: 64 ),
                          Stats.new(name: :spd, base_value: 43 ),                          
                        ],
                  weight:
                  attacks: [  FoulPlayMove.learn,
                              ShellSmashMove.learn,
                              HydroPumpMove.learn,
                              DracoMeteorMove.learn
                          ]
                  )
    when "Snorlax"
      Pokemon.new( name: "Snorlax",
                  types: [PokemonType::NORMAL],
                  stats: [Stats.new(name: :hp, base_value: 160 ),
                          Stats.new(name: :atk, base_value: 110 ),
                          Stats.new(name: :def, base_value: 65 ),
                          Stats.new(name: :sp_atk, base_value: 65 ),
                          Stats.new(name: :sp_def, base_value: 110 ),
                          Stats.new(name: :spd, base_value: 30 ),                          
                        ],
                  weight:
                  attacks: [  RecoverMove.learn,
                              DoubleEdgeMove.learn,
                              CurseMove.learn,
                              GyroBallMove.learn
                          ]
                  )
    when "Milotic"
      Pokemon.new( name: "Milotic",
                  types: [PokemonType::WATER],
                  stats: [Stats.new(name: :hp, base_value: 95 ),
                          Stats.new(name: :atk, base_value: 60 ),
                          Stats.new(name: :def, base_value: 79 ),
                          Stats.new(name: :sp_atk, base_value: 100 ),
                          Stats.new(name: :sp_def, base_value: 125 ),
                          Stats.new(name: :spd, base_value: 81 ),                          
                        ],
                  weight:
                  attacks: [  HydroPumpMove.learn,
                              CurseMove.learn,
                              ShadowBallMove.learn,
                              CalmMindMove.learn
                          ]
                  )
    when "Golem"
      Pokemon.new( name: "Golem",
                  types: [PokemonType::ROCK, PokemonType::GROUND],
                  stats: [Stats.new(name: :hp, base_value: 80 ),
                          Stats.new(name: :atk, base_value: 120 ),
                          Stats.new(name: :def, base_value: 130 ),
                          Stats.new(name: :sp_atk, base_value: 55 ),
                          Stats.new(name: :sp_def, base_value: 65 ),
                          Stats.new(name: :spd, base_value: 45 ),                          
                        ],
                  weight:
                  attacks: [  BodyPressMove.learn,
                              FoulPlayMove.learn,
                              EarthquakeMove.learn,
                              SwordDanceMove.learn
                          ]
                  )              
    when "Sceptile"
      Pokemon.new( name: "Sceptile",
                  types: [PokemonType::GRASS],
                  stats: [Stats.new(name: :hp, base_value: 70 ),
                          Stats.new(name: :atk, base_value: 85 ),
                          Stats.new(name: :def, base_value: 65 ),
                          Stats.new(name: :sp_atk, base_value: 105 ),
                          Stats.new(name: :sp_def, base_value: 85 ),
                          Stats.new(name: :spd, base_value: 120 ),                          
                        ],
                  weight:
                  attacks: [  DracoMeteorMove.learn,
                              PowerGemMove.learn,
                              LeafStormMove.learn,
                              DoubleTeamMove.learn
                          ]
                  )
    when "Mew"
      Pokemon.new( name: "Mew",
                  types: [PokemonType::PSYCHIC],
                  stats: [Stats.new(name: :hp, base_value: 100 ),
                          Stats.new(name: :atk, base_value: 100 ),
                          Stats.new(name: :def, base_value: 100 ),
                          Stats.new(name: :sp_atk, base_value: 100 ),
                          Stats.new(name: :sp_def, base_value: 100 ),
                          Stats.new(name: :spd, base_value: 100 ),                          
                        ],
                  weight:
                  attacks: [  PsychicMove.learn,
                              FlamethrowerMove.learn,
                              ShadowBallMove.learn,
                              CalmMindMove.learn
                          ]
                  )             
    when "Dragapult"
      Pokemon.new( name: "Dragapult",
                  types: [PokemonType::DRAGON, PokemonType::GHOST],
                  stats: [Stats.new(name: :hp, base_value: 88 ),
                          Stats.new(name: :atk, base_value: 120 ),
                          Stats.new(name: :def, base_value: 75 ),
                          Stats.new(name: :sp_atk, base_value: 100 ),
                          Stats.new(name: :sp_def, base_value: 75 ),
                          Stats.new(name: :spd, base_value: 142 ),                          
                        ],
                  weight:
                  attacks: [  ShadowClawMove.learn,
                              DragonDartsMove.learn,
                              IceShardMove.learn,
                              DragonDanceMove.learn
                          ]
                  )
    when "Kommo-o"
      Pokemon.new( name: "Kommo-o",
                  types: [PokemonType::DRAGON, PokemonType::FIGHTING],
                  stats: [Stats.new(name: :hp, base_value: 75 ),
                          Stats.new(name: :atk, base_value: 110 ),
                          Stats.new(name: :def, base_value: 125 ),
                          Stats.new(name: :sp_atk, base_value: 100 ),
                          Stats.new(name: :sp_def, base_value: 105 ),
                          Stats.new(name: :spd, base_value: 85 ),                          
                        ],
                  weight:
                  attacks: [  CloseCombatMove.learn,
                              ClangingScalesMove.learn,
                              ClangorusSoulMove.learn,
                              BodyPressMove.learn
                          ]
                  )            
    when "Baxcalibur"
      Pokemon.new( name: "Baxcalibur",
                  types: [PokemonType::DRAGON, PokemonType::ICE],
                  stats: [Stats.new(name: :hp, base_value: 115 ),
                          Stats.new(name: :atk, base_value: 145 ),
                          Stats.new(name: :def, base_value: 92 ),
                          Stats.new(name: :sp_atk, base_value: 75 ),
                          Stats.new(name: :sp_def, base_value: 86 ),
                          Stats.new(name: :spd, base_value: 87 ),                          
                        ],
                  weight:
                  attacks: [  IcicleSpearMove.learn,
                              GlaiveRushMove.learn,
                              FlashMove.learn,
                              DragonDanceMove.learn
                          ]
                  )            
    when "Ogerpon"
      Pokemon.new( name: "Ogerpon - Heartflame",
                  types: [PokemonType::GRASS, PokemonType::FIRE],
                  stats: [Stats.new(name: :hp, base_value: 80 ),
                          Stats.new(name: :atk, base_value: 120 ),
                          Stats.new(name: :def, base_value: 84 ),
                          Stats.new(name: :sp_atk, base_value: 60 ),
                          Stats.new(name: :sp_def, base_value: 96 ),
                          Stats.new(name: :spd, base_value: 110 ),                          
                        ],
                  weight:
                  attacks: [  SeedBombMove.learn,
                              IvyCudgelMove.learn,
                              BulletSeedMove.learn,
                              SwordDanceMove.learn
                          ]
                  ) 
    when "Tinkaton"
      Pokemon.new( name: "Tinkaton",
                  types: [PokemonType::FAIRY, PokemonType::STEEL],
                  stats: [Stats.new(name: :hp, base_value: 85 ),
                          Stats.new(name: :atk, base_value: 75 ),
                          Stats.new(name: :def, base_value: 77 ),
                          Stats.new(name: :sp_atk, base_value: 70),
                          Stats.new(name: :sp_def, base_value: 105),
                          Stats.new(name: :spd, base_value: 94),                          
                        ],
                  weight:
                  attacks: [  GigatonHammerMove.learn,
                              PlayRoughMove.learn,
                              GyroBallMove.learn,
                              SwordDanceMove.learn
                          ]
                  )
    when "Gengar"
      Pokemon.new( name: "Gengar",
                  types: [PokemonType::GHOST, PokemonType::POISON],
                  stats: [Stats.new(name: :hp, base_value: 60 ),
                          Stats.new(name: :atk, base_value: 65 ),
                          Stats.new(name: :def, base_value: 60 ),
                          Stats.new(name: :sp_atk, base_value: 130),
                          Stats.new(name: :sp_def, base_value: 75),
                          Stats.new(name: :spd, base_value: 110),                          
                        ],
                  weight:
                  attacks: [  ShadowBallMove.learn,
                              PsychicMove.learn,
                              FlamethrowerMove.learn,
                              CalmMindMove.learn
                          ]
                  )
    when "Ceruledge"
      Pokemon.new( name: "Ceruledge",
                  types: [PokemonType::GHOST, PokemonType::FIRE],
                  stats: [Stats.new(name: :hp, base_value: 75 ),
                          Stats.new(name: :atk, base_value: 125 ),
                          Stats.new(name: :def, base_value: 80 ),
                          Stats.new(name: :sp_atk, base_value: 60 ),
                          Stats.new(name: :sp_def, base_value: 100),
                          Stats.new(name: :spd, base_value: 85),                          
                        ],
                  weight:
                  attacks: [  FlareBlitzMove.learn,
                              ShadowClawMove.learn,
                              SolarBladeMove.learn,
                              SwordDanceMove.learn
                          ]
                  )
    when "Poltchageist"
      Pokemon.new( name: "Poltchageist",
                  types: [PokemonType::GHOST, PokemonType::GRASS],
                  stats: [Stats.new(name: :hp, base_value: 40 ),
                          Stats.new(name: :atk, base_value: 45 ),
                          Stats.new(name: :def, base_value: 45 ),
                          Stats.new(name: :sp_atk, base_value: 74 ),
                          Stats.new(name: :sp_def, base_value: 54),
                          Stats.new(name: :spd, base_value: 50),                          
                        ],
                  weight:
                  attacks: [  LeafStormMove.learn,
                              ShadowBallMove.learn,
                              FoulPlayMove.learn,
                              GrassKnotMove.learn
                          ]
                  )
    when "Gholdengo"
      Pokemon.new( name: "Gholdengo",
                  types: [PokemonType::GHOST, PokemonType::STEEL],
                  stats: [Stats.new(name: :hp, base_value: 87 ),
                          Stats.new(name: :atk, base_value: 60 ),
                          Stats.new(name: :def, base_value: 95 ),
                          Stats.new(name: :sp_atk, base_value: 133 ),
                          Stats.new(name: :sp_def, base_value: 91),
                          Stats.new(name: :spd, base_value: 84),                          
                        ],
                  weight:
                  attacks: [  MakeItRainMove.learn,
                              GyroBallMove.learn,
                              ShadowBallMove.learn,
                              DoubleTeamMove.learn
                          ]
                  )
    when "Zoroark-hisui"
      Pokemon.new( name: "Zoroark-hisui",
                  types: [PokemonType::GHOST, PokemonType::NORMAL],
                  stats: [Stats.new(name: :hp, base_value: 55 ),
                          Stats.new(name: :atk, base_value: 100 ),
                          Stats.new(name: :def, base_value: 60 ),
                          Stats.new(name: :sp_atk, base_value: 125 ),
                          Stats.new(name: :sp_def, base_value: 60),
                          Stats.new(name: :spd, base_value: 110),                          
                        ],
                  weight: 
                  attacks: [  FoulPlayMove.learn,
                              ShadowClawMove.learn,
                              ShadowBallMove.learn,
                              BitterMaliceMove.learn
                          ]
                  )
    when "Dracanfly"
      Pokemon.new( name: "Dracanfly",
                  types: [PokemonType::DRAGON, PokemonType::BUG],
                  stats: [Stats.new(name: :hp, base_value: 75 ),
                          Stats.new(name: :atk, base_value: 105 ),
                          Stats.new(name: :def, base_value: 45 ),
                          Stats.new(name: :sp_atk, base_value: 142 ),
                          Stats.new(name: :sp_def, base_value: 90),
                          Stats.new(name: :spd, base_value: 143),                          
                        ],
                  weight:
                  attacks: [  ScalePulseMove.learn,
                              DracoMeteorMove.learn,
                              HydroPumpMove.learn,
                              FlamethrowerMove.learn
                          ]
                  )              
    end
  end
end

# ESTUDIAR METODOS ACCESORES
# Status effects always hits (chqueo de ocurrencia can_perfom)
# APLICAR TABLA GENERICA PARA LOS MOVIMIENTOS (GYROBALL PONERLO DENTRO DEL MIMSO ATAQUE)
# ESTRUCTURAR ARCHIVOS
# AGREGAR ESTADOS DE SALUD DEL POKE (CONFUSION, CONGELADO, QUEMADO, ETC)
