class CreateDeficiencyReports < ActiveRecord::Migration[5.2]
  def change
    create_table :deficiency_reports do |t|
      t.integer :author_id
      t.integer :status, default: 0
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        DeficiencyReport.create_translation_table! :title => :string, :description => :text
      end

      dir.down do
        DeficiencyReport.drop_translation_table!
      end
    end
  end
end
