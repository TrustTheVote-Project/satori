json.success   true
json.has_demog @demog_files.present?
json.has_vtl   @vt_logs.present?

json.rows [ @demog_files.to_a, @vt_logs.to_a ].flatten do |l|
  json.id             l.id
  json.filename       l.filename
  json.create_date    l.created_at.strftime("%B %d, %Y %l:%M%p")
  json.uploaded_at    l.uploaded_at.try(:strftime, "%B %d, %Y %l:%M %P")
  json.uploaded_by    l.uploader.try(:full_name)
  json.origin         l.origin

  if l.kind_of? DemogFile
    json.type               'demog'
    json.records_count      l.records_count
    json.url                election_demog_file_url(@election, l)
  elsif l.kind_of? TransactionLog
    json.type               'vtl'
    json.earliest_event_at  l.earliest_event_at.try(:strftime, "%B %d, %Y %l:%M %P")
    json.latest_event_at    l.latest_event_at.try(:strftime, "%B %d, %Y %l:%M %P")
    json.events_count       l.events_count
    json.url                election_transaction_log_url(@election, l)
  end
end

json.uploads @uploads do |u|
  json.id           u.id
  json.filename     u.filename
  json.url          u.url
  json.state        u.state
end

json.errors @errors do |u|
  json.id           u.id
  json.filename     u.filename
  json.url          u.url
  json.error        u.error
  json.delete_url   election_upload_job_url(@election, u.id)
end

