ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
end