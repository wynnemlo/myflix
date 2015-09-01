class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :leader, class_name: "Leader"

end