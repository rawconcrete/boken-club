# lib/tasks/adventure_quiz.rake
namespace :adventure_quiz do
  desc "Seed the Adventure Finder Quiz"
  task seed: :environment do
    load Rails.root.join('db/seeds/adventure_quiz.rb')
  end
end
