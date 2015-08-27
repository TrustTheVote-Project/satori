actChangeSelector = Reflux.createAction()

SelectorStore = Reflux.createStore
  init: ->
    @data = 'progress'
    @listenTo actChangeSelector, @onChangeSelector

  getInitialState: ->
    @data

  onChangeSelector: (v) ->
    @data = v
    @trigger @data


ElectionsStore = Reflux.createStore
  init: ->
    @elections = []
    @allElections = gon.elections
    @listenTo SelectorStore, @onSelectorChange, @onSelectorChange

  getInitialState: ->
    @elections

  onSelectorChange: (v) ->
    if v == 'all'
      @elections = @allElections
    else
      @elections = _.select(@allElections, (e) -> !e.locked)
    @trigger @elections
    


@ElectionsList = React.createClass
  mixins: [
    Reflux.connect ElectionsStore, "elections"
  ]

  render: ->
    <div className='row'>
      <div className='col-sm-12'>
        <TypeSelector />
        <Table elections={this.state.elections} />
      </div>
    </div>

TypeSelector = React.createClass
  mixins: [
    Reflux.connect SelectorStore, "selector"
  ]

  handleChange: (e) ->
    actChangeSelector(e.target.value)

  render: ->
    <div className='row'>
      <div className='col-sm-4'>
        <div className='form-group'>
          <select className='form-control' value={this.state.selector} onChange={this.handleChange}>
            <option value='progress'>Show Reporting In-Progress</option>
            <option value='all'>Show All Elections</option>
          </select>
        </div>
      </div>
    </div>

Table = React.createClass
  render: ->
    e = @props.elections

    if e.length == 0
      nodes = <tr>
        <td>{I18n.t("user_dashboard.show.none")}</td>
      </tr>
    else
      nodes = e.map (el) ->
        <ElectionRow key={el.id} election={el} />

    <div className='row'>
      <div className='col-sm-12 no-pad'>
        <table className='table table-striped'>
          {nodes}
        </table>
      </div>
    </div>


ElectionRow = React.createClass
  render: ->
    e = @props.election

    <tr>
      <td>
        Election Name: <a href={e.url}>{e.name}</a><br/>
        Election Date: {e.held_on}<br/>
        Start/End Dates for Reporting: {e.voter_start_on} - {e.voter_end_on}<br/>
        Owner: {e.owner}
      </td>
      <td className="text-right">
        <a href={e.url} className="btn btn-xs btn-info">Select</a>
      </td>
    </tr>

#           %tr
#             %td
#               Election Name: #{link_to e.name, e}<br/>
#               Election Date: #{e.held_on.try(:strftime, "%d %B %Y")}<br/>
#               Start/End Dates for Reporting: #{e.voter_start_on.try(:strftime, "%d %B %Y")} - #{e.voter_end_on.try(:strftime, "%d %B %Y")}<br/>
#               Owner: #{e.owner.try(:full_name) || 'Unknown'}
#             %td.text-right
#               = link_to "Select", e, class: 'btn btn-xs btn-info'
#               -# = link_to "Delete", e, method: 'delete', data: { confirm: 'Delete this election?' }, class: 'btn btn-xs btn-danger'
