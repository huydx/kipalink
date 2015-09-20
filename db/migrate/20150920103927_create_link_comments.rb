class CreateLinkComments < ActiveRecord::Migration
  def change
    create_table :link_comments do |t|
      t.text :content
      t.integer :point, default: 0
      t.belongs_to :link, index: true
      t.string :user_id, :null => false, index: true
      t.timestamps
    end
  end
end
