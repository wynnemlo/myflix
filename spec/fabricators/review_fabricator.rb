Fabricator(:review) do
  comment { Faker::Lorem.paragraph(3) }
  rating { 5 }
end