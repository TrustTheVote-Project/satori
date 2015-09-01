$("#js-form").on "submit", (e) ->
  e.preventDefault()
  alert("Please pick the XML file")

$("#file_upload input:file").each (i, elem) ->
  fileInput   = $(elem)
  statusBar   = $("#js-status-bar")
  progressBar = $(".progress-bar", statusBar)
  statusLabel = $(".status", statusBar)

  statusBar.hide()
  statusBar.removeClass('hide')

  fileInput.fileupload
    type:      "PUT"
    autoUpload: true
    acceptFileTypes: /\.xml$/i
    paramName:  'file'
    multipart:  false
    formData: { 'x-amz-meta-original-filename': '${filename}' }

    start: ->
      progressBar.css width: '0%'
      statusLabel.html("Uploading&hellip;")
      statusBar.show()

    progress: (e, data) ->
      p = parseInt(data.loaded / data.total * 100, 10)
      progressBar.css width: "#{p}%"
      progressBar.attr 'aria-valuenow': p
      progressBar.text "#{p}%"

    fail: ->
      fileInput.show()
      statusLabel.html("Failed to upload. Please retry.")

    done: ->
      progressBar.css width: '100%'
      progressBar.attr 'aria-valuenow': 100
      statusLabel.html("Uploaded. Initiating parsing&hellip;")

      $("#js-form")[0].submit()
