json.players @players do |player|
	json.id player.id
	json.name player.name
	json.state player.st
	json.height player.height
	json.high_school player.high_school
	json.committed_to player.committed_to
	json.position player.position
	json.grad_year player.grad_year
	json.school_class player.school_class
	
	json.stats player.stats do |stat|
		json.season stat.season
		json.games_played stat.games_played
		json.seva_score stat.seva_score
		json.ppg stat.ppg
		json.rpg stat.rpg
		json.apg stat.apg
		json.bpg stat.bpg
		json.spg stat.spg
		json.fg stat.fg
		json.winp stat.winp
		json.hs_level stat.hs_level
		json.year stat.year
	end
end
