class ChangeFieldForTypeInFormHelpers < ActiveRecord::Migration
  def up
    remove_column :form_helpers, :field
    add_column  :form_helpers, :column, :string
  end

  def down
    remove_column :form_helpers, :column
    add_column  :form_helpers, :field, :string
  end
end
