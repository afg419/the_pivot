class RouletteService
  attr_reader :origin_location, :target_location, :health_after_game, :current_character

  def initialize(params, current_character = nil)
    @origin_location = Location.find(params[:location_id])
    @target_location = origin_location.next_location
    @health_after_game = params[:health].to_i
    @current_character = current_character
    @armory, @inn, @apothecary, @blacksmith = Category.all
  end

  def generate_travel_event
    return :dead if health_after_game <= 0

    main_wound = generate_main_wound
    current_character.items += generate_random_items
    current_character.incidents += generate_random_wounds + generate_main_wound
    current_character.heals_wounds
    current_character.save

    return :dead if current_character.hp <= 0

    :success
  end

  def generate_main_wound
    damage = current_character.hp - health_after_game
    wound_ss = SkillSet.create(health: -1 * damage)
    wound = Incident.create(name: wound_name, skill_set: wound_ss)
  end


  def generate_random_items
    random = rand(1..100)
    if random > 95
      generate_items(4)
    elsif random > 85
      generate_items(3)
    elsif random > 70
      generate_items(2)
    elsif random > 50
      generate_items(1)
    end
  end

  def generate_random_wounds
    random = rand(1..100)
    if random > 95
      generate_wounds(4)
    elsif random > 85
      generate_wounds(3)
    elsif random > 70
      generate_wounds(2)
    elsif random > 50
      generate_wounds(1)
    end
  end

  def generate_items(n)
    gained_items = []
    n.times do |i|
      gained_items << item_list.sample.save
    end
  end

  def generate_wounds(n)
    new_wounds = []
    n.times do |i|
      new_wounds << wound_list.sample.save
    end
  end

  def wound_name
    ["Broken", "Rotting", "Bloodied", "Atrophied", "Infected", "Punctured", "Decaying", "Nazgul evicerated", "Orc shredded your"].sample +
    [" Leg", " Head", " Lung", " Guts", " Bowels", " Foot", " Dreams"].sample
  end

  def item_list
    [create_item("Someshit", @blacksmith, "Sword" 0, 0, 0, 0, 1, -2), create_item("Bread", @blacksmith, "Spider Bite", 0, 0, 0, 0, 1, -2), create_item("Bossass", @blacksmith, "OW" 0, 0, 0, 0, 1, -2)]
  end

  def create_item(name, category, label, strength, intelligence, dexterity, health, speed, money)
    s = SkillSet.new(strength: strength, intelligence: intelligence,
                                          dexterity: dexterity, health: health,
                                          speed: speed, money: money)
    Item.new(name: name, skill_set: s, category: category, label: label)
  end

  def wound_list
    [create_wound("OW",0,0,0,-2,0,10), create_wound("OW",0,0,0,-2,0,10), create_wound("OW",0,0,0,-2,0,10), create_wound("Spider Bite",0,0,0,-2,0,10)]
  end

  def create_wound(name, category, label, strength, intelligence, dexterity, health, speed, money)
    s = SkillSet.new(strength: strength, intelligence: intelligence,
                                          dexterity: dexterity, health: health,
                                          speed: speed, money: money)
    Incident.new(name: name, skill_set: s, category: category, label: label)
  end

  def heal_wounds
    wounds = current_character.incidents
    items = current_character.items.where(category: [@inn, @apothecary] )

    wounds.reduce([]) do |array, wound|
      items.each do |item|
        if item.label == wound.name
          array << destroy_if_matching(array, wound)
          break
        end
      end
    end
  end

  def destroy_if_matching(item, wound)
      item_name, wound_name = item.name, wound.name
      item.destroy
      wound.destroy
      "#{item_name} was used to prevent #{wound_name}"
  end
end
