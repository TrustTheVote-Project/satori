class EventsByCountyByDemogReport

  def initialize(election)
    @columns = []
    @counties = {}

    @by_gender = Reports::CountsByLocalityByGender.where(election_id: election.id)
    @by_gender.each do |r|
      j = r.jurisdiction
      k = r.key.gsub('- ', '')
      c = r.cnt

      if k.nil?
        Rails.logger.fatal r.inspect
      end
      @columns << k unless @columns.include?(k)

      cdata = @counties[j] || {}
      cdata[k] = c
      @counties[j] = cdata
    end

    @by_uocava = Reports::CountsByLocalityByUocava.where(election_id: election.id)
    @by_uocava.each do |r|
      j = r.jurisdiction
      k = r.key.gsub('- ', '')
      c = r.cnt

      if k.nil?
        Rails.logger.fatal r.inspect
      end
      @columns << k unless @columns.include?(k)

      cdata = @counties[j] || {}
      cdata[k] = c
      @counties[j] = cdata
    end

    Rails.logger.info @columns.inspect
    @columns = @columns.sort
  end

  def columns
    @columns
  end

  def rows
    @counties
  end

end
