module ApplicationHelper

  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_class
    devise_mapping.to
  end

  def points_per_game(player)
    if player.stats.season_order.first.ppg.present? && player.skill.seva_ppg >= 8.4
      content_tag :td, player.stats.season_order.first.ppg, class: ['great', 'center', 'hide-column']
    elsif player.stats.season_order.first.ppg.present? && player.skill.seva_ppg >= 6.4
      content_tag :td, player.stats.season_order.first.ppg, class: ['good', 'center', 'hide-column']
    elsif player.stats.season_order.first.ppg.present? && player.skill.seva_ppg >= 4.3
      content_tag :td, player.stats.season_order.first.ppg, class: ['ok', 'center', 'hide-column']
    else     
      content_tag :td, player.stats.season_order.first.ppg, class: ['not-good', 'center', 'hide-column']
    end
  end

  def assists_per_game(player)
    if player.stats.season_order.first.apg.present? && player.skill.seva_apg >= 8.4
      content_tag :td, player.stats.season_order.first.apg, class: ['great', 'center', 'hide-column']
    elsif player.stats.season_order.first.apg.present? && player.skill.seva_apg >= 6.4
      content_tag :td, player.stats.season_order.first.apg, class: ['good', 'center', 'hide-column']
    elsif player.stats.season_order.first.apg.present? && player.skill.seva_apg >= 4.3
      content_tag :td, player.stats.season_order.first.apg, class: ['ok', 'center', 'hide-column']
    else     
      content_tag :td, player.stats.season_order.first.apg, class: ['not-good', 'center', 'hide-column']
    end
  end


  def rebounds_per_game(player)
    if player.stats.season_order.first.rpg.present? && player.skill.seva_rpg >= 8.4
      content_tag :td, player.stats.season_order.first.rpg, class: ['great', 'center', 'hide-column']
    elsif player.stats.season_order.first.rpg.present? && player.skill.seva_rpg >= 6.4
      content_tag :td, player.stats.season_order.first.rpg, class: ['good', 'center', 'hide-column']
    elsif player.stats.season_order.first.rpg.present? && player.skill.seva_rpg >= 4.3
      content_tag :td, player.stats.season_order.first.rpg, class: ['ok', 'center', 'hide-column']
    else     
      content_tag :td, player.stats.season_order.first.rpg, class: ['not-good', 'center', 'hide-column']
    end
  end

  def height(player)
      feet = player.height.to_i / 12
      inches = player.height.to_i % 12
      content_tag :td, "#{feet}'#{inches}", class: ['center', 't-border']
  end
	
end
