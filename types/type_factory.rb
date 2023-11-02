class Types
  EFFECTIVE = 1.freeze
  SUPER_EFFECTIVE = 2.freeze
  NOT_EFFECTIVE = 0.5.freeze
  INMUNE = 0.freeze

  %w[
    fire
    grass
    water
    electric
    fighting
    normal
    ghost
    dark
    psychic
    fairy
    poison
    steel
    rock
    ground
    bug
    flying
    dragon
    ice
  ].each do |type|
    self.const_set(type.upcase, type.to_sym)
  end

  def self.calc_multiplier(attacking_types, defending_types)
    chart = {
      NORMAL => {
        STEEL => NOT_EFFECTIVE,
        GHOST => INMUNE,
        ROCK =>  NOT_EFFECTIVE
      },
      FIGHTING => {
        NORMAL => SUPER_EFFECTIVE,
        GHOST =>  INMUNE,
        STEEL =>  SUPER_EFFECTIVE,
        ROCK =>   SUPER_EFFECTIVE,
        ICE => SUPER_EFFECTIVE,
        DARK => SUPER_EFFECTIVE,
        BUG => NOT_EFFECTIVE,
        FAIRY => NOT_EFFECTIVE,
        PSYCHIC => NOT_EFFECTIVE,
        POISON => NOT_EFFECTIVE,
        FLYING => NOT_EFFECTIVE,
      },
      GHOST => {
        NORMAL => INMUNE,
        GHOST =>  SUPER_EFFECTIVE,
        PSYCHIC =>  SUPER_EFFECTIVE,
        DARK =>  NOT_EFFECTIVE
      },
      FIRE => {
        BUG =>   SUPER_EFFECTIVE,
        FIRE =>  NOT_EFFECTIVE,
        STEEL => SUPER_EFFECTIVE,
        ROCK =>  NOT_EFFECTIVE,
        GRASS => SUPER_EFFECTIVE,
        DRAGON => NOT_EFFECTIVE
      },
      GRASS => {
        WATER => SUPER_EFFECTIVE,
        GROUND => SUPER_EFFECTIVE,
        ROCK => SUPER_EFFECTIVE,
        STEEL =>  NOT_EFFECTIVE,
        BUG =>  NOT_EFFECTIVE,
        DRAGON =>  NOT_EFFECTIVE,
        FIRE =>  NOT_EFFECTIVE,
        GRASS =>  NOT_EFFECTIVE,
        POISON =>  NOT_EFFECTIVE,
        FLYING =>  NOT_EFFECTIVE
      },
      WATER => {
        GROUND => SUPER_EFFECTIVE,
        FIRE => SUPER_EFFECTIVE,
        ROCK => SUPER_EFFECTIVE,
        GRASS =>  NOT_EFFECTIVE,
        WATER =>  NOT_EFFECTIVE,
        DRAGON =>  NOT_EFFECTIVE
      },
      ELECTRIC => {
        GROUND => INMUNE,
        WATER => SUPER_EFFECTIVE,
        FLYING => SUPER_EFFECTIVE,
        GRASS =>  NOT_EFFECTIVE,
        DRAGON =>  NOT_EFFECTIVE,
        ELECTRIC =>  NOT_EFFECTIVE,
      },
      DARK => {
        GHOST => SUPER_EFFECTIVE,
        PSYCHIC => SUPER_EFFECTIVE,
        FIGHTING =>  NOT_EFFECTIVE,
        DARK =>  NOT_EFFECTIVE,
        FAIRY => NOT_EFFECTIVE
      },
      PSYCHIC => {
        FIGHTING =>  SUPER_EFFECTIVE,
        POISON =>  SUPER_EFFECTIVE,
        STEEL =>  NOT_EFFECTIVE,
        PSYCHIC =>  NOT_EFFECTIVE,
        DARK => INMUNE
      },
      FAIRY => {
        DARK => SUPER_EFFECTIVE,
        FAIRY => SUPER_EFFECTIVE,
        DRAGON => SUPER_EFFECTIVE,
        STEEL =>  NOT_EFFECTIVE,
        FIRE =>  NOT_EFFECTIVE,
        POISON =>  NOT_EFFECTIVE
      },
      POISON => {
        POISON =>  NOT_EFFECTIVE,
        GROUND =>  NOT_EFFECTIVE,
        GHOST =>  NOT_EFFECTIVE,
        ROCK =>  NOT_EFFECTIVE,
        STEEL => INMUNE,
        FAIRY => SUPER_EFFECTIVE,
        GRASS => SUPER_EFFECTIVE
      },
      STEEL => {
        FAIRY => SUPER_EFFECTIVE,
        ROCK => SUPER_EFFECTIVE,
        ICE => SUPER_EFFECTIVE,
        STEEL =>  NOT_EFFECTIVE,
        WATER =>  NOT_EFFECTIVE,
        ELECTRIC =>  NOT_EFFECTIVE,
        FIRE =>  NOT_EFFECTIVE
      },
      ROCK => {
        ICE => SUPER_EFFECTIVE,
        FIRE => SUPER_EFFECTIVE,
        FLYING => SUPER_EFFECTIVE,
        STEEL =>  NOT_EFFECTIVE,
        FIGHTING =>  NOT_EFFECTIVE,
        GROUND =>  NOT_EFFECTIVE
      },
      GROUND => {
        FLYING => INMUNE,
        BUG =>  NOT_EFFECTIVE,
        GRASS =>  NOT_EFFECTIVE,
        FIRE => SUPER_EFFECTIVE,
        STEEL => SUPER_EFFECTIVE,
        ROCK => SUPER_EFFECTIVE,
        ELECTRIC => SUPER_EFFECTIVE,
        POISON => SUPER_EFFECTIVE
      },
      BUG => {
        PSYCHIC => SUPER_EFFECTIVE,
        DARK => SUPER_EFFECTIVE,
        GRASS => SUPER_EFFECTIVE,
        STEEL => NOT_EFFECTIVE,
        GHOST => NOT_EFFECTIVE,
        FIRE => NOT_EFFECTIVE,
        FAIRY => NOT_EFFECTIVE,
        FIGHTING => NOT_EFFECTIVE,
        POISON => NOT_EFFECTIVE,
        FLYING => NOT_EFFECTIVE,
      },
      FLYING => {
        GRASS => SUPER_EFFECTIVE,
        BUG => SUPER_EFFECTIVE,
        FIGHTING => SUPER_EFFECTIVE,
        STEEL => NOT_EFFECTIVE,
        ROCK => NOT_EFFECTIVE,
        ELECTRIC => NOT_EFFECTIVE
      },
      DRAGON => {
        FAIRY => INMUNE,
        STEEL => NOT_EFFECTIVE,
        DRAGON => SUPER_EFFECTIVE
      },
      ICE => {
        DRAGON => SUPER_EFFECTIVE,
        GROUND => SUPER_EFFECTIVE,
        GRASS => SUPER_EFFECTIVE,
        FLYING => SUPER_EFFECTIVE,
        STEEL => NOT_EFFECTIVE,
        WATER => NOT_EFFECTIVE,
        FIRE => NOT_EFFECTIVE,
        ICE => NOT_EFFECTIVE,
      }
    }

    defending_types.inject(1.0) do |multiplier, defending_type|
      attacking_types.inject(multiplier) do |multiplier, attacking_type|
        multiplier * chart[attacking_type].fetch(defending_type, EFFECTIVE)
      end
    end
  end
end