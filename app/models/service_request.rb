class ServiceRequest < ActiveRecord::Base
  attr_accessible        :status,
                         :priority,
                         :solution,
                         :closed_at,
                         :category_id,
                         :title,
                         :description,
                         :asigned_to_id,
                         :location,
                         :creator_id,
                         :modified_by
end
