class RegsByOriginReport < BaseReport

# Local Jurisdiction Name
# Total
# By Correspondence
# Registrar Office
# By Internet
# Motor Vehicle Office
# NVRA Site
# State Agency
#
# Other Non-NVRA
# Advocacy Groups
# Other

  TOTAL            = "Total"
  POSTAL           = "By Correspondence"
  OFFICE           = "Registrar Office"
  INTERNET         = "By Internet"
  MOTOR_OFFICE     = "Motor Vehivle Office"
  NVRA_SITE        = "NVRA Site"
  STATE_AGENCY     = "State Agency"
  ARMED_FORCES     = "Armed Forces Recruitment Offices"
  OTHER_NON_NVRA   = "Other Non-NVRA"
  ADVOCACY         = "Advocacy Groups"
  OTHER            = "Other"

  COLUMNS          = [ TOTAL, POSTAL, OFFICE, INTERNET, MOTOR_OFFICE, NVRA_SITE, STATE_AGENCY,
                       ARMED_FORCES, OTHER_NON_NVRA, ADVOCACY, OTHER ]

  I_TOTAL          = COLUMNS.index(TOTAL)
  I_POSTAL         = COLUMNS.index(POSTAL)
  I_OFFICE         = COLUMNS.index(OFFICE)
  I_INTERNET       = COLUMNS.index(INTERNET)
  I_MOTOR_OFFICE   = COLUMNS.index(MOTOR_OFFICE)
  I_NVRA_SITE      = COLUMNS.index(NVRA_SITE)
  I_STATE_AGENCY   = COLUMNS.index(STATE_AGENCY)
  I_ARMED_FORCES   = COLUMNS.index(ARMED_FORCES)
  I_OTHER_NON_NVRA = COLUMNS.index(OTHER_NON_NVRA)
  I_ADVOCACY       = COLUMNS.index(ADVOCACY)
  I_OTHER          = COLUMNS.index(OTHER)

  def initialize(report_class, election)
    super()

    report_class.where(election_id: election.id).each do |r|
      j = r.jurisdiction

      cdata = @rows[j] || {}
      cdata[I_TOTAL] = r.total
      cdata[I_POSTAL] = r.postal
      cdata[I_OFFICE] = r.office
      cdata[I_INTERNET] = r.internet
      cdata[I_MOTOR_OFFICE] = r.motor_vehicle_office
      cdata[I_NVRA_SITE] = r.nvra_site
      cdata[I_STATE_AGENCY] = 'N/A'
      cdata[I_ARMED_FORCES] = 'N/A'
      cdata[I_OTHER_NON_NVRA] = 'N/A'
      cdata[I_ADVOCACY] = r.advocacy_group
      cdata[I_OTHER] = r.other
      @rows[j] = cdata

      add_to_totals I_TOTAL, r.total
      add_to_totals I_POSTAL, r.postal unless r.postal == 'N/A'
      add_to_totals I_OFFICE, r.office unless r.office == 'N/A'
      add_to_totals I_INTERNET, r.internet
      add_to_totals I_MOTOR_OFFICE, r.motor_vehicle_office
      add_to_totals I_NVRA_SITE, r.nvra_site
      add_to_totals I_ADVOCACY, r.advocacy_group
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
