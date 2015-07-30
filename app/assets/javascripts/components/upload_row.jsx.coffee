@UploadRow = React.createClass
  render: ->
    u = @props.upload
    file = u.filename
    if !file
      fileParts = u.url.split('/')
      file = fileParts[fileParts.length - 1]

    icon = false
    if u.state == 'pending'
      icon = 'glyphicon glyphicon-hourglass'
    else if u.state == 'processing'
      icon = 'glyphicon glyphicon-refresh'

    if icon
      state = `<span className={icon}/>`
    else
      state = u.state

    span = @props.cols - 1
    `<tr>
      <td colSpan={span} className='col-sm-12'>{file}</td>
      <td className='text-center'>{state}</td>
    </tr>`

