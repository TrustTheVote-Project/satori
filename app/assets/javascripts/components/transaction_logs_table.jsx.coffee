# %table.table
#   %thead
#     %tr
#       %th Filename
#       %th Origin
#       %th Created on
#       %th
#   - if @election.transaction_logs.blank?
#     %tr
#       %td{ colspan: 4 } No logs loaded yet
#   - else
#     - @election.transaction_logs.each do |l|
#       %tr
#         %td= l.filename
#         %td= l.origin
#         %td= l.create_date.strftime("%B %d, %Y %l:%M%p")
#         %td.text-right
#           = link_to [ @election, l ], method: 'delete', data: { confirm: 'Delete this file?' }, class: 'btn btn-xs btn-danger' do
#             .glyphicon.glyphicon-remove

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


@TransactionLogsTable = React.createClass
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
        rows.push `<tr><td colSpan='4'>No logs loaded yet</td></tr>`
      else
        @state.data.logs.map (log) ->
          rows.push `<LogRow key={log.id} log={log}/>`

      @state.data.uploads.map (u) ->
        uploads.push `<UploadRow key={u.id} cols={2} upload={u}/>`

      (@state.data.errors || []).map (e) ->
        errors.push `<ErrorRow key={e.id} error={e}/>`
    else
      rows.push `<tr><td colSpan='2'>Loading data...</td></tr>`

    `<table className='table table-striped'>
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
      <td className='col-sm-12'>
        <PropertyRow label="Uploaded at" value={l.uploaded_at} />
        <PropertyRow label="Uplaoded by" value={l.uploaded_by} />
        <PropertyRow label="Origin" value={l.origin} />
        <PropertyRow label="Filename" value={l.filename} />
        <PropertyRow label="Earliest Event" value={l.earliest_event_at} />
        <PropertyRow label="Latest Event" value={l.latest_event_at} />
        <PropertyRow label="Total Events" value={l.events_count} />
      </td>
      <td className='text-center'>
        <a href={l.url} data-method='delete' data-confirm='Delete this log?' className='btn btn-xs btn-danger'>
          <div className='glyphicon glyphicon-remove'/>
        </a>
      </td>
    </tr>`

ErrorRow = React.createClass
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


