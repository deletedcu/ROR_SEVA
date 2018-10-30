class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:new]
	before_action :redirect_to_sign_up, only: [:new]
	

	def new
	end

	def create
    customer = if current_user.stripe_id?
                 Stripe::Customer.retrieve(current_user.stripe_id)
               else
                 Stripe::Customer.create(email: current_user.email)
               end

    subscription = customer.subscriptions.create(
      source: params[:stripeToken],
      plan: "1"
    )

    options = {
      stripe_id: customer.id,
      stripe_subscription_id: subscription.id,
    }

    # Only update the card on file if we're adding a new one
    options.merge!(
      card_last4: params[:card_last4],
      card_exp_month: params[:card_exp_month],
      card_exp_year: params[:card_exp_year],
      card_type: params[:card_brand]
    ) if params[:card_last4]

    if current_user.update(options)
			redirect_to root_path, notice: "Welcome, you've successfully subscribed to SEVA."
		else
			redirect_to root_path, notice: "Hmmm, something went wrong."
		end
	end

	private

	def redirect_to_sign_up
		if !user_signed_in?
			session["user_return_to"] = new_subscription_path
			redirect_to new_user_registration_path
		end
	end
end