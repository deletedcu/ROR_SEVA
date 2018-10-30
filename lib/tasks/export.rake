require 'csv'
require 'aws-sdk'

namespace :export do 
  desc "export players"
  task players: :environment do

    s3 = Aws::S3::Resource.new(
      region: 'us-east-1',
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )

    

     CSV.open("#{Rails.root}/export-players.csv", 'w') do |csv|
      @players = Player.all # your query here
      count = 0
      csv << ['Name', 'ST', 'Height', 'Committed To', 'Grad Year', 'High School', 'ESPN', 'Scout', 'Rivals','PPG','APG','RPG','BPG','SPG','FG%','WIN%','Season','Year','Games Played']  #column head of csv file
      @players.each do |p|
        #next if p.stats.blank?
        if p.stats.present?
          count += 1
          csv << [p.name, p.st, p.height, p.committed_to, p.grad_year, p.high_school, p.rating.espn, p.rating.scout, p.rating.rivals, p.stats.season_order.first.ppg, p.stats.season_order.first.apg, 
          	p.stats.season_order.first.rpg, p.stats.season_order.first.bpg, p.stats.season_order.first.spg, p.stats.season_order.first.fg, p.stats.season_order.first.winp, p.stats.season_order.first.season, p.stats.season_order.first.year, p.stats.season_order.first.games_played]
          puts "#{p.name} was exported! #{count}"
        end
      end
    end
    s3.bucket('sevasports').object('export-players.csv').upload_file("#{Rails.root}/export-players.csv")
  end
end