class VoterDemographicsByLocalityReport < BaseReport

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
    super()

    Reports::VoterDemographicsByLocality.where(election_id: election.id).each do |r|
      j = r.jurisdiction

      cdata = @rows[j] || {}
      COLUMNS.each do |k, f|
        v = r.send(f)
        unless v == 0
          cdata[k] = v
          add_to_totals k, v
        end
      end
      @rows[j] = cdata
    end

    Reports::VotersRace.where(election_id: election.id).each do |r|
      j = r.jurisdiction
      k = r.race || 'No Race'

      k = 'Other Race' if k == 'Other'

      @columns << k unless k == 'Other Race' || k == 'No Race' || @columns.include?(k)

      cdata = @rows[j] || {}
      cdata[k] = r.cnt
      @rows[j] = cdata

      add_to_totals k, r.cnt
    end

    @columns << 'Other Race'
    @columns << 'No Race'

    Reports::VotersParty.where(election_id: election.id).each do |r|
      j = r.jurisdiction
      k = r.political_party_name || 'No Party'

      k = 'Other Party' if k == 'Other'

      @columns << k unless k == 'Other Party' || k == 'No Party' || @columns.include?(k)

      cdata = @rows[j] || {}
      cdata[k] = r.cnt
      @rows[j] = cdata

      add_to_totals k, r.cnt
    end

    @columns << 'Other Party'
    @columns << 'No Party'
  end

  def initial_columns
    COLUMNS.keys
  end

end
