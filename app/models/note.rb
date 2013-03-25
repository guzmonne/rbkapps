class Note < ActiveRecord::Base
  attr_accessible :table_name,
                  :table_name_id,
                  :user_id,
                  :content
end
