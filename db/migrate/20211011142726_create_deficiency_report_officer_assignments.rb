class CreateDeficiencyReportOfficerAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :deficiency_report_officer_assignments do |t|
      t.references :deficiency_report, foreign_key: true, index: { name: :index_dr_officer_assignments_on_dr_id }
      t.references :deficiency_report_officer, foreign_key: true, index: { name: :index_dr_officer_assignments_on_dr_officer_id }

      t.timestamps
    end
  end
end
