class CorrectModifiedByToServiceRequest < ActiveRecord::Migration
  def up
    remove_column :service_requests, :mofified_by
    add_column :service_requests, :modified_by, :integer
  end

  def down
    remove_column :service_requests, :modified_by
    add_column :service_requests, :mofified_by, :integer
  end
end
