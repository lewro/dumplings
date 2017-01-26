class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

        # LOG: Roman
        # I have removed this part
        # :registerable,

  validates :email, :uniqueness => true

  def full_name
   "#{first_name} #{last_name}"
  end

end
