class EventsByCountyByDemogReport

  def initialize(election)
    @columns = []
    @counties = {}

    Reports::CountsByCountyByDemog.where(election_id: election.id).each do |r|
      j = r.jurisdiction
      k = r.key
      c = r.cnt

      if k.nil?
        Rails.logger.fatal r.inspect
      end
      @columns << k unless @columns.include?(k)

      cdata = @counties[j] || {}
      cdata[k] = c
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
