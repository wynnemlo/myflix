# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: 'Comedy')
Category.create(name: 'Drama')

Video.create(title: 'Family Guy', description: 'A show about an American family', small_cover_url: '/images/family_guy.jpg', large_cover_url: '/images/futurama.jpg', category_id: 1)
Video.create(title: 'Southpark', description: 'A show 4 kids', small_cover_url: '/images/south_park.jpg', large_cover_url: '/images/south_park.jpg', category_id: 1)
Video.create(title: 'Monk', description: 'A show about monks', small_cover_url: '/images/monk.jpg', large_cover_url: '/images/monk_large.jpg', category_id: 2)
Video.create(title: 'Futurama', description: 'A show about the future', small_cover_url: '/images/futurama.jpg', large_cover_url: '/images/futurama.jpg', category_id: 2)