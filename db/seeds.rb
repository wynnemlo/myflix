# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: 'Comedy')
Category.create(name: 'Drama')

User.create(full_name: "Wynne Lo", password: "testing", email: "wynnemlo@gmail.com", admin: false)
User.create(full_name: "Bobby Chan", password: "testing", email: "bobby@gmail.com", admin: false)
User.create(full_name: "Ahri Lee", password: "testing", email: "ahri@gmail.com", admin: true)

Video.create(title: 'Family Guy', description: 'A show about an American family', category_id: 1)
Video.create(title: 'Southpark', description: 'A show 4 kids', category_id: 1)
Video.create(title: 'Monk', description: 'A show about monks', category_id: 2)
Video.create(title: 'Futurama', description: 'A show about the future', category_id: 2)
Video.create(title: 'Family Guy', description: 'A show about an American family', category_id: 1)
Video.create(title: 'Southpark', description: 'A show 4 kids', category_id: 1)
Video.create(title: 'Monk', description: 'A show about monks', category_id: 2)
Video.create(title: 'Futurama', description: 'A show about the future', category_id: 2)
Video.create(title: 'Family Guy', description: 'A show about an American family', category_id: 1)
Video.create(title: 'Southpark', description: 'A show 4 kids', category_id: 1)
Video.create(title: 'Monk', description: 'A show about monks', category_id: 2)
Video.create(title: 'Futurama', description: 'A show about the future', category_id: 2)
Video.create(title: 'Futurama', description: 'A show about the future', category_id: 2)
Video.create(title: 'Family Guy', description: 'A show about an American family', category_id: 1)
Video.create(title: 'Southpark', description: 'A show 4 kids', category_id: 1)
Video.create(title: 'Monk', description: 'A show about monks', category_id: 2)
Video.create(title: 'Futurama', description: 'A show about the future', category_id: 2)
Video.create(title: 'Futurama', description: 'A show about the future', category_id: 2)
Video.create(title: 'Family Guy', description: 'A show about an American family', category_id: 1)
Video.create(title: 'Southpark', description: 'A show 4 kids', category_id: 1)
Video.create(title: 'Monk', description: 'A show about monks', category_id: 2)
Video.create(title: 'Futurama', description: 'A show about the future', category_id: 2)

Review.create(user_id: 2, video_id: 2, rating: 5, comment: "Awesome video!")
Review.create(user_id: 2, video_id: 2, rating: 3, comment: "Not very good.")

Fabricate(:queue_item, user_id: 2, video_id: 1)
Fabricate(:queue_item, user_id: 2, video_id: 2)
Fabricate(:queue_item, user_id: 2, video_id: 3)

Relationship.create(leader_id: 2, follower_id: 1)