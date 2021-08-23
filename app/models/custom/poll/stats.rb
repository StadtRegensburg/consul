require_dependency Rails.root.join("app", "models", "poll", "stats").to_s
class Poll::Stats

  private

    def stats_cache(key, &block)
      if [:total_participants,
          :total_male_participants,
          :total_female_participants,
          :male_percentage,
          :female_percentage,
          :participants_by_age,
          :participants_by_geozone,
          :total_no_demographic_data,
          :total_valid_votes,
          :total_white_votes,
          :total_null_votes,
          :total_participants_web,
          :total_web_valid,
          :total_web_white,
          :total_web_null,
          :total_participants_booth,
          :total_booth_valid,
          :total_booth_white,
          :total_booth_null,
          :total_participants_letter,
          :total_letter_valid,
          :total_letter_white,
          :total_letter_null,
          :total_participants_web_percentage,
          :total_participants_booth_percentage,
          :total_participants_letter_percentage,
          :valid_percentage_web,
          :valid_percentage_booth,
          :valid_percentage_letter,
          :total_valid_percentage,
          :white_percentage_web,
          :white_percentage_booth,
          :white_percentage_letter,
          :total_white_percentage,
          :null_percentage_web,
          :null_percentage_booth,
          :null_percentage_letter,
          :total_null_percentage].include?(key)
        Rails.cache.delete("polls_stats/#{poll.id}/#{key}/#{version}")
      end
      Rails.cache.fetch("polls_stats/#{poll.id}/#{key}/#{version}", &block)
    end
end
