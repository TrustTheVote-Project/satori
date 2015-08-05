class VoterYearOfBirthReport

  def initialize(election)
    @columns  = []
    @counties = {}

    Reports::VotersBirthDecade.where(election_id: election.id).each do |r|
      j = r.jurisdiction
      d = r.decade
      k = "#{d}1-#{d+1}0"

      @columns << k unless @columns.include?(k)

      cdata = @counties[j] || {}
      cdata[k] = r.cnt
      @counties[j] = cdata
    end

    @columns.sort!
  end

  def columns
    @columns
  end

  def rows
    @counties
  end

end
