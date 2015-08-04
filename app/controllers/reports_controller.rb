require 'csv'

class ReportsController < BaseController

  before_action :require_user_acc
  before_action :load_election

  def events_by_county
    @report = EventsByCountyReport.new(@election)
    html_or_csv_response
  end

  def events_by_county_by_demog
    @report = EventsByCountyByDemogReport.new(@election)
    html_or_csv_response
  end

  def events_by_locality
    @report = EventsByLocalityReport.new(@election)
    html_or_csv_response
  end

  def events_by_locality_by_uocava
    @report = EventsByLocalityByUocavaReport.new(@election)
    html_or_csv_response
  end

  def events_by_locality_by_gender
    @report = EventsByLocalityByGenderReport.new(@election)
    html_or_csv_response
  end

  private

  def load_election
    @election = Election.where(account: current_account).find(params[:election_id])
  end

  def jurisdiction_report_csv(report)
    return CSV.generate do |c|
      c << [ "Jurisdiction" ] + report.columns

      if report.respond_to?(:totals_row)
        totals = report.totals_row
        c << [ "Totals" ] + report.columns.map { |co| totals[co] }
      end

      report.rows.each do |county, values|
        c << [ county ] + report.columns.map { |co| values[co] }
      end
    end
  end

  def html_or_csv_response
    respond_to do |format|
      format.html
      format.csv do
        csv = jurisdiction_report_csv(@report)
        send_csv csv, "#{params[:action]}.csv"
      end
    end
  end

end
