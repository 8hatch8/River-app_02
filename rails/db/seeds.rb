3.times do |n|
  User.create!(
    nickname: "test0#{n + 1}",
    email: "test0#{n + 1}@test.com",
    password: '123456',
    password_confirmation: '123456',
  )
end

user = User.first

5.times { |n| Room.create!(name: "Room0#{n + 1}", user_id: user.id) }

room = Room.first

5.times do |n|
  Agenda.create!(name: "Agenda0#{n + 1}", content: "this is agenda0#{n + 1}", room_id: room.id)
end

agenda = Agenda.first

5.times do |n|
  Item.create!(text: "#{n + 1}つ目の項目", format: 'text', agenda_id: agenda.id, user_id: user.id)
end

puts 'seed.rbから初期データを作成しました'
