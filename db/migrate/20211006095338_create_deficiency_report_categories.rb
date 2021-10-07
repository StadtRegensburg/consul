class CreateDeficiencyReportCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :deficiency_report_categories do |t|
      t.string :name
      t.string :color
      t.string :icon

      t.timestamps
    end
  end
end
