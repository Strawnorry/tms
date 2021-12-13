ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_many :histories
    has_secure_password
end

class History < ActiveRecord::Base
    belongs_to :user 
end