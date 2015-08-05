@ErrorRow = React.createClass
  render: ->
    u = @props.error
    file = u.filename
    if !file
      fileParts = u.url.split('/')
      file = fileParts[fileParts.length - 1]
    `<tr>
      <td className='col-sm-12'>
        <p>{file}</p>
        <div className='alert alert-danger'>{u.error}</div>
      </td>
      <td className='text-center'>
        <a href={u.delete_url} data-method='delete' data-confirm='Delete this failed job?' className='btn btn-xs btn-danger'>
          <div className='glyphicon glyphicon-remove'/>
        </a>
      </td>
    </tr>`
