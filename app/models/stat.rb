class Stat < ActiveRecord::Base
	belongs_to :player

	enum season: [:Senior, :Junior, :Sophomore, :Freshman]
	scope :season_order, -> { order(season: :asc) }
end
