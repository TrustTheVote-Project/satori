class EventsByLocalityReport < BaseReport

  def initialize(election)
    super()

    Reports::EventsByLocality.where(election_id: election.id).each do |r|
      j   = r.jurisdiction
      key = r.key

      if key =~ /(cancelVoterRecord|voterPollCheckin)/
        key = $1
      end

      @columns << key unless @columns.include?(key)

      cdata = @rows[j] || {}
      cdata[key] = (cdata[key] || 0) + r.cnt
      @rows[j] = cdata

      add_to_totals key, r.cnt
    end
  end

  private

  def initial_columns
    c = []

    forms = %w( VoterRegistration VoterRegistrationAbsenteeRequest VoterRecordUpdate VoterRecordUpdateAbsenteeRequest AbsenteeRequest AbsenteeBallot ProvisionalBallot )
    forms.each { |f| c << "approve - #{f}" }
    forms.each { |f| c << "reject - #{f}" }

    c << "cancelVoterRecord"
    c << "voterPollCheckin"
    c << "sentToVoter - VoterCard"
    c << "sentToVoter - AbsenteeRequest"
    c << "sentToVoter - AbsenteeBallot"
    c << "receive - AbsenteeBallot"
    c << "returnedUndelivered - AbsenteeBallot"

    c
  end
end
