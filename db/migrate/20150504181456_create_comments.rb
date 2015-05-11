class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.references :commentable, polymorphic: true
      t.references :user, index: true

      t.timestamps null: false
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
