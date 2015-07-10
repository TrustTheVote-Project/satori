class EventsByCountyReport

  def initialize(data)
    @data = data
    @columns = []
    @counties = {}

    @data.each do |r|
      j = r.jurisdiction
      a = r.action
      f = r.form
      key = "#{a} - #{f}"

      @columns << key unless @columns.include?(key)

      cdata = @counties[j] || {}
      cdata[key] = r.cnt
      @counties[j] = cdata
    end

    @columns = @columns.sort
  end

  def columns
    @columns
  end

  def rows
    @counties
  end

end
