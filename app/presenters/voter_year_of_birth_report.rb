class VoterYearOfBirthReport < BaseReport

  def initialize(election)
    super()

    Reports::VotersBirthDecade.where(election_id: election.id).each do |r|
      j = r.jurisdiction
      d = r.decade
      k = "#{d}1-#{d+1}0"

      @columns << k unless @columns.include?(k)

      cdata = @rows[j] || {}
      cdata[k] = r.cnt
      @rows[j] = cdata

      @totals_row[k] = (@totals_row[k] || 0) + r.cnt
    end

    @columns.sort!
  end

  def initial_columns
    start_year = 1901
    last_year  = Date.today.year - 17
    last_decade = (last_year / 10.0).ceil * 10 + 1

    decades = (last_decade - start_year) / 10

    decades.times.map do |i|
      y = start_year + i * 10
      "#{y}-#{y + 9}"
    end
  end

end
