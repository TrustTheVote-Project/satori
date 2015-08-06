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
    end

    @columns.sort!
  end

end
