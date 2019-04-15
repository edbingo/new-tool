class Presentation < ApplicationRecord
  include Resetable
  serialize :visit

end
