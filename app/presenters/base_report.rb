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

  # by default the key is the name, but you can decide to have a shorter key
  def column_name(c)
    c
  end

  protected

  # add the count to the keyed total
  def add_to_totals(key, value)
    @totals_row[key] = (@totals_row[key] || 0) + value
  end

  # override to provide the ordered set of initial columns
  def initial_columns
    []
  end

end
