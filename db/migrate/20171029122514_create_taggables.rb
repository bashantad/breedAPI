class CreateTaggables < ActiveRecord::Migration[5.0]
  def change
    create_table :taggables do |t|
      t.references :tag, foreign_key: true
      t.references :breed, foreign_key: true

      t.timestamps
    end
  end
end
