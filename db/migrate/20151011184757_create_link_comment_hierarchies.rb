class CreateLinkCommentHierarchies < ActiveRecord::Migration
  def change
    create_table :link_comment_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :link_comment_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "link_comment_anc_desc_idx"

    add_index :link_comment_hierarchies, [:descendant_id],
      name: "link_comment_desc_idx"
  end
end
