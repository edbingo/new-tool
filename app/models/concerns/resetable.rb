module Resetable
  extend ActiveSupport::Concern
  class_methods do # Deletes everything from the database and seeds in standard values
    def truncate!
      self.connection.execute(
        "Delete from #{ self.table_name };"
      )
    end
  end
end
