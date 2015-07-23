json.logs @files do |l|
  json.id           l.id
  json.filename     l.filename
  json.create_date  l.created_at.strftime("%B %d, %Y %l:%M%p")
  json.url          election_demog_file_url(@election, l)
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
