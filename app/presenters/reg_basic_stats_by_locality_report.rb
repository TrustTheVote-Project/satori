class RegBasicStatsByLocalityReport < BaseReport

  REGISTERED_VOTERS = "Registered Eligible Voters"
  HOW_REPORTED      = "How Registered Eligible Voters Are Reported"
  ACTIVE_VOTERS     = "Active Voters"
  INACTIVE_VOTERS   = "Inactive Voters"
  SAME_DAY_REGS     = "Election / Same Day Registrations"
  SAME_DAY_FOR_ALL  = "Are Election / Same Day Registrations for All Voters"

  COLUMNS = [ REGISTERED_VOTERS, HOW_REPORTED, ACTIVE_VOTERS, INACTIVE_VOTERS, SAME_DAY_REGS, SAME_DAY_FOR_ALL ]

  I_REGISTERED_VOTERS = COLUMNS.index(REGISTERED_VOTERS)
  I_HOW_REPORTED      = COLUMNS.index(HOW_REPORTED)
  I_ACTIVE_VOTERS     = COLUMNS.index(ACTIVE_VOTERS)
  I_INACTIVE_VOTERS   = COLUMNS.index(INACTIVE_VOTERS)
  I_SAME_DAY_REGS     = COLUMNS.index(SAME_DAY_REGS)
  I_SAME_DAY_FOR_ALL  = COLUMNS.index(SAME_DAY_FOR_ALL)

  def initialize(election)
    super()

    Reports::RegBasicStatsByLocality.where(election_id: election.id).each do |r|
      j = r.jurisdiction

      cdata = @rows[j] || {}
      cdata[I_REGISTERED_VOTERS] = r.total
      cdata[I_ACTIVE_VOTERS] = r.active
      cdata[I_INACTIVE_VOTERS] = r.inactive
      cdata[I_HOW_REPORTED] = case
                              when r.active > 0 && r.inactive > 0
                                "Both Active and Inactive"
                              when r.active > 0
                                "Active Only"
                              when r.inactive > 0
                                "Inactive Only"
                              else
                                "N/A"
                              end
      cdata[I_SAME_DAY_REGS] = 0
      cdata[I_SAME_DAY_FOR_ALL] = "No"
      @rows[j] = cdata

      add_to_totals I_REGISTERED_VOTERS, r.total
      add_to_totals I_ACTIVE_VOTERS, r.active
      add_to_totals I_INACTIVE_VOTERS, r.inactive
    end
  end

  def initial_columns
    COLUMNS.size.times.to_a
  end

  def column_name(c)
    COLUMNS[c]
  end
end
