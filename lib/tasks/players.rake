require 'mechanize'
require 'open-uri'

## 15-16 Double Digit Scorers ##
#Utah
#Arizona
#Nevada


namespace :scrape do 
  desc "scrape player points"
  task points: :environment do
  	agent = Mechanize.new
    agent.ignore_bad_chunking = true

    10.times do |pagenumber|
    pagenumber += 1
    agent.get("http://www.maxpreps.com/leaders/basketball-winter-16-17/,points/stat-leaders-#{pagenumber}.htm?classyear=all&position=all")
    count = 0
      agent.page.links_with(href: %r{/player/}).each do |link|
        count += 1

        first = link.to_s.split(" ")[0].downcase.capitalize
        if link.to_s.split(" ")[1].present?
          middle = link.to_s.split(" ")[1].downcase.capitalize
        end 
        if link.to_s.split(" ")[2].present?
          last = link.to_s.split(" ")[2].downcase.capitalize
        end
        name = [first,middle,last].join(" ").squeeze(" ").rstrip

        puts name

        agent.click(link)
        agent.click('li.active > span')

        puts state = agent.page.css('.school-state').text
        height = agent.page.css('.height').text
        puts height
        feet = height.split("'")[0]
        puts feet
        inches = height.split("'")[1] ? height.split("'")[1].chomp('"') : 0
        height_inches = (feet.to_i * 12) + inches.to_i

        puts high_school = agent.page.css('.school-name').text.squeeze(" ")
        graduation_year = agent.page.css('.graduation-year').text

        player = Player.where(name: name, st: state, high_school: high_school).first_or_create.update(st: state, height: height_inches, grad_year: graduation_year.gsub(/[^\d]/, ''), high_school: high_school, verified: true)

        i = 0
        ii = 1
         	agent.page.search('table')[0].search('tbody > tr')[0,4].each do |p|
          	stat_line = p.search('td').map { |ff| ff.text.present? ? ff.text : 0 }
            
            #Add field goal percentage for the season
            if agent.page.search('table')[1].search('tbody > tr')[i].present?
            stat_line << agent.page.search('table')[1].search('tbody > tr')[i].search('.fieldgoalpercentage').text
            else
            stat_line << 0
            end

            #Add record for each season

            if agent.page.search('div.item')[ii].present?
              stat_line << agent.page.search('div.item')[ii].search('dl.records-rankings').at_css('dd').text
              wins = stat_line[15].split("-").first.to_f
              losses = stat_line[15].split("-").last.to_f
              total = wins + losses
              win = wins/total
              winstring = win.round(2) * 100
              if winstring.nan?
                winstring = 0
              else
                winstring.to_i 
              end
            else
              winstring = 0
            end

            if stat_line[1] == "Senior"
              season = 0
              puts season
            elsif stat_line[1] == "Junior"
              season = 1
              puts season
            elsif stat_line[1] == "Sophomore"
              season = 2
              puts season
            else
              season = 3
              puts season
            end

            player = Player.find_by(name: name, st: state, high_school: high_school)

            if player.stats.present?
              fg_percent = stat_line[14] != nil ? stat_line[14] : 48
              player.stats.where(season: season).first_or_create(season: season, year: stat_line[0], hs_level: stat_line[2], games_played: stat_line[3], ppg: stat_line[5], apg: stat_line[9], rpg: stat_line[8], bpg: stat_line[11], spg: stat_line[10], fg: fg_percent, winp: winstring.to_i)
            else
              fg_percent = stat_line[14] != nil ? stat_line[14] : 48
              player.stats.create(season: season, year: stat_line[0], hs_level: stat_line[2], games_played: stat_line[3], ppg: stat_line[5], apg: stat_line[9], rpg: stat_line[8], bpg: stat_line[11], spg: stat_line[10], fg: fg_percent, winp: winstring.to_i)
            end
            
            player.create_skill if player.skill.nil?
            player.create_rating if player.rating.nil?

            if player.grad_year.to_i >= 2017
              player.update(current: true)
            else
              player.update(current: false)
            end

          	i += 1
          	ii += 1
          end #stat tables
        sleep rand(6)
        puts count
        end #links
    end # 10.times
  end #task stats


  desc "scrape player committments"
  task committments: :environment do
    agent = Mechanize.new

    5.times do |pagenumber|
    pagenumber += 1  
    agent.get("http://verbalcommits.com/player_rankings/2018/position/#{pagenumber}")
    count = 0
    agent.page.links_with(:href => %r{/players/}).each do |link|
      next if link.text == "Undecided"
      count += 1

      first = link.to_s.split(" ")[0].downcase.capitalize
      middle = link.to_s.split(" ")[1].downcase.capitalize
      if link.to_s.split(" ")[2].present?
        last = link.to_s.split(" ")[2].downcase.capitalize
      end
      name = [first,middle,last].join(" ").squeeze(" ").rstrip
      
      puts name

      agent.click(link)
    
      #committed = agent.page.search('div#main-profile').search('h3.player-status').search('span.metric-value').text
      #puts committed
      basic_info = []
      agent.page.search('div#main-profile').search('h3 > span.metric-value').each do |info|
        basic_info << info.text
      end


      committed = basic_info[0].to_s

      if committed.include? "On Scholarship at"
        committed = basic_info[0].gsub(/On Scholarship at/,"").squeeze(" ")
      elsif committed.include? "Verbally Committed to"
        committed = basic_info[0].gsub(/Verbally Committed to/,"").squeeze(" ")
      elsif committed.include? "Signed LOI with"
        committed = basic_info[0].gsub(/Signed LOI with/,"").squeeze(" ")
      elsif committed.include? "Left Early for Pro Career from"
        committed = basic_info[0].gsub(/Left Early for Pro Career from/,"").squeeze(" ")
      elsif committed.include? "Suffered Career Ending Injury while at"
        committed = basic_info[0].gsub(/Suffered Career Ending Injury while at/,"").squeeze(" ")
      end
      
      puts committed        

      grad_year = basic_info[1].gsub(/[^\d]/, '')

      height = basic_info[3].gsub(/-/,"'")
      puts height

      state = basic_info[5].to_s.split.last
      puts state

      high_school = basic_info[6].squeeze(" ")
      puts basic_info[6]

      p_ratings = []
      p_ratings << agent.page.search('table').search('tbody').search('tr.even')[0].search('td').map { |ff| ff.text.present? ? ff.text.gsub(/[\W]/, '') : 0 }

      scout = p_ratings[0][2].to_i
      rivals = p_ratings[0][3].to_i
      espn = p_ratings[0][4].to_i
      

      Player.where(name: name).update(committed_to: committed, height: height, high_school: high_school, grad_year: grad_year, st: state, verified: true )
      player = Player.find_by(name: name)

      if player.present?
        if player.grad_year.to_i > 2016
          player.update(current: true)
        else
          player.update(current: false)
        end

        if player.rating.present?
          player.rating.update(scout: scout, rivals: rivals, espn: espn)
        else
          player.create_rating(scout: scout, rivals: rivals, espn: espn)
        end
      end
      # player.create_skill if player.skill.nil?
      # player.stats.build

      puts count
      sleep rand(5)
    end
  end

  desc "scrape player offers"
  task offers: :environment do
    agent = Mechanize.new
    agent.get("https://n.rivals.com/prospect_rankings/rivals150/2017")
    count = 0
    puts "hello"
    agent.page.links_with(:href => %r{/content/}).each do |link|
      #next if link.text == "List"
      #puts link.text
      count += 1
      name = link.to_s
      
      puts name

      agent.click(link)
  
      #basics = agent.page.search('div.bio > p').text
      #puts basics
      #Player.where(name: name).first_or_create.update(committed_to: committed, height: height, high_school: high_school, grad_year: grad_year, st: state )
      #player = Player.find_by(name: name)
      #player.rating.update(scout: scout, rivals: rivals, espn: espn)
      puts count
      sleep rand(5)
    end
  end #end 5.times do
  end #end task commits
end #end scrape

