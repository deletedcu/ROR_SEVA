require 'csv'

namespace :import do 
  desc "import players"
  task players: :environment do
    filename = File.join Rails.root, "player-list(12-17-16).csv"
    counter = 0

    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      
      Player.where(name: row[:name]).first_or_create.update(name: row[:name], st: row[:state], height: row[:height], high_school: row[:school], grad_year: row[:gradyear], school_class: row[:division])
      player = Player.find_by(name: row[:name])
      player.create_skill(seva_win: row[:seva_win], seva_ppg: row[:seva_ppg], seva_apg: row[:seva_apg], seva_rpg: row[:seva_rpg], seva_spg: row[:seva_spg], seva_bpg: row[:seva_bpg], seva_fg: row[:seva_fg])
      #stats = player.stats.season_order.present? ? player.stats.season_order.first.update(seva_score: row[:sevascore]) : player.stats.create(season: row[:classint], ppg: row[:ppg], apg: row[:apg], rpg: row[:rpg], spg: row[:spg], fg: row[:fgp], winp: row[:winp], seva_score: row[:sevascore])
      #stats.first.update(seva_score: row[:seva_score]) 
      player.stats.where(season: row[:class]).first_or_create.update(year: row[:season], ppg: row[:ppg], apg: row[:apg], rpg: row[:rpg], spg: row[:spg], fg: row[:fgp], winp: row[:winp], seva_score: row[:sevascore])
      player.similars.where(similar_name: row[:similar_name]).first_or_create.update(similar_name: row[:similar_name]) 
      player.similars.where(similar_name: row[:similar_name_two]).first_or_create.update(similar_name: row[:similar_name_two]) 
      player.similars.where(similar_name: row[:similar_name_three]).first_or_create.update(similar_name: row[:similar_name_three]) 
      
      if player.grad_year.to_i > 2016
        player.update(current: true)
      else
        player.update(current: false)
      end
      counter += 1 if player.persisted?
      puts "#{player.name} #{counter}"
    end
    puts "Imported #{counter} players"
  end
end
