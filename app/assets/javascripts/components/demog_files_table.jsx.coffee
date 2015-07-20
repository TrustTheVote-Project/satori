actLoadLogs = Reflux.createAction()

LogsStore = Reflux.createStore
  init: ->
    @data = {}
    @listenTo actLoadLogs, @onLoadLogs

  getInitialState: -> @data

  onLoadLogs: (url) ->
    $.getJSON url, (data) =>
      @data = data
      @trigger(@data)


@DemogFilesTable = React.createClass
  mixins: [
    Reflux.connect LogsStore, "data"
  ]

  componentDidMount: ->
    actLoadLogs @props.data_url
    setInterval ( () => actLoadLogs(@props.data_url) ), 5000

  render: ->
    rows = []
    uploads = []
    errors = []

    if @state.data.logs?
      if @state.data.logs.length == 0
        rows.push `<tr><td colSpan='3'>No logs loaded yet</td></tr>`
      else
        @state.data.logs.map (log) ->
          rows.push `<LogRow key={log.id} log={log}/>`

      @state.data.uploads.map (u) ->
        uploads.push `<UploadRow key={u.id} upload={u}/>`

      (@state.data.errors || []).map (e) ->
        errors.push `<ErrorRow key={e.id} error={e}/>`
    else
      rows.push `<tr><td colSpan='3'>Loading data...</td></tr>`

    `<table className='table'>
      <thead>
        <tr>
          <th className='col-sm-8'>Filename</th>
          <th className='col-sm-3'>Uploaded on</th>
          <th className='col-sm-1'></th>
        </tr>
      </thead>
      <tbody>
        {rows}
        {uploads}
        {errors}
      </tbody>
    </table>`


LogRow = React.createClass
  render: ->
    l = @props.log
    `<tr>
      <td>{l.filename}</td>
      <td>{l.create_date}</td>
      <td className='text-right'>
        <a href={l.url} data-method='delete' data-confirm='Delete this log?' className='btn btn-xs btn-danger'>
          <div className='glyphicon glyphicon-remove'/>
        </a>
      </td>
    </tr>`

UploadRow = React.createClass
  render: ->
    u = @props.upload
    fileParts = u.url.split('/')
    file = fileParts[fileParts.length - 1]
    `<tr>
      <td colSpan='2'>{file}</td>
      <td>{u.state}</td>
    </tr>`

ErrorRow = React.createClass
  render: ->
    u = @props.error
    fileParts = u.url.split('/')
    file = fileParts[fileParts.length - 1]
    `<tr>
      <td colSpan='2'>
        <p>{file}</p>
        <div className='alert alert-danger'>{u.error}</div>
      </td>
      <td className='text-right'>
        <a href={u.delete_url} data-method='delete' data-confirm='Delete this failed job?' className='btn btn-xs btn-danger'>
          <div className='glyphicon glyphicon-remove'/>
        </a>
      </td>
    </tr>`


