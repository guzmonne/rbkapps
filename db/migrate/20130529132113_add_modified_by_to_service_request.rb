class AddModifiedByToServiceRequest < ActiveRecord::Migration
  def change
    add_column :service_requests, :mofified_by, :integer
  end
end
