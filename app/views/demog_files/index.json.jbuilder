json.logs @files do |l|
  json.id             l.id
  json.filename       l.filename
  json.create_date    l.created_at.strftime("%B %d, %Y %l:%M%p")
  json.uploaded_at    l.uploaded_at.try(:strftime, "%B %d, %Y %l:%M %P")
  json.uploaded_by    l.uploader.try(:full_name)
  json.records_count  l.records_count
  json.url            election_demog_file_url(@election, l)
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
