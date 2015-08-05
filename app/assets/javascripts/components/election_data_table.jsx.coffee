actLoadData = Reflux.createAction()

DataStore = Reflux.createStore
  init: ->
    @data = {}
    @listenTo actLoadData, @onLoadData

  getInitialState: -> @data

  onLoadData: ->
    $.getJSON gon.data_url, (data) =>
      @data = data
      @trigger @data


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
      <Table data={this.state.data}/>
    </div>`


StatusLine = React.createClass
  render: ->
    data = @props.data
    noDemog = !data.has_demog
    noVTL   = !data.has_vtl

    if noDemog and noVTL
      `<p>No data is available currently</p>`
    else if noDemog
      `<p>Voter administration log data details are below. Voter demographic data is not available currently.</p>`
    else if noVTL
      `<p>Voter demographic data details are below. Voter administration log data is not available currently.</p>`
    else
      null


Table = React.createClass
  render: ->
    data = @props.data

    rows = (@props.data.rows || []).map (r) ->
      `<Row key={r.id} row={r}/>`

    uploads = []
    errors  = []

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
