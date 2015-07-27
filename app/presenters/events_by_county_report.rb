class EventsByCountyReport

  def initialize(election)
    @columns = []
    @counties = {}

    Reports::CountsByLocality.where(election_id: election.id).each do |r|
      j   = r.jurisdiction
      key = r.key.gsub('- ', '<br/>')

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
