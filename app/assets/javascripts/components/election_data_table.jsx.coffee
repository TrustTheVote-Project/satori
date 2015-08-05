actLoadData = Reflux.createAction()
actLockData = Reflux.createAction()
actUnlockData = Reflux.createAction()

DataStore = Reflux.createStore
  init: ->
    @data = {}
    @listenTo actLoadData, @onLoadData
    @listenTo actLockData, @onLockData
    @listenTo actUnlockData, @onUnlockData

  getInitialState: -> @data

  onLoadData: ->
    $.getJSON gon.data_url, (data) =>
      @data = data
      @trigger @data

  onLockData: ->
    @data.locked = true
    @trigger @data

    $.post gon.lock_data_url, {}, ( (data) =>
      @data = data
      @trigger @data
    ), 'json'

  onUnlockData: ->
    @data.locked = false
    @trigger @data

    $.post gon.unlock_data_url, {}, ( (data) =>
      @data = data
      @trigger @data
    ), 'json'


@ElectionDataTable = React.createClass
  mixins: [
    Reflux.connect DataStore, "data"
  ]

  componentDidMount: ->
    actLoadData()
    setInterval ( () => actLoadData() ), 5000

  render: ->
    `<div>
      <StatusLine data={this.state.data}/>
      <Buttons data={this.state.data}/>
      <Table data={this.state.data}/>
    </div>`


StatusLine = React.createClass
  render: ->
    data    = @props.data
    noDemog = !data.has_demog
    noVTL   = !data.has_vtl

    if data.locked
      `<p>Complete data</p>`
    else
      if noDemog and noVTL
        `<p>No data is available currently</p>`
      else if noDemog
        `<p>Voter administration log data details are below. Voter demographic data is not available currently.</p>`
      else if noVTL
        `<p>Voter demographic data details are below. Voter administration log data is not available currently.</p>`
      else
        null


Buttons = React.createClass
  render: ->
    data    = @props.data

    if data.locked
      actions = [
        `<a onClick={actUnlockData} data-confirm='Are you sure to unlock?' className='btn btn-default'>Unlock Data</a>`
      ]
    else
      noDemog = !data.has_demog
      noVTL   = !data.has_vtl
      lockDisabled = noDemog || noVTL
      actions = [
        `<a href={gon.new_vtl_url} className='btn btn-default'>Upload Voter Administration Log Data</a>`,
        `<span>&nbsp;</span>`
        `<a href={gon.new_demog_file_url} className='btn btn-default'>Upload Voter Demographic Data</a>`
        `<span>&nbsp;</span>`
        `<a onClick={actLockData} disabled={lockDisabled} data-confirm='Are you sure to lock?' className='btn btn-default'>Lock Data</a>`
      ]

    `<p className='text-right'>
      {actions}
    </p>`


Table = React.createClass
  render: ->
    data = @props.data

    rows = (data.rows || []).map (r) ->
      `<Row key={r.id} row={r}/>`

    uploads = (data.uploads || []).map (u) ->
      `<UploadRow key={u.id} cols={2} upload={u}/>`

    errors = (data.errors || []).map (e) ->
      `<ErrorRow key={e.id} error={e}/>`

    `<table className='table table-striped'>
      <tbody>
        {rows}
        {uploads}
        {errors}
      </tbody>
    </table>`


Row = React.createClass
  render: ->
    l = @props.row

    if l.type == 'vtl'
      dataType = 'Voter Administration'
      customRows = [
        `<PropertyRow label="Earliest Event" value={l.earliest_event_at} />`
        `<PropertyRow label="Latest Event" value={l.latest_event_at} />`
        `<PropertyRow label="Total Events" value={l.events_count} />`
      ]
    else
      dataType = 'Voter Demographics'
      customRows = [
        `<PropertyRow label="Total Records" value={l.records_count} />`
      ]

    `<tr>
      <td className='col-sm-12'>
        <PropertyRow label="Data Type" value={dataType} />
        <PropertyRow label="Uploaded at" value={l.uploaded_at} />
        <PropertyRow label="Uplaoded by" value={l.uploaded_by} />
        <PropertyRow label="Origin" value={l.origin} />
        <PropertyRow label="Filename" value={l.filename} />
        {customRows}
      </td>
      <td className='text-center'>
        <a href={l.url} data-method='delete' data-confirm='Delete this data file?' className='btn btn-xs btn-danger'>
          <div className='glyphicon glyphicon-remove'/>
        </a>
      </td>
    </tr>`
