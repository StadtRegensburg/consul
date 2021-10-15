module DeficiencyReportsHelper
  def css_for_deficiency_report_info_row(dr)
    if dr.image.present?
      "small-12 medium-6 large-7 column"
    else
      "small-12 medium-9 column"
    end
  end

  def all_deficiency_report_map_locations(deficiency_reports_for_map)
    ids = deficiency_reports_for_map.except(:limit, :offset, :order).pluck(:id).uniq

    MapLocation.where(deficiency_report_id: ids).map(&:json_data)
  end

  def json_data
    deficiency_report = DeficiencyReport.find(params[:id])
    data = {
      deficiency_report_id: deficiency_report.id,
      deficiency_report_title: deficiency_report.title
    }.to_json

    respond_to do |format|
      format.json { render json: data }
    end
  end

  def show_official_reply_form?(deficiency_report)
    return false unless current_user.present?

    return true if current_user.administrator?

    if Setting["deficiency_reports.admins_must_assign_officer"]
      current_user.deficiency_report_officer? &&
        current_user == deficiency_report.officer
    else
      current_user.deficiency_report_officer?
    end
  end
end
