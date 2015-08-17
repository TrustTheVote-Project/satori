class EAVSPartAReportCSV

  FIELDS = [
    { title: "Local Jurisdiction Identification", info: "Instructions *        Information about the number of registered voters in your jurisdiction and how you calculate those statistics.        *  ", col_name: "FIPS Code" },
    { title: "Local Jurisdiction Name", info: "N/A  = Data Not Available\nNot Applicable = Not Applicable", col_name: "Jurisdiction Name", db_col: 'jurisdiction' },
    { title: "Registered Eligible Voters", info: "Enter Number or N/A", col_name: "A1a", db_col: 'a1a' },
    { title: "Comments", info: "optional", col_name: "A1Comments" },

    { title: "How Registered Eligible Voters Are Reported", info: "See pull down for options", col_name: "A2", db_col: 'a2' },
    { title: "How Registered Eligible Voters Are Reported (Other)", info: "Other Specify:\n(Text)", col_name: "A2c_Other" },
    { title: "Comments", info: "optional", col_name: "A2_Comments" },

    { title: "Active Voters", info: "Enter Number or N/A", col_name: "A3a", db_col: 'a3a' },
    { title: "Inactive Voters", info: "Enter Number or N/A", col_name: "A3b", db_col: 'a3b' },
    { title: "Comments", info: "optional", col_name: "A3Comments" },

    { title: "Election / Same Day Registrations:  Total", info: "Enter Number or N/A or Not Applicable", col_name: "A4a", value: '0' },
    { title: "Are Election / Same Day Registrations for All Voters", info: "See pull down menu for options", col_name: "A4b", value: 'No' },
    { title: "Election / Same Day Registrations (Other)", info: "Other Specify:\n(Text)", col_name: "A4b_Other" },
    { title: "Comments", info: "optional", col_name: "A4Comments", value: 'Virginia does not have same day registration and voting' },

    { title: "Registration Forms Received Since 2010:  Total", info: "Enter Number or N/A", col_name: "A5a", db_col: 'a5a' },
    { title: "Registration Forms Received Since 2010:  New Valid", info: "Enter Number or N/A", col_name: "A5b", db_col: 'a5b' },
    { title: "Registration Forms Received Since 2010:  Pre-Registrations under 18 years", info: "Enter Number or N/A", col_name: "A5c", value: 'N/A' },
    { title: "Registration Forms Received Since 2010:  Duplicate of Existing", info: "Enter Number or N/A", col_name: "A5d", db_col: 'a5d' },
    { title: "Registration Forms Received Since 2010:  Invalid / Rejected \n(Not Duplicates)", info: "Enter Number or N/A", col_name: "A5e", db_col: 'a5e' },
    { title: "Registration Forms Received Since 2010:  Changes (name, party, within-jurisdiction address)", info: "Enter Number or N/A", col_name: "A5f", value: 'N/A' },
    { title: "Registration Forms Received Since 2010:  Address Changes (Cross-jurisdiction)", info: "Enter Number or N/A", col_name: "A5g", value: 'N/A' },
    { title: "Registration Forms Received Since 2010: Other Count1 Description", info: "Other Specify:\n(Text)", col_name: "A5h_Other", value: 'Other' },
    { title: "Registration Forms Received Since 2010: Other Count1 ", info: "Enter Number or N/A", col_name: "A5h", db_col: 'a5h' },
    { title: "Registration Forms Received Since 2010: Other Count2 Description", info: "Other Specify:\n(Text)", col_name: "A5i_Other" },
    { title: "Registration Forms Received Since 2010: Other Count2", info: "Enter Number or N/A", col_name: "A5i" },
    { title: "Registration Forms Received Since 2010: Other Count3 Description", info: "Other Specify:\n(Text)", col_name: "A5j_Other" },
    { title: "Registration Forms Received Since 2010: Other Count3", info: "Enter Number or N/A", col_name: "A5j" },
    { title: "Registration Forms Received Since 2010: Other Count4 Description", info: "Other Specify:\n(Text)", col_name: "A5k_Other" },
    { title: "Registration Forms Received Since 2010: Other Count4", info: "Enter Number or N/A", col_name: "A5k" },
    { title: "Registration Forms Received Since 2010: Other Count5 Description", info: "Other Specify:\n(Text)", col_name: "A5l_Other" },
    { title: "Registration Forms Received Since 2010: Other Count5", info: "Enter Number or N/A", col_name: "A5l" },
    { title: "Registration Forms Received Since 2010: Total Check", info: "Formula", col_name: "A5Total", db_col: 'a5_total' },
    { title: "Registration Comments", info: "optional", col_name: "A5Comments" },

    { title: "Registrations\nBy Correspondence", info: "Enter Number or N/A", col_name: "A6a", db_col: 'a6a' },
    { title: "Registrations\nRegistrar Office", info: "Enter Number or N/A", col_name: "A6b", db_col: 'a6b' },
    { title: "Registrations\nBy Internet", info: "Enter Number or N/A", col_name: "A6c", db_col: 'a6c' },
    { title: "Registrations\nMotor Vehicle Office", info: "Enter Number or N/A", col_name: "A6d", db_col: 'a6d' },
    { title: "Registrations\nNVRA Site", info: "Enter Number or N/A", col_name: "A6e", db_col: 'a6e' },
    { title: "Registrations\nState Agency", info: "Enter Number or N/A", col_name: "A6f", value: 'N/A' },
    { title: "Registrations\nArmed Forces Recruitment Offices", info: "Enter Number or N/A", col_name: "A6g", value: 'N/A' },
    { title: "Registrations\nOther Non-NVRA", info: "Enter Number or N/A", col_name: "A6h", value: 'N/A' },
    { title: "Registrations\nAdvocacy Groups", info: "Enter Number or N/A", col_name: "A6i", db_col: 'a6i' },
    { title: "Registrations\nAll Other Count 1 Description", info: "Other Specify:\n(Text)", col_name: "A6j_Other", value: 'Other' },
    { title: "Registrations\nAll Other Count 1", info: "Enter Number or N/A", col_name: "A6j", db_col: 'a6j' },
    { title: "Registrations\nAll Other Count 2\nDescription", info: "Other Specify:\n(Text)", col_name: "A6k_Other" },
    { title: "Registrations\nAll Other Count 2", info: "Enter Number or N/A", col_name: "A6k" },
    { title: "Registrations\nAll Other Count 3 Description", info: "Other Specify:\n(Text)", col_name: "A6l_Other" },
    { title: "Registrations\nAll Other Count 3", info: "Enter Number or N/A", col_name: "A6l" },
    { title: "Registrations\nAll Other Count 4 Description", info: "Other Specify:\n(Text)", col_name: "A6m_Other" },
    { title: "Registrations\nAll Other Count 4", info: "Enter Number or N/A", col_name: "A6m" },
    { title: "Registrations\nAll Other Count 5 Description", info: "Other Specify:\n(Text)", col_name: "A6n_Other" },
    { title: "Registrations\nAll Other Count 5", info: "Enter Number or N/A", col_name: "A6n" },
    { title: "Registrations\nAll Other Count 6 Description", info: "Other Specify:\n(Text)", col_name: "A6o_Other" },
    { title: "Registrations\nAll Other Count 6", info: "Enter Number or N/A", col_name: "A6o" },
    { title: "Registrations\nAll Total Check", info: "Formula", col_name: "A6Total", db_col: 'a6_total' },
    { title: "Registrations\nAll Comments", info: "optional", col_name: "A6Comments" },

    { title: "Registrations\nBy Correspondence\nNew", info: "Enter Number or N/A", col_name: "A7a", db_col: 'a7a' },
    { title: "Registrations\nRegistrar Office\nNew", info: "Enter Number or N/A", col_name: "A7b", db_col: 'a7b' },
    { title: "Registrations\nBy Internet\nNew", info: "Enter Number or N/A", col_name: "A7c", db_col: 'a7c' },
    { title: "Registrations\nMotor Vehicle Office\nNew", info: "Enter Number or N/A", col_name: "A7d", db_col: 'a7d' },
    { title: "Registrations\nNVRA Site\nNew", info: "Enter Number or N/A", col_name: "A7e", db_col: 'a7e' },
    { title: "Registrations\nState Agency\nNew", info: "Enter Number or N/A", col_name: "A7f", value: 'N/A' },
    { title: "Registrations\nArmed Forces Recruitment Offices\nNew", info: "Enter Number or N/A", col_name: "A7g", value: 'N/A' },
    { title: "Registrations\nOther Non-NVRA\nNew", info: "Enter Number or N/A", col_name: "A7h", value: 'N/A' },
    { title: "Registrations\nAdvocacy Groups\nNew", info: "Enter Number or N/A", col_name: "A7i", db_col: 'a7i' },
    { title: "Registrations\nNew Other Count 1 Description", info: "Other Specify:\n(Text)", col_name: "A7j_Other", value: 'Other' },
    { title: "Registrations\nNew Other Count 1", info: "Enter Number or N/A", col_name: "A7j", db_col: 'a7j' },
    { title: "Registrations\nNew Other Count 2\nDescription", info: "Other Specify:\n(Text)", col_name: "A7k_Other" },
    { title: "Registrations\nNew Other Count 2", info: "Enter Number or N/A", col_name: "A7k" },
    { title: "Registrations\nNew Other Count 3 Description", info: "Other Specify:\n(Text)", col_name: "A7l_Other" },
    { title: "Registrations\nNew Other Count 3", info: "Enter Number or N/A", col_name: "A7l" },
    { title: "Registrations\nNew Other Count 4 Description", info: "Other Specify:\n(Text)", col_name: "A7m_Other" },
    { title: "Registrations\nNew Other Count 4", info: "Enter Number or N/A", col_name: "A7m" },
    { title: "Registrations\nNew Other Count 5 Description", info: "Other Specify:\n(Text)", col_name: "A7n_Other" },
    { title: "Registrations\nNew Other Count 5", info: "Enter Number or N/A", col_name: "A7n" },
    { title: "Registrations\nNew Other Count 6 Description", info: "Other Specify:\n(Text)", col_name: "A7o_Other" },
    { title: "Registrations\nNew Other Count 6", info: "Enter Number or N/A", col_name: "A7o" },
    { title: "Registrations\nNew Total Check", info: "Formula", col_name: "A7Total", db_col: 'a7_total' },
    { title: "Registrations\nNew Comments", info: "optional", col_name: "A7Comments" },

    { title: "Registrations\nBy Correspondence\nDuplicates", info: "Enter Number or N/A", col_name: "A8a", db_col: 'a8a' },
    { title: "Registrations\nRegistrar Office\nDuplicates", info: "Enter Number or N/A", col_name: "A8b", db_col: 'a8b' },
    { title: "Registrations\nBy Internet\nDuplicates", info: "Enter Number or N/A", col_name: "A8c", db_col: 'a8c' },
    { title: "Registrations\nMotor Vehicle Office\nDuplicates", info: "Enter Number or N/A", col_name: "A8d", db_col: 'a8d' },
    { title: "Registrations\nNVRA Site\nDuplicates", info: "Enter Number or N/A", col_name: "A8e", db_col: 'a8e' },
    { title: "Registrations\nState Agency\nDuplicates", info: "Enter Number or N/A", col_name: "A8f", value: 'N/A' },
    { title: "Registrations\nArmed Forces Recruitment Offices\nDuplicates", info: "Enter Number or N/A", col_name: "A8g", value: 'N/A' },
    { title: "Registrations\nOther Non-NVRA\nDuplicates", info: "Enter Number or N/A", col_name: "A8h", value: 'N/A' },
    { title: "Registrations\nAdvocacy Groups\nDuplicates", info: "Enter Number or N/A", col_name: "A8i", db_col: 'a8i' },
    { title: "Registrations\nDuplicates Other Count 1 Description", info: "Other Specify:\n(Text)", col_name: "A8j_Other", value: 'Other' },
    { title: "Registrations\nDuplicates Other Count 1", info: "Enter Number or N/A", col_name: "A8j", db_col: 'a8j' },
    { title: "Registrations\nDuplicates Other Count 2\nDescription", info: "Other Specify:\n(Text)", col_name: "A8k_Other" },
    { title: "Registrations\nDuplicates Other Count 2", info: "Enter Number or N/A", col_name: "A8k" },
    { title: "Registrations\nDuplicates Other Count 3 Description", info: "Other Specify:\n(Text)", col_name: "A8l_Other" },
    { title: "Registrations\nDuplicates Other Count 3", info: "Enter Number or N/A", col_name: "A8l" },
    { title: "Registrations\nDuplicates Other Count 4 Description", info: "Other Specify:\n(Text)", col_name: "A8m_Other" },
    { title: "Registrations\nDuplicates Other Count 4", info: "Enter Number or N/A", col_name: "A8m" },
    { title: "Registrations\nDuplicates Other Count 5 Description", info: "Other Specify:\n(Text)", col_name: "A8n_Other" },
    { title: "Registrations\nDuplicates Other Count 5", info: "Enter Number or N/A", col_name: "A8n" },
    { title: "Registrations\nDuplicates Other Count 6 Description", info: "Other Specify:\n(Text)", col_name: "A8o_Other" },
    { title: "Registrations\nDuplicates Other Count 6", info: "Enter Number or N/A", col_name: "A8o" },
    { title: "Registrations\nDuplicates Total Check", info: "A8Total", col_name: "A8Total", db_col: 'a8_total' },
    { title: "Registrations\nDuplicates Comments", info: "optional", col_name: "A8Comments" },

    { title: "Registrations\nBy Correspondence\nInvalid", info: "Enter Number or N/A", col_name: "A9a", db_col: 'a9a' },
    { title: "Registrations\nRegistrar Office\nInvalid", info: "Enter Number or N/A", col_name: "A9b", db_col: 'a9b' },
    { title: "Registrations\nBy Internet\nInvalid", info: "Enter Number or N/A", col_name: "A9c", db_col: 'a9c' },
    { title: "Registrations\nMotor Vehicle Office\nInvalid", info: "Enter Number or N/A", col_name: "A9d", db_col: 'a9d' },
    { title: "Registrations\nNVRA Site\nInvalid", info: "Enter Number or N/A", col_name: "A9e", db_col: 'a9e' },
    { title: "Registrations\nState Agency\nInvalid", info: "Enter Number or N/A", col_name: "A9f", value: 'N/A' },
    { title: "Registrations\nArmed Forces Recruitment Offices\nInvalid", info: "Enter Number or N/A", col_name: "A9g", value: 'N/A' },
    { title: "Registrations\nOther Non-NVRA\nInvalid", info: "Enter Number or N/A", col_name: "A9h", value: 'N/A' },
    { title: "Registrations\nAdvocacy Groups\nInvalid", info: "Enter Number or N/A", col_name: "A9i", db_col: 'a9i' },
    { title: "Registrations\nInvalid Other Count 1 Description", info: "Other Specify:\n(Text)", col_name: "A9j_Other", value: 'Other' },
    { title: "Registrations\nInvalid Other Count 1", info: "Enter Number or N/A", col_name: "A9j", db_col: 'a9j' },
    { title: "Registrations\nInvalid Other Count 2\nDescription", info: "Other Specify:\n(Text)", col_name: "A9k_Other" },
    { title: "Registrations\nInvalid Other Count 2", info: "Enter Number or N/A", col_name: "A9k" },
    { title: "Registrations\nInvalid Other Count 3 Description", info: "Other Specify:\n(Text)", col_name: "A9l_Other" },
    { title: "Registrations\nInvalid Other Count 3", info: "Enter Number or N/A", col_name: "A9l" },
    { title: "Registrations\nInvalid Other Count 4 Description", info: "Other Specify:\n(Text)", col_name: "A9m_Other" },
    { title: "Registrations\nInvalid Other Count 4", info: "Enter Number or N/A", col_name: "A9m" },
    { title: "Registrations\nInvalid Other Count 5 Description", info: "Other Specify:\n(Text)", col_name: "A9n_Other" },
    { title: "Registrations\nInvalid Other Count 5", info: "Enter Number or N/A", col_name: "A9n" },
    { title: "Registrations\nInvalid Other Count 6 Description", info: "Other Specify:\n(Text)", col_name: "A9o_Other" },
    { title: "Registrations\nInvalid Other Count 6", info: "Enter Number or N/A", col_name: "A9o" },
    { title: "Registrations\nInvalid Total Check", info: "A9Total", col_name: "A9Total", db_col: 'a9_total' },
    { title: "Registrations\nInvalid Comments", info: "optional", col_name: "A9Comments" },

    { title: "Removal Notices \nTotal Sent", info: "Enter Number or N/A", col_name: "A10a", value: 'N/A' },
    { title: "Removal Notices Registrations Confirmed", info: "Enter Number or N/A", col_name: "A10b", value: 'N/A' },
    { title: "Removal Notices Registrations Invalidated", info: "Enter Number or N/A", col_name: "A10c", value: 'N/A' },
    { title: "Removal Notices Undeliverable", info: "Enter Number or N/A", col_name: "A10d", value: 'N/A' },
    { title: "Removal Notices Status Unknown", info: "Enter Number or N/A", col_name: "A10e", value: 'N/A' },
    { title: "Removal Notices Other Count1 Description", info: "Other Specify:\n(Text)", col_name: "A10f_Other", value: 'N/A' },
    { title: "Removal Notices Other Count1", info: "Enter Number or N/A", col_name: "A10f", value: 'N/A' },
    { title: "Removal Notices Other Count2 Description", info: "Other Specify:\n(Text)", col_name: "A10g_Other", value: 'N/A' },
    { title: "Removal Notices Other Count2", info: "Enter Number or N/A", col_name: "A10g", value: 'N/A' },
    { title: "Removal Notices Other Count3 Description", info: "Other Specify:\n(Text)", col_name: "A10h_Other", value: 'N/A' },
    { title: "Removal Notices Other Count3", info: "Enter Number or N/A", col_name: "A10h", value: 'N/A' },
    { title: "Removal Notices Total Check", info: "Formula", col_name: "A10Total", value: 'N/A' },
    { title: "Removal Notices Comments", info: "optional", col_name: "A10Comments", value: 'N/A' },

    { title: "Removed Voters \nTotal", info: "Enter Number or N/A", col_name: "A11a", db_col: 'a11a' },
    { title: "Removed Voters Relocation \n(Outside Jurisdiction)", info: "Enter Number or N/A", col_name: "A11b", db_col: 'a11b' },
    { title: "Removed Voters\nDeath", info: "Enter Number or N/A", col_name: "A11c", db_col: 'a11c' },
    { title: "Removed Voters\nFelony", info: "Enter Number or N/A", col_name: "A11d", db_col: 'a11d' },
    { title: "Removed Voters\nFailure to Respond to Notices or Vote ", info: "Enter Number or N/A", col_name: "A11e", value: 'N/A' },
    { title: "Removed Voters\nDeclared Mentally Incompetent", info: "Enter Number or N/A", col_name: "A11f", db_col: 'a11f' },
    { title: "Removed Voters\nBy Voter Request", info: "Enter Number or N/A", col_name: "A11g", value: 'N/A' },
    { title: "Removed Voters Other Count1 Description", info: "Other Specify:\n(Text)", col_name: "A11h_Other", value: 'Other' },
    { title: "Removed Voters Other Count1", info: "Enter Number or N/A", col_name: "A11h", db_col: 'a11h' },
    { title: "Removed Voters Other Count2 Description", info: "Other Specify:\n(Text)", col_name: "A11i_Other" },
    { title: "Removed Voters Other Count2", info: "Enter Number or N/A", col_name: "A11i" },
    { title: "Removed Voters Other Count3 Description", info: "Other Specify:\n(Text)", col_name: "A11j_Other" },
    { title: "Removed Voters Other Count3", info: "Enter Number or N/A", col_name: "A11j" },
    { title: "Removed Voters Other Count4 Description", info: "Other Specify:\n(Text)", col_name: "A11k_Other" },
    { title: "Removed Voters Other Count4", info: "Enter Number or N/A", col_name: "A11k" },
    { title: "Removed Voters\nTotal Check", info: "Formula", col_name: "A11Total", db_col: 'a11_total' },
    { title: "Removed Voters\nComments", info: "optional", col_name: "A11Comments" }
  ]

  def initialize(election)
    @e = election
  end

  def generate
    CSV.generate do |csv|
      csv << FIELDS.map { |f| f[:title] }
      csv << FIELDS.map { |f| f[:info] }
      csv << FIELDS.map { |f| f[:col_name] }

      Rails.logger.info @e.id
      Reports::EAVSPartAReport.where(election_id: @e.id).each do |r|
        c = []
        FIELDS.each do |f|
          v = f[:value] || ((col = f[:db_col]) && r.send(col))
          c << v
        end
        csv << c
      end
    end
  end

end
