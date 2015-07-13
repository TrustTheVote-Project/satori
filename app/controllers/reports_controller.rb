require 'csv'

class ReportsController < BaseController

  before_action :require_user_acc
  before_action :load_election

  def events_by_county
    @report = EventsByCountyReport.new(@election.records.select("jurisdiction, action, form, count(*) as cnt").group("jurisdiction, action, form"))

    respond_to do |format|
      format.html
      format.csv do
        csv = CSV.generate do |c|
          c << @report.columns.unshift("Jurisdiction")

          @report.rows.each do |county, values|
            c << @report.columns.map { |co| values[co] }.unshift(county)
          end
        end

        render text: csv
      end
    end
  end

  private

  def load_election
    @election = Election.where(account: current_account).find(params[:election_id])
  end

end
