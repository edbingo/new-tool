class Student < ApplicationRecord
  include Resetable
  require "csv"
  require 'active_support'
  has_secure_password
end
