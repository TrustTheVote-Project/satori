class RegFormsReceivedByLocalityReport < BaseReport

  TOTAL              = "Total"
  NEW_VALID          = "New Valid"
  PRE_REG_UNDER_18   = "Pre-Registrations under 18 years"
  DUPLICATE          = "Duplicate of Existing"
  REJECTED           = "Invalid / Rejected"
  CHANGES            = "Changes"
  ADDRESS_CHANGES    = "Address Changes"
  OTHER              = "Other"

  COLUMNS = [ TOTAL, NEW_VALID, PRE_REG_UNDER_18, DUPLICATE, REJECTED, CHANGES, ADDRESS_CHANGES, OTHER ]

  I_TOTAL            = COLUMNS.index(TOTAL)
  I_NEW_VALID        = COLUMNS.index(NEW_VALID)
  I_PRE_REG_UNDER_18 = COLUMNS.index(PRE_REG_UNDER_18)
  I_DUPLICATE        = COLUMNS.index(DUPLICATE)
  I_REJECTED         = COLUMNS.index(REJECTED)
  I_CHANGES          = COLUMNS.index(CHANGES)
  I_ADDRESS_CHANGES  = COLUMNS.index(ADDRESS_CHANGES)
  I_OTHER            = COLUMNS.index(OTHER)

  def initialize(election)
    super()

    Reports::RegFormsReceivedByLocality.where(election_id: election.id).each do |r|
      j = r.jurisdiction

      cdata = @rows[j] || {}
      cdata[I_TOTAL] = r.total
      cdata[I_NEW_VALID] = r.new
      cdata[I_PRE_REG_UNDER_18] = 'N/A'
      cdata[I_DUPLICATE] = r.duplicate
      cdata[I_REJECTED] = r.rejected
      cdata[I_CHANGES] = r.record_changes
      cdata[I_ADDRESS_CHANGES] = 0
      cdata[I_OTHER] = r.other
      @rows[j] = cdata

      add_to_totals I_TOTAL, r.total
      add_to_totals I_NEW_VALID, r.new
      add_to_totals I_DUPLICATE, r.duplicate
      add_to_totals I_REJECTED, r.rejected
      add_to_totals I_CHANGES, r.record_changes
      add_to_totals I_OTHER, r.other
    end
  end

  def initial_columns
    COLUMNS.size.times.to_a
  end

  def column_name(c)
    COLUMNS[c]
  end
end
