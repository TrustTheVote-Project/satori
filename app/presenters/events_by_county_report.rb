class EventsByCountyReport

  def initialize(election)
    @columns = []
    @counties = {}

    Reports::EventsByCounty.where(election_id: election.id).each do |r|
      j   = r.jurisdiction
      key = r.key

      @columns << key unless @columns.include?(key)

      cdata = @counties[j] || {}
      cdata[key] = r.cnt
      @counties[j] = cdata
    end
  end

  def columns
    @columns
  end

  def rows
    @counties
  end

end
