class ActionHandler
  MOVING_INPUT = %w[right left top bottom].freeze
  CHOICE_INPUT = %w[yes no].freeze
  FIGHT_INPUT = %w[fight run].freeze

  attr_reader :instruction

  def initialize(direction_service, player, weapon, boss, dungeon)
    @direction_service = direction_service
    @dungeon = dungeon
    @player = player
    @weapon = weapon
    @boss = boss
    moving_action
  end

  def handle_input(input)
    return false unless @possible_choices.include?(input)

    handle_moving(input) if MOVING_INPUT.include?(input) && @action == :moving
    handle_equipping(input) if CHOICE_INPUT.include?(input) && @action == :equipping
    handle_aggro(input) if FIGHT_INPUT.include?(input) && @action == :aggro
  end

  private

  def handle_aggro(input)
    if input == 'fight'
      @instruction = @player.fight(@weapon.equipped)
      true
    elsif false
      @instruction = "That roll did not work... #{@boss.name} KILLED YOU! YOU DIED!"
      true
    else
      moving_action("You lucky bastard!\n")
      false
    end
  end

  def handle_moving(input)
    @dungeon.mark_room_as_visited(@player.position)
    @player.walk(input)
    return if collision?

    @possible_choices = @direction_service.possible_directions(@player.position)
    @instruction = "Where to go? (#{@possible_choices.join('/')})"
  end

  def handle_equipping(input)
    @possible_choices = @direction_service.possible_directions(@player.position)
    if input == 'yes'
      @instruction = "You can now kill the boss!\nWhere to go? (#{@possible_choices.join('/')})"
      @weapon.equipped = true
    else
      @instruction = "#{@boss.name} will kick your ass for sure!\nWhere to go? (#{@possible_choices.join('/')})"
    end
    @action = :moving
  end

  def moving_action(custom_instruction = nil)
    @possible_choices = @direction_service.possible_directions(@player.position)
    @instruction = "#{custom_instruction}Where to go? (#{@possible_choices.join('/')})"
    @action = :moving
  end

  def equipping_action
    @possible_choices = CHOICE_INPUT
    @instruction = "You just found the #{@weapon.name}! Equip? (#{@possible_choices.join('/')})"
    @action = :equipping
  end

  def aggro_action
    @possible_choices = FIGHT_INPUT
    @instruction = "Holy shit! #{@boss.name} is here! (#{@possible_choices.join('/')})"
    @action = :aggro
  end

  def collision?
    if @player.position == @weapon.position
      equipping_action
    elsif @player.position == @boss.position
      aggro_action
    else
      false
    end
  end
end
