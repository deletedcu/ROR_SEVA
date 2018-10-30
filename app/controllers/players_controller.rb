class PlayersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :current_user_subscribed?

  def index

    set_meta_tags title: "SEVA Sports"
    set_meta_tags description: "SEVA uses advanced analytics to evaluate and project high school basketball players. Our goal is to be your statistical perspective and give you a different lens to see high school basketball recruits through."
    set_meta_tags keywords: ["high school basketball", "high school basketball stats", "basektball stats", "basketball", "virginia basketball recruits", "byu basketball recruits", "high school basketball in-depth analytics", "statistical evaluations", "basketball analytics", "basketball moneyball", "kentucky basketball", "kansas basketball"]


  
    if params[:search].present?
      @players = Player.where("name ILIKE ?", "%#{params[:search]}%").paginate(:page => params[:page], :per_page => 30)
      respond_to do |format|  
        format.js
      end
    elsif params[:class].present?
      @players = Player.where(grad_year: "#{params[:class]}").paginate(page: params[:page], per_page: 30)
    else
      @players = Player.current_players(true).includes(:stats).paginate(:page => params[:page], :per_page => 30)
    end
 end

  # def current_past
  #   session[:current] = params[:current]
  #   redirect_to :back
  # end

  def new
    @player = Player.new
    @player.build_rating
    @player.build_skill
    @player.stats.build
    @player.similars.build
  end

  def create
    @player = Player.new player_params

    if @player.save
      redirect_to @player, notice: "#{@player.name} was created successfully"
    else
      render action: :new, notice: "shiz, try again."
    end
  end

  def show
    @player = Player.friendly.find(params[:id])
    impressionist(@player, unique: [:session_hash])

     set_meta_tags title: "#{@player.name} | SEVA"
     set_meta_tags description: "#{@player.name}'s high school basketball stats, SEVA Score, and evaluation."
     set_meta_tags keywords: ["#{@player.name}", "#{@player.name} SEVA", "#{@player.name} stats", "#{@player.name} basketball", "#{@player.name} high school basketball stats","#{@player.name} college recruiting", "#{@player.name} #{@player.committed_to}", "#{@player.high_school}", "#{@player.name} #{@player.high_school}", "#{@player.name} recruiting", "#{@player.name} rivals", "#{@player.name} scout", "#{@player.name} 247", "#{@player.name} maxpreps"]
  
  end

  def edit
    @player = Player.friendly.find(params[:id])
    @player.create_rating if @player.rating.nil?
    @player.create_skill if @player.skill.nil?
    @player.stats.build

  end

  def update
    @player = Player.friendly.find(params[:id])
    if @player.update_attributes(player_params)
      redirect_to @player, notice: "#{@player.name} was successfully updated :)"
    else
      render action: :edit, notice: "Brick... try again."
    end
  end

  def destroy
    @player = Player.friendly.find(params[:id])
    @player.stats.destroy
    if @player.destroy
      redirect_to players_path, notice: "#{@player.name} was destroyed"
    else
      redirect_to :back, notice: "Ankles not broken."
    end
  end

  private

  def player_params
    params.require(:player).permit(:id, :name, :st, :height, :risk_score, :position, :style, :school_class,:current, :committed_to, :grad_year, :high_school, :verified, :last_edited_by, :submitted_by, :weekly_impressions_count, :trending_rank, rating_attributes: [:id, :espn, :scout, :rivals, :_destroy], 
      stats_attributes: [:id, :ppg, :apg, :rpg, :bpg, :spg, :fg, :winp, :season, :year, :seva_score, :games_played, :_destroy], similars_attributes: [:id, :player_id, :similar_id, :_destroy], skill_attributes: [:id, :seva_ppg, :seva_apg, :seva_rpg, :seva_bpg, :seva_spg, :seva_fg, :seva_win, :_destroy])
  end

end
