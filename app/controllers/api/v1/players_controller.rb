class Api::V1::PlayersController < ApiController
	def index
		@players = Player.all
	end
end