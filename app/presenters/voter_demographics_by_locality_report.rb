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
        v = r.send(f)
        cdata[k] = v unless v == 0
      end
      @counties[j] = cdata
    end

    Reports::VotersRace.where(election_id: election.id).each do |r|
      j = r.jurisdiction
      k = r.race

      @columns << k unless @columns.include?(k)

      cdata = @counties[j] || {}
      cdata[k] = r.cnt
      @counties[j] = cdata
    end

    Reports::VotersParty.where(election_id: election.id).each do |r|
      j = r.jurisdiction
      k = r.political_party_name

      @columns << k unless @columns.include?(k)

      cdata = @counties[j] || {}
      cdata[k] = r.cnt
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
