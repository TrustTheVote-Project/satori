class RemovedVotersReport < BaseReport

  TOTAL           = "Total"
  RELOCATION      = "Relocation (Outside Jurisdiction)"
  DEATH           = "Death"
  FELONY          = "Felony"
  NO_RESPONSE     = "Failure to Respond to Notices or Vote"
  INCOMPETENT     = "Declared Mentally Incompetent"
  VOTER_REQUEST   = "By Voter Request"
  OTHER           = "Other"

  COLUMNS         = [ TOTAL, RELOCATION, DEATH, FELONY, NO_RESPONSE, INCOMPETENT, VOTER_REQUEST, OTHER ]

  I_TOTAL         = COLUMNS.index(TOTAL)
  I_RELOCATION    = COLUMNS.index(RELOCATION)
  I_DEATH         = COLUMNS.index(DEATH)
  I_FELONY        = COLUMNS.index(FELONY)
  I_NO_RESPONSE   = COLUMNS.index(NO_RESPONSE)
  I_INCOMPETENT   = COLUMNS.index(INCOMPETENT)
  I_VOTER_REQUEST = COLUMNS.index(VOTER_REQUEST)
  I_OTHER         = COLUMNS.index(OTHER)

  def initialize(election)
    super()

    Reports::RemovedVoters.where(election_id: election.id).each do |r|
      j = r.jurisdiction

      cdata = @rows[j] || {}
      cdata[I_TOTAL]         = r.total
      cdata[I_RELOCATION]    = r.relocation
      cdata[I_DEATH]         = r.death
      cdata[I_FELONY]        = r.felony
      cdata[I_NO_RESPONSE]   = r.no_response
      cdata[I_INCOMPETENT]   = r.incompetent
      cdata[I_VOTER_REQUEST] = r.by_voter_request
      cdata[I_OTHER]         = r.other
      @rows[j] = cdata

      add_to_totals I_TOTAL, r.total
      add_to_totals I_RELOCATION, r.relocation
      add_to_totals I_DEATH, r.death
      add_to_totals I_FELONY, r.felony
      # add_to_totals I_NO_RESPONSE, r.no_response
      add_to_totals I_INCOMPETENT, r.incompetent
      # add_to_totals I_VOTER_REQUEST, r.by_voter_request
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
