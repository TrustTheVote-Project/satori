class BallotRejectionReasonsByLocalityReport < BaseReport

  def initialize(election)
    super()

    Reports::BallotRejectionReasonsByLocality.where(election_id: election.id).each do |r|
      j = r.jurisdiction
      k = r.key

      cdata = @rows[j] || {}
      cdata[k] = r.cnt
      @rows[j] = cdata

      add_to_totals k, r.cnt
    end
  end

  def initial_columns
    [ "Registered Voters" ] +
    [ "AbsenteeBallot - Accepted", "AbsenteeBallot - Rejected" ] +
    [ "AbsenteeBallot - rejectLate", "AbsenteeBallot - rejectUnsigned", "AbsenteeBallot - rejectIncomplete", "AbsenteeBallot - rejectFelonyConviction", "AbsenteeBallot - rejectIncapacitated", "AbsenteeBallot - rejectUnderage", "AbsenteeBallot - rejectCitizenship", "AbsenteeBallot - rejectPreviousVoteAbsentee", "AbsenteeBallot - rejectPreviousVote", "AbsenteeBallot - rejectAdministrative", "AbsenteeBallot - rejectIneligible" ].sort +
    [ "AbsenteeBallot - Other" ] +
    [ "ProvisionalBallot - Accepted", "ProvisionalBallot - Rejected" ] +
    [ "ProvisionalBallot - rejectLate", "ProvisionalBallot - rejectUnsigned", "ProvisionalBallot - rejectIncomplete", "ProvisionalBallot - rejectFelonyConviction", "ProvisionalBallot - rejectIncapacitated", "ProvisionalBallot - rejectUnderage", "ProvisionalBallot - rejectCitizenship", "ProvisionalBallot - rejectPreviousVoteAbsentee", "ProvisionalBallot - rejectPreviousVote", "ProvisionalBallot - rejectAdministrative", "ProvisionalBallot - rejectIneligible" ].sort +
    [ "ProvisionalBallot - Other" ]
  end

end
