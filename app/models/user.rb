class User < ApplicationRecord
    has_secure_password
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, length: {minimum: 6}, allow_blank: true

    def setAdmin
      update(admin: true)
    end

    def removeAdmin
      update(admin: false)
    end
end
