FactoryBot.define do
  factory :projekt do
    sequence(:name) { |n| "Projekt_#{SecureRandom.hex}" }

    sequence(:order_number) { |n| n }

    total_duration_start { 1.month.ago }
    total_duration_end { 1.month.from_now }

    color { "#00AA02" }
    icon { "biking" }

    factory :active_projekt do
      after(:create) do |projekt|
        projekt.projekt_settings.find_by(key: 'projekt_feature.main.activate').update(value: true)
        projekt.debate_phase.update(active: true, start_date: 1.month.ago, end_date: 1.month.from_now )
        projekt.proposal_phase.update(active: true, start_date: 1.month.ago, end_date: 1.month.from_now )
      end
    end
  end
end
