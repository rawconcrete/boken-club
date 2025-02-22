# db/seeds/tips.rb
def create_tips
  puts "creating tips..."

  tips_data = [
    {
      title: "Essential Packing Tips",
      content: "Always pack layers and check weather forecasts",
      category: "packing"
    },
    {
      title: "Safety First",
      content: "Tell someone your plans and expected return time",
      category: "safety"
    }
  ]

  tips_data.each do |tip|
    Tip.create!(tip)
  end
end
