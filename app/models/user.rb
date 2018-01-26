class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #  devise :database_authenticatable
  # :registerable, :recoverable, :rememberable, :trackable, :validatable
  if Settings['cas_base_url'].present?
    devise :cas_authenticatable, :lockable, :trackable
  else
    devise :database_authenticatable, :lockable, :trackable
  end

  extend Enumerize
  enumerize :timezone, in: Scheduler::Lib::TIMEZONES

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

  def admin?
    # todo
    true
  end

  def title
    username
  end

  def status
    self.locked_at? ? "locked" : "active"
  end

  def status=(val)
    if val == "locked"
      self.locked_at ||= Time.now
    else
      self.locked_at = nil
    end
  end

  def lock!
    self.update_without_password(:locked_at => Time.now)
  end
  
  def unlock!
    self.update_without_password(:locked_at => nil)
  end
  
  def locked?
    self.locked_at?
  end

end
