module JourneyHelper
  def add_start_items
    @armory, @inn, @apothecary, @blacksmith = Category.all
    case current_character.avatar.name
      when "Gandalf"
        current_character.items = [ create_item("Staff", @blacksmith, "staff", 0, 0, 1, 0, 0, 0, -2),
                                    create_item("Robe", @armory, "armor", 0, 0, 0, 0, 0, 0, -2)
                                  ]
      when "Aragorn"
        current_character.items = [ create_item("Sword", @blacksmith, "sword", 1, 0, 0, 0, 0, 0, -2),
                                    create_item("Dirty Shirt", @armory, "armor", 0, 0, 0, 0, -1, 0, -2)
                                  ]
      when "Gimli"
        current_character.items = [ create_item("Axe", @blacksmith, "sword", 0, 0, 0, 0, 0, -1, -2),
                                    create_item("Rusty Chainmail", @armory, "armor", 0, 0, 1, 0, 0, 0, -2)
                                  ]
      when "Legolas"
        current_character.items = [ create_item("Bow", @blacksmith, "bow", 0, 0, 0, 0, 0, -1, -2),
                                    create_item("Elvish Shirt", @armory, "armor", 0, 0, 1, 0, 0, 0, -2)
                                  ]
      when "Boromir"
        current_character.items = [ create_item("Sword", @blacksmith, "sword", 1, 0, 0, 0, 0, 0, -2),
                                    create_item("Shirt", @armory, "shirt", 0, 0, 0, 0, -1, 0, -2)
                                  ]
      when "Frodo"
        current_character.items = [ create_item("Hobbit Sword", @blacksmith, "sword", 0, 0, 0, 0, 0, 1, -2),
                                    create_item("Shirt", @armory, "armor", 0, 0, 0, 0, -1, 0, -2)
                                  ]
      when "Sam"
        current_character.items = [ create_item("Hobbit Sword", @blacksmith, "sword", 0, 0, 0, 0, 0, 1, -2),
                                    create_item("Shirt", @armory, "armor", 0, 0, 0, 0, -1, 0, -2)
                                  ]
      when "Merry"
        current_character.items = [ create_item("Hobbit Sword", @blacksmith, "sword", 0, 0, 0, 0, 0, 1, -2),
                                    create_item("Shirt", @armory, "armor", 0, 0, 0, 0, -1, 0, -2)
                                  ]
      when "Pippen"
        current_character.items = [ create_item("Hobbit Sword", @blacksmith, "sword", 0, 0, 0, 0, 0, 1, -2),
                                    create_item("Shirt", @armory, "armor", 0, 0, 0, 0, -1, 0, -2)
                                  ]
    end
  end

  def create_item(name, category, label,  strength, defence, intelligence, dexterity, health, speed, money)
    s = SkillSet.find_or_create_by(strength: strength, defence: defence, intelligence: intelligence,
                                          dexterity: dexterity, health: health,
                                          speed: speed, money: money)
    Item.find_or_create_by(name: name, skill_set: s, category: category, label: label)
  end

end
