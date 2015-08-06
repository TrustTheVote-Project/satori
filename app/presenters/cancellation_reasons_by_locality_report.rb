class CancellationReasonsByLocalityReport < BaseReport

  def initialize(election)
    super()

    Reports::CancellationReasonsByLocality.where(election_id: election.id).each do |r|
      j = r.jurisdiction
      k = r.key

      cdata = @rows[j] || {}
      cdata[k] = r.cnt
      @rows[j] = cdata

      add_to_totals k, r.cnt
    end
  end

  def initial_columns
    [ "Registered Voters", "Cancellations" ] +
    [ "cancelUnderage", "cancelDuplicate", "cancelCitizenship", "cancelOther",
      "cancelTransferOut", "cancelDeceased", "cancelFelonyConviction", "cancelIncapacitated" ].sort +
    [ "Other" ]
  end

end
