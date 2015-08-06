class BaseReport

  attr_reader :columns
  attr_reader :rows
  attr_reader :totals_row

  def initialize
    @columns    = initial_columns
    @rows       = {}
    @totals_row = {}
  end

  # return CSS class to apply to TD of the column with the given #col_name
  def highlight_class_for_column(col_name)
    nil
  end

  protected

  # override to provide the ordered set of initial columns
  def initial_columns
    []
  end

end
