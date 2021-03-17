class NamelistTable < ActiveRecord::Migration[6.1]
  def change
    create_table :names do |t|
      t.string :name
      t.text :description
      t.integer :user_id
    end
  end
end
