class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|

      t.timestamps
      t.integer :follower_id
      t.integer :followed_id
    end
  end
end
