namespace :trending do 
  desc "trending players"
  task players: :environment do
  	Player.where("impressions_count > ?", 1).each do |p|
		imp_count = p.impressions.select("DISTINCT session_hash").where("created_at > ?", 3.days.ago).count
		  if imp_count >= 1
		    p.weekly_impressions_count = imp_count
		    total_imps = p.impressions.select("DISTINCT session_hash").count
		    multiplier = (imp_count.to_f/total_imps.to_f) * 10
		    trend = p.weekly_impressions_count * multiplier
		    p.trending_rank = trend
		    p.save
		  end
		end
  end
end