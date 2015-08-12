class RemovalNoticiesSentReport < BaseReport

  TOTAL             = "Total"
  REG_CONFIRMED     = "Registrations Confirmed"
  REG_INVALIDATED   = "Registrations Invalidated"
  UNDELIVERABLE     = "Undeliverable"
  STATUS_UNKNOWN    = "Status Unknown"
  OTHER             = "Other"

  COLUMNS           = [ TOTAL, REG_CONFIRMED, REG_INVALIDATED, UNDELIVERABLE, STATUS_UNKNOWN, OTHER ]

  I_TOTAL           = COLUMNS.index(TOTAL)
  I_REG_CONFIRMED   = COLUMNS.index(REG_CONFIRMED)
  I_REG_INVALIDATED = COLUMNS.index(REG_INVALIDATED)
  I_UNDELIVERABLE   = COLUMNS.index(UNDELIVERABLE)
  I_STATUS_UNKNOWN  = COLUMNS.index(STATUS_UNKNOWN)
  I_OTHER           = COLUMNS.index(OTHER)

  def initialize(election)
    super()
  end

  def initial_columns
    COLUMNS.size.times.to_a
  end

  def column_name(c)
    COLUMNS[c]
  end

end
