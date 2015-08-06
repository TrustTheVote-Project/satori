class RegRejectionReasonsByLocalityReport < BaseReport

  def initialize(election)
    super()

    Reports::RegRejectionReasonsByLocality.where(election_id: election.id).each do |r|
      j = r.jurisdiction
      k = r.key

      cdata = @rows[j] || {}
      cdata[k] = r.cnt
      @rows[j] = cdata

      add_to_totals k, r.cnt
    end
  end

  def initial_columns
    [ "Registered Voters", "Rejected VR or AB Requests" ] +
    [ "rejectLate", "rejectUnsigned", "rejectIncomplete", "rejectFelonyConviction", "rejectIncapacitated", "rejectUnderage", "rejectCitizenship" ].sort +
    [ "Other" ]
  end

end
