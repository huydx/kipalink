class AddParentIdToLinkComments < ActiveRecord::Migration
  def change
    add_column :link_comments, :parent_id, :integer
  end
end
