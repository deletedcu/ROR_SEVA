class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def subscribed?
  	stripe_subscription_id?
  end

  def name
  	"#{first_name} #{last_name.chars.first}"
  end
end
