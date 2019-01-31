class Admin < ApplicationRecord
  include Resetable
  has_secure_password
end
