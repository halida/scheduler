class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #  devise :database_authenticatable
  # :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :cas_authenticatable

  def cas_extra_attributes=(extra_attributes)
    extra_attributes.each do |name, value|
      case name.to_sym
      when :fullname
        self.fullname = value
      when :email
        self.email = value
      end
    end
  end

end
