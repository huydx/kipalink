class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.belongs_to :link, index: true
      t.string :user_id, :null => false, index: true
      t.timestamps
    end
  end
end
