class CreateRepositoryChecks < ActiveRecord::Migration[7.2]
  def change
    create_table :repository_checks do |t|
      t.references :repository, null: false, foreign_key: true, index: true
      t.string :commit_id
      t.boolean :passed, default: false
      t.integer :offenses_count, default: 0

      t.timestamps
    end
  end
end
