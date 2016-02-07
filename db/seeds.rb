class Seed
  def self.start
    create_avatars
    @bree, @rivendell = create_locations
    @armory, @inn, @apothecary, @blacksmith = create_categories
    create_stores
  end

  def self.create_avatars
    create_avatar("Gandalf","gandalf.jpg", 8, 19, 7, 20, 7, 200)
    create_avatar("Aragorn","aragorn.png", 15, 11, 15, 20, 12, 50)
    create_avatar("Gimli","gimli.jpeg",18, 7, 13, 20, 10, 150)
    create_avatar("Legolas","legolas.jpg", 10, 12, 19, 20, 17, 150)
    create_avatar("Boromir","boromir.jpg", 16, 9, 14, 20, 12, 100)
    create_avatar("Frodo","frodo.jpg", 7, 9, 12, 30, 16, 250)
    create_avatar("Sam","samwise.jpg", 10, 8, 11, 30, 15, 100)
    create_avatar("Merry","merry.jpeg",5, 10, 14, 30, 17, 120)
    create_avatar("Pippen","pippen.jpg",8, 7, 14, 30, 18, 80)
  end

  def self.create_avatar(name, image_url, strength, intelligence, dexterity, health, speed, money)
    s = SkillSet.create(strength: strength, intelligence: intelligence,
                                          dexterity: dexterity, health: health,
                                          speed: speed, money: money)
    Avatar.create(name: name, image_url: image_url, skill_set: s)
  end

  def self.create_locations
    [
      Location.create(name: "Bree", slug: "bree"),
      Location.create(name: "Rivendell", slug: "rivendell")
    ]
  end

  def self.create_categories
    [
      Category.create(name: "armory"),
      Category.create(name: "inn"),
      Category.create(name: "apothecary"),
      Category.create(name: "blacksmith")
    ]
  end

  def self.create_stores
    Store.create(category: @armory, location: @bree, name: "HANKS")
    Store.create(category: @inn, location: @bree, name: "Prancing Pony")
    Store.create(category: @apothecary, location: @bree, name: "Aaron's Drugs")
    Store.create(category: @blacksmith, location: @bree, name: "HANKS")

    Store.create(category: @armory, location: @rivendell, name: "TODDS")
    Store.create(category: @inn, location: @rivendell, name: "Beds by Shannon")
    Store.create(category: @apothecary, location: @rivendell, name: "TODDS")
    Store.create(category: @blacksmith, location: @rivendell, name: "Taylor's discount metal things")
  end
end

Seed.start
