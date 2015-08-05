class VoterDemographicsByLocalityReport

  COLUMNS = {
    'Registered Voters'       => :total,
    'Active'                  => :active,
    'Inactive'                => :inactive,
    'Cancelled'               => :cancelled,
    'Female'                  => :female,
    'Male'                    => :male,
    'Other/Unknown'           => :gender_unknown,
    'Overseas'                => :overseas,
    'Military'                => :military,
    'Protected'               => :protected,
    'Disabled'                => :disabled,
    'absenteeOngoing'         => :absentee_ongoing,
    'absenteeInThisElection'  => :absentee_in_this_election }

  def initialize(election)
    @columns = COLUMNS.keys
    @counties = {}

    Reports::VoterDemographicsByLocality.where(election_id: election.id).each do |r|
      j = r.jurisdiction

      cdata = @counties[j] || {}
      COLUMNS.each do |k, f|
        cdata[k] = r.send(f)
      end
      @counties[j] = cdata
    end
  end

  def columns
    @columns
  end

  def rows
    @counties
  end

end
