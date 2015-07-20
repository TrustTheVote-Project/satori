json.logs @logs do |l|
  json.id           l.id
  json.filename     l.filename
  json.origin       l.origin
  json.create_date  l.create_date.strftime("%B %d, %Y %l:%M%p")
  json.url          election_transaction_log_url(@election, l)
end

json.uploads @uploads do |u|
  json.id           u.id
  json.url          u.url
  json.state        u.state
end

json.errors @errors do |u|
  json.id           u.id
  json.url          u.url
  json.error        u.error
  json.delete_url   election_upload_job_url(@election, u.id)
end
