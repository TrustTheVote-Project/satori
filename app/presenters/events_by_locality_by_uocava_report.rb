class EventsByLocalityByUocavaReport < BaseReport

  VERSIONS = %w{ Total Local UOCAVA }

  def initialize(election)
    super()

    Reports::EventsByLocalityByUocava.where(election_id: election.id).each do |r|
      j   = r.jurisdiction
      key = r.key

      cdata = @rows[j] || {}
      cdata["#{key} - Total"] = r.total
      cdata["#{key} - Local"] = r.local
      cdata["#{key} - UOCAVA"] = r.uocava
      @rows[j] = cdata

      @totals_row["#{key} - Total"]  = (@totals_row["#{key} - Total"] || 0) + r.total
      @totals_row["#{key} - Local"]  = (@totals_row["#{key} - Local"] || 0) + r.local
      @totals_row["#{key} - UOCAVA"] = (@totals_row["#{key} - UOCAVA"] || 0) + r.uocava
    end
  end

  def highlight_class_for_column(col_name)
    if col_name =~ /Local$/
      'em1'
    elsif col_name =~ /UOCAVA$/
      'em2'
    end
  end

  private

  def initial_columns

    # ACTION_VALUES    = %w( identify voterPollCheckin cancelVoterRecord start discard complete submit receive approve reject sentToVoter returnedUndelivered ).map(&:downcase)
    # FORM_VALUES      = %w( VoterRegistration VoterRegistrationAbsenteeRequest VoterRecordUpdate VoterRecordUpdateAbsenteeRequest AbsenteeRequest AbsenteeBallot ProvisionalBallot PollBookEntry VoterCard ).map(&:downcase)

    c = []

    forms = %w( VoterRegistration VoterRegistrationAbsenteeRequest VoterRecordUpdate VoterRecordUpdateAbsenteeRequest AbsenteeRequest AbsenteeBallot ProvisionalBallot )
    c += generate_columns("Registered Voters")
    forms.each { |f| c += generate_columns("approve - #{f}") }
    forms.each { |f| c += generate_columns("reject - #{f}") }

    c += generate_columns("cancelVoterRecord")
    c += generate_columns("voterPollCheckin")
    c += generate_columns("sentToVoter - VoterCard")
    c += generate_columns("sentToVoter - AbsenteeRequest")
    c += generate_columns("sentToVoter - AbsenteeBallot")
    c += generate_columns("receive - AbsenteeBallot")
    c += generate_columns("returnedUndelivered - AbsenteeBallot")

    c
  end

  def generate_columns(c)
    VERSIONS.map { |v| "#{c} - #{v}" }
  end

end
