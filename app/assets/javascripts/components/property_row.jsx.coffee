@PropertyRow = React.createClass
  render: ->
    `<div className='row'>
      <div className='col-sm-2'>{this.props.label}:</div>
      <div className='col-sm-10'>{this.props.value}</div>
    </div>`
