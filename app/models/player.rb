class Player < ActiveRecord::Base
  extend FriendlyId

  # after_save :seva_score_update
  # after_save :skill_score
  # after_save :update_current

  is_impressionable counter_cache: true, unique: true

  has_many :stats, -> {order("season ASC")}, dependent: :destroy
  has_many :similars, dependent: :destroy
  has_one :rating, dependent: :destroy
  has_one :skill, dependent: :destroy

  accepts_nested_attributes_for :stats, reject_if: :stats_rejectable?, allow_destroy: true
  accepts_nested_attributes_for :similars, reject_if: :similars_rejectable?, allow_destroy: true
  accepts_nested_attributes_for :rating, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :skill, reject_if: :all_blank, allow_destroy: true

  scope :keyword, -> (keyword) { where("name ILIKE ? or high_school ILIKE ? or committed_to ILIKE ?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%")}
  scope :high_school, -> (high_school) { where("high_school like ?", "%#{high_school}%")}
  scope :committed_to, -> (committed_to) { where("committed_to like ?", "%#{committed_to}%")}
  scope :current_players, -> (current_p) {where(current: current_p)}

  
  friendly_id :slug_candidates, use: :slugged

  def seva_score_update
    #class
    if stats.season_order.first.season == "Freshman"
      season = 0.06089
      classppg = (stats.first.ppg * 0.07687)
    elsif stats.season_order.first.season == "Sophomore"
      season = -0.01314
      classppg = (stats.first.ppg * 0.00770)
    elsif stats.season_order.first.season == "Junior"
      season = -0.05097
      classppg = (stats.first.ppg * -0.00864)
    else
      season = -0.08014
      classppg = (stats.first.ppg * -0.00166)
    end


    #classification
    if school_class == "b" 
      division = 0.96688
    elsif school_class == "i"
      division = 0.86522
    elsif school_class == "ii"
      division = 0.45861
    elsif school_class == "iii"
      division = -0.81900
    elsif school_class == "iv"
      division = -1.10243
    else
      division = -1.36949
    end

    #school size
    if st == "CA" || st == "TX" || st == "FL" || st == "NY" || st == "IL" || st == "PA" || st == "OH" || st == "GA" || st == "NC" || st == "MI" || st == "NJ" || st == "AZ" 
      school_size = 0.08246
    elsif st == "TN" || st == "MO" || st == "MD" || st == "WI" || st == "MN" || st == "CO" || st == "SC" || st == "AL" || st == "KY" || st == "OR" || st == "OK" || st == "UT"
      school_size = 0.05977
    elsif st == "IA" || st == "MS" || st == "AR" || st == "NV" || st == "NM" || st == "NE" || st == "WV" || st == "ID" || st == "HI" || st == "NH" || st == "ME" || st == "RI" || st == "MT"
      school_size = -0.11136
    else
      school_size = -0.46909
    end

    final_score = ((season + division + school_size + (stats.season_order.first.ppg.to_f * 0.19410) + (stats.season_order.first.apg.to_f * 0.00883) + (stats.season_order.first.rpg.to_f * 0.00889) + (stats.season_order.first.bpg.to_f * 0.22732) +
     (stats.season_order.first.spg.to_f * 0.02262) + (stats.season_order.first.fg.to_f * 0.00165) + (stats.season_order.first.winp.to_f * 0.02993) + (height.to_f * 0.09516) + classppg) - 8.0)

    if final_score >= 9.7
      final_score = 9.7
    elsif final_score <= 0.5
      final_score = 0.5
    end

    self.stats.season_order.first.update_column(:seva_score, final_score)

  end

  def skill_score

    #winp
    if self.stats.season_order.first.winp.to_i >= 78
      seva_win = 8.4
    elsif self.stats.season_order.first.winp.to_i >= 75
      seva_win = 6.4
    elsif self.stats.season_order.first.winp.to_i >= 71
      seva_win = 4.3
    elsif self.stats.season_order.first.winp.to_i >= 67
      seva_win = 2.4
    elsif self.stats.season_order.first.winp.to_i >= 50
      seva_win = 1.7
    else
      seva_win = 0.8
    end

    #ppg
    if self.stats.season_order.first.ppg >= 18.8
      seva_ppg = 8.4
    elsif self.stats.season_order.first.ppg >= 15.7
      seva_ppg = 6.4
    elsif self.stats.season_order.first.ppg >= 14.8
      seva_ppg = 4.3
    elsif self.stats.season_order.first.ppg >= 13.8
      seva_ppg = 2.4
    elsif self.stats.season_order.first.ppg >= 5.1
      seva_ppg = 1.7
    else
      seva_ppg = 0.8
    end

    #seperate by position
    if self.height.to_i < 75

      #fg
      if self.stats.season_order.first.fg.present? 
        if self.stats.season_order.first.fg >= 46
          seva_fg = 8.4
        elsif self.stats.season_order.first.fg >= 45
          seva_fg = 6.4
        elsif self.stats.season_order.first.fg >= 44
          seva_fg = 4.3
        elsif self.stats.season_order.first.fg >= 42
          seva_fg = 2.4
        elsif self.stats.season_order.first.fg >= 40
          seva_fg = 1.7
        else
          seva_fg = 0.8
        end
      end

      #apg
      if self.stats.season_order.first.apg >= 4.3
        seva_apg = 8.4
      elsif self.stats.season_order.first.apg >= 3.3
        seva_apg = 6.4
      elsif self.stats.season_order.first.apg >= 3
        seva_apg = 4.3
      elsif self.stats.season_order.first.apg >= 2.3
        seva_apg = 2.4
      elsif self.stats.season_order.first.apg >= 1.6
        seva_apg = 1.7
      else
        seva_apg = 0.8
      end

      #bpg
      if self.stats.season_order.first.bpg.present?
        if self.stats.season_order.first.bpg >= 0.6
          seva_bpg = 8.4
        elsif self.stats.season_order.first.bpg >= 0.45
          seva_bpg = 6.4
        elsif self.stats.season_order.first.bpg >= 0.32
          seva_bpg = 4.3
        elsif self.stats.season_order.first.bpg >= 0.18
          seva_bpg = 2.4
        elsif self.stats.season_order.first.bpg >= 0.1
          seva_bpg = 1.7
        else
          seva_bpg = 0.8
        end
      end

      #rpg
      if self.stats.season_order.first.rpg >= 4.5
        seva_rpg = 8.4
      elsif self.stats.season_order.first.rpg >= 3.7
        seva_rpg = 6.4
      elsif self.stats.season_order.first.rpg >= 3.1
        seva_rpg = 4.3
      elsif self.stats.season_order.first.rpg >= 2.9
        seva_rpg = 2.4
      elsif self.stats.season_order.first.rpg >= 1.9
        seva_rpg = 1.7
      else
        seva_rpg = 0.8
      end

      #spg 
      if self.stats.season_order.first.spg.present?
        if self.stats.season_order.first.spg >= 2.2
          seva_spg = 8.4
        elsif self.stats.season_order.first.spg >= 1.9
          seva_spg = 6.4
        elsif self.stats.season_order.first.spg >= 1.6
          seva_spg = 4.3
        elsif self.stats.season_order.first.spg >= 1.4
          seva_spg = 2.4
        elsif self.stats.season_order.first.spg >= 1
          seva_spg = 1.7
        else
          seva_spg = 0.8
        end 
      end
    elsif self.height.to_i >= 75 && self.height.to_i < 80

      #fg
      if self.stats.season_order.first.fg.present? 
        if self.stats.season_order.first.fg >= 50
          seva_fg = 8.4
        elsif self.stats.season_order.first.fg >= 48
          seva_fg = 6.4
        elsif self.stats.season_order.first.fg >= 46
          seva_fg = 4.3
        elsif self.stats.season_order.first.fg >= 45
          seva_fg = 2.4
        elsif self.stats.season_order.first.fg >= 42
          seva_fg = 1.7
        else
          seva_fg = 0.8
        end
      end

      #apg
      if self.stats.season_order.first.apg >= 3.9
        seva_apg = 8.4
      elsif self.stats.season_order.first.apg >= 2.9
        seva_apg = 6.4
      elsif self.stats.season_order.first.apg >= 2.2
        seva_apg = 4.3
      elsif self.stats.season_order.first.apg >= 2
        seva_apg = 2.4
      elsif self.stats.season_order.first.apg >= 1.6
        seva_apg = 1.7
      else
        seva_apg = 0.8
      end

      #bpg
      if self.stats.season_order.first.bpg.present?
        if self.stats.season_order.first.bpg >= 1.3
          seva_bpg = 8.4
        elsif self.stats.season_order.first.bpg >= 1.1
          seva_bpg = 6.4
        elsif self.stats.season_order.first.bpg >= 1
          seva_bpg = 4.3
        elsif self.stats.season_order.first.bpg >= 0.9
          seva_bpg = 2.4
        elsif self.stats.season_order.first.bpg >= 0.8
          seva_bpg = 1.7
        else
          seva_bpg = 0.8
        end
      end

      #rpg 
      if self.stats.season_order.first.rpg >= 7.8
        seva_rpg = 8.4
      elsif self.stats.season_order.first.rpg >= 7.1
        seva_rpg = 6.4
      elsif self.stats.season_order.first.rpg >= 6.9
        seva_rpg = 4.3
      elsif self.stats.season_order.first.rpg >= 5.7
        seva_rpg = 2.4
      elsif self.stats.season_order.first.rpg >= 4
        seva_rpg = 1.7
      else
        seva_rpg = 0.8
      end

      #spg
      if self.stats.season_order.first.spg.present?
        if self.stats.season_order.first.spg >= 1.9
          seva_spg = 8.4
        elsif self.stats.season_order.first.spg >= 1.7
          seva_spg = 6.4
        elsif self.stats.season_order.first.spg >= 1.7
          seva_spg = 4.3
        elsif self.stats.season_order.first.spg >= 1.3
          seva_spg = 2.4
        elsif self.stats.season_order.first.spg >= 1
          seva_spg = 1.7
        else
          seva_spg = 0.8
        end
      end
    elsif self.height.to_i >= 80

      #fg
      if self.stats.season_order.first.fg.present? 
        if self.stats.season_order.first.fg >= 55
          seva_fg = 8.4
        elsif self.stats.season_order.first.fg >= 52
          seva_fg = 6.4
        elsif self.stats.season_order.first.fg >= 50
          seva_fg = 4.3
        elsif self.stats.season_order.first.fg >= 47
          seva_fg = 2.4
        elsif self.stats.season_order.first.fg >= 44
          seva_fg = 1.7
        else
          seva_fg = 0.8
        end
      end

      #apg
      if self.stats.season_order.first.apg >= 3
        seva_apg = 8.4
      elsif self.stats.season_order.first.apg >= 2
        seva_apg = 6.4
      elsif self.stats.season_order.first.apg >= 1.6
        seva_apg = 4.3
      elsif self.stats.season_order.first.apg >= 1
        seva_apg = 2.4
      elsif self.stats.season_order.first.apg >= 0.8
        seva_apg = 1.7
      else
        seva_apg = 0.8
      end 

      #bpg
      if self.stats.season_order.first.bpg.present?
        if self.stats.season_order.first.bpg >= 3.8
          seva_bpg = 8.4
        elsif self.stats.season_order.first.bpg >= 3.3
          seva_bpg = 6.4
        elsif self.stats.season_order.first.bpg >= 2.8
          seva_bpg = 4.3
        elsif self.stats.season_order.first.bpg >= 2.2
          seva_bpg = 2.4
        elsif self.stats.season_order.first.bpg >= 1.7
          seva_bpg = 1.7
        else
          seva_bpg = 0.8
        end
      end

      #rpg 
      if self.stats.season_order.first.rpg >= 10.1
        seva_rpg = 8.4
      elsif self.stats.season_order.first.rpg >= 9.4
        seva_rpg = 6.4
      elsif self.stats.season_order.first.rpg >= 8.6
        seva_rpg = 4.3
      elsif self.stats.season_order.first.rpg >= 7.7
        seva_rpg = 2.4
      elsif self.stats.season_order.first.rpg >= 5.8
        seva_rpg = 1.7
      else
        seva_rpg = 0.8
      end

      #spg
      if self.stats.season_order.first.spg.present?
        if self.stats.season_order.first.spg >= 1.8
          seva_spg = 8.4
        elsif self.stats.season_order.first.spg >= 0.9
          seva_spg = 6.4
        elsif self.stats.season_order.first.spg >= 0.7
          seva_spg = 4.3
        elsif self.stats.season_order.first.spg >= 0.5
          seva_spg = 2.4
        elsif self.stats.season_order.first.spg >= 0.3
          seva_spg = 1.7
        else
          seva_spg = 0.8
        end     
      end
    end
      


    if self.skill.blank?
      self.create_skill(seva_win: seva_win, seva_ppg: seva_ppg, seva_apg: seva_apg, seva_rpg: seva_rpg, seva_spg: seva_spg, seva_bpg: seva_bpg, seva_fg: seva_fg)
    else
      self.skill.update_columns(seva_win: seva_win, seva_ppg: seva_ppg, seva_apg: seva_apg, seva_rpg: seva_rpg, seva_spg: seva_spg, seva_bpg: seva_bpg, seva_fg: seva_fg)
    end

  end


  def update_current
    if self.grad_year.present?
      if self.grad_year.to_i >= 2017
        player_current = true
      else
        player_current = false
      end

      self.update_attribute(:current, player_current)
    end
  end


  def stats_rejectable?(att)
    att['ppg'] == "0.0"
  end

  def similars_rejectable?(att)
    att['name'].blank?
  end

  def slug_candidates
    [
      :name,
      [:name, :high_school]
    ]
  end

  def recent_season
    stats.first
  end

  def self.to_csv
    player_attributes = %w{name high_school st committed_to high_school height grad_year current}
    stat_attributes = %w{season games_played year ppg rpg apg bpg spg fg winp}
    rating_attributes = %w{seva_score espn rivals scout}
    blank_ratings = %w{0 0 0 0}
    blank_stats = %w{0 0 0 0 0 0 0 0 0 0}
    CSV.generate(headers: true) do |csv|
      csv << player_attributes + rating_attributes + stat_attributes 

      all.each do |player|
        player_info = {}
        rating = {}
        stats = {}

        player_info = player.attributes.values_at(*player_attributes)

        if player.rating.present?
          rating = player.rating.attributes.values_at(*rating_attributes)
        else
          rating = blank_ratings
        end

        if player.stats.first.present?
          stats = player.stats.first.attributes.values_at(*stat_attributes)
        else
          stats = blank_stats
        end

        csv << player_info + rating + stats
      end
    end
  end

end
