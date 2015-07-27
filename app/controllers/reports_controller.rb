require 'csv'

class ReportsController < BaseController

  before_action :require_user_acc
  before_action :load_election

  def events_by_county
    @report = EventsByCountyReport.new(@election.records.select("jurisdiction, action, form, count(*) as cnt").group("jurisdiction, action, form"))

    respond_to do |format|
      format.html
      format.csv do
        csv = jurisdiction_report_csv(@report)
        send_csv csv, "events_by_county.csv"
      end
    end
  end

  def events_by_county_by_demog
    @report = EventsByCountyByDemogReport.new(@election)

    respond_to do |format|
      format.html
      format.csv do
        csv = jurisdiction_report_csv(@report)
        send_csv csv, "events_by_county_by_demographics.csv"
      end
    end
  end

  private

  def load_election
    @election = Election.where(account: current_account).find(params[:election_id])
  end

  def jurisdiction_report_csv(report)
    return CSV.generate do |c|
      c << [ "Jurisdiction" ] + report.columns

      report.rows.each do |county, values|
        c << [ county ] + report.columns.map { |co| values[co] }
      end
    end
  end

end
