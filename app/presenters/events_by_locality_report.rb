class EventsByLocalityReport

  def initialize(election)
    @columns = initial_columns
    @counties = {}
    @totals_row = {}

    Reports::EventsByLocality.where(election_id: election.id).each do |r|
      j   = r.jurisdiction
      key = r.key

      if key =~ /(cancelVoterRecord|voterPollCheckin)/
        key = $1
      end

      @columns << key unless @columns.include?(key)

      cdata = @counties[j] || {}
      cdata[key] = (cdata[key] || 0) + r.cnt
      @counties[j] = cdata

      @totals_row[key] = (@totals_row[key] || 0) + r.cnt
    end
  end

  def columns
    @columns
  end

  def rows
    @counties
  end

  def totals_row
    @totals_row
  end

  private

  def initial_columns

    # ACTION_VALUES    = %w( identify voterPollCheckin cancelVoterRecord start discard complete submit receive approve reject sentToVoter returnedUndelivered ).map(&:downcase)
    # FORM_VALUES      = %w( VoterRegistration VoterRegistrationAbsenteeRequest VoterRecordUpdate VoterRecordUpdateAbsenteeRequest AbsenteeRequest AbsenteeBallot ProvisionalBallot PollBookEntry VoterCard ).map(&:downcase)

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
