class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title
      t.text :description
      t.string :url      
      t.integer :point, default: 0
      t.string :user_id, :null => false, index: true
      t.timestamps
    end
  end
end
