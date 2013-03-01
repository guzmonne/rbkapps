class CreateFormHelpers < ActiveRecord::Migration
  def change
    create_table :form_helpers do |t|
      t.string :field
      t.string :value

      t.timestamps
    end
  end
end
