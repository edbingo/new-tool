class Student < ApplicationRecord
  include Resetable
  require "csv"
  require 'active_support'
  serialize :select
  has_secure_password
end
