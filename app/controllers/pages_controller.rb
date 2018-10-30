class PagesController < ApplicationController
  
  def home
    @user = User.new
    @players = Player.current_players(true).includes(:stats).distinct("stats.season_order.first").order("stats.seva_score DESC").limit(5)
   
  end

  def about_us
  	set_meta_tags title: "About SEVA"
    set_meta_tags description: "The SEVA Score is a 1-10 score that ranks high school players based off of their stats, physical traits, state, and league."
    set_meta_tags keywords: ["SEVA Score", "high school basketball stats", "basektball stats", "basketball", "virginia basketball recruits", "byu basketball recruits", "high school basketball in-depth analytics", "statistical evaluations", "basketball analytics", "basketball moneyball"]
  	
  end


  def seva_score
  	set_meta_tags title: "SEVA Score"
    set_meta_tags description: "The SEVA Score is a 1-10 score that ranks high school players based off of their stats, physical traits, state, and league."
    set_meta_tags keywords: ["SEVA Score", "high school basketball stats", "basektball stats", "basketball", "virginia basketball recruits", "byu basketball recruits", "high school basketball in-depth analytics", "statistical evaluations", "basketball analytics", "basketball moneyball"]

  end

  def pricing
    set_meta_tags title: "SEVA Pricing"
    set_meta_tags description: "The SEVA Score is a 1-10 score that ranks high school players based off of their stats, physical traits, state, and league."
    set_meta_tags keywords: ["SEVA Score", "high school basketball stats", "basektball stats", "basketball", "virginia basketball recruits", "byu basketball recruits", "high school basketball in-depth analytics", "statistical evaluations", "basketball analytics", "basketball moneyball"]

  end

  def faq
  	set_meta_tags title: "FAQ"
    set_meta_tags description: "Frequenty asked questions about SEVA and the SEVA Score."
    set_meta_tags keywords: ["SEVA Score", "high school basketball stats", "basektball stats", "basketball", "virginia basketball recruits", "byu basketball recruits", "high school basketball in-depth analytics", "statistical evaluations", "basketball analytics", "basketball moneyball"]
  	
  end

  def terms
  	set_meta_tags title: "TERMS & CONDITIONS"
    set_meta_tags description: "SEVA's terms and conditions"
    set_meta_tags keywords: ["SEVA Score", "high school basketball stats", "basektball stats", "basketball", "virginia basketball recruits", "byu basketball recruits", "high school basketball in-depth analytics", "statistical evaluations", "basketball analytics", "basketball moneyball"]
  
  end

  def privacy
  	set_meta_tags title: "PRIVACY"
    set_meta_tags description: "SEVA's privacy policy."
    set_meta_tags keywords: ["SEVA Score", "high school basketball stats", "basektball stats", "basketball", "virginia basketball recruits", "byu basketball recruits", "high school basketball in-depth analytics", "statistical evaluations", "basketball analytics", "basketball moneyball"]

  end
  
end
