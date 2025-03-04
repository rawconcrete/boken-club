# db/seeds/users.rb
def create_users
  puts "Creating users..."

  # Basic users
  User.create!([
    {email: 'user1@example.com', password: 'password'},
    {email: 'user2@example.com', password: 'password'},
    {email: "test@example.com", password: "password", role: 1}
  ])

  # Admin accounts
  [
    { email: 'admin@admin.com', password: '123456', admin: true, role: 1 },
    { email: 'sarah', password: '123', admin: true, role: 1 },
    { email: 'nico', password: '123', admin: true, role: 1 },
    { email: 'lio', password: '123', admin: true, role: 1 }
  ].each do |admin_data|
    user = User.new(admin_data)
    user.save(validate: false)
  end

  puts "Created #{User.count} users"
end
