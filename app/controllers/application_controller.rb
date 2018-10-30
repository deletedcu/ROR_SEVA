class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_filter :store_current_location, :unless => :devise_controller?

  def prepare_meta_tags(options={})
    site_name   = "SEVA Sports"
    title       = [controller_name, action_name].join(" ")
    description = ""
    # image       = options[:image] || "your-default-image-url"
    current_url = request.url

    # Let's prepare a nice set of defaults
    defaults = {
      site:        "SEVA Sports",
      title:       "SEVA Sports",
      # image:       image,
      description: "SEVA statistically evaluates high school basketball players and projects what level players will excel at in the collegiate ranks. Think moneyball for college basketball recruiting.",
      keywords:    ["high school basketball", "high school basketball stats", "basektball stats", "basketball", "virginia basketball recruits", "byu basketball recruits", "high school basketball in-depth analytics", "statistical evaluations", "basketball analytics", "basketball moneyball"],
      twitter: {
        site_name: "SEVA Sports",
        site: '@sevasports',
        card: "SEVA statistically evaluates high school basketball players and projects what level players will excel at in the collegiate ranks. Think moneyball for college basketball recruiting.",
        description: "SEVA statistically evaluates high school basketball players and projects what level players will excel at in the collegiate ranks. Think moneyball for college basketball recruiting.",
        # image: image
      },
      og: {
        url: "http://sevasports.com",
        site_name: "SEVA Sports",
        title: "SEVA Sports",
        # image: image,
        description: "SEVA statistically evaluates high school basketball players and projects what level players will excel at in the collegiate ranks. Think moneyball for college basketball recruiting.",
        type: 'website'
      }
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end
	
	protected

	def configure_permitted_parameters
  	devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :seva_scout, :school])
  	devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :seva_scout,:school, :stripe_id, :stripe_subscription_id, 
  		:card_last4, :card_type, :card_exp_month, :card_exp_year])
	end

  def store_current_location
    store_location_for(:user, request.url)
  end

  def after_sign_in_path_for(resource)
    request.referrer || root_path
  end

	def current_user_subscribed?
		user_signed_in? && current_user.subscribed?
	end

	def current_user_seva_scout?
		user_signed_in? && current_user.subscribed? && current_user.seva_scout?
	end

	def set_player_scope
		session[:current] = params[:current]
	end

  

	helper_method :current_user_subscribed?
	helper_method :current_user_seva_scout?

	
end
