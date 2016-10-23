var MlborderEventBorderBox = React.createClass({
  getInitialState : function() {
    return {data: []};
  },
  render: function() {
    var chartBox;
    if(this.isBorderLoaded()) {
      chartBox = <div id={this.props.chart_div_id} className='chart-area' />;
    } else {
      chartBox = (
        <div id={this.props.chart_div_id} className="text-center" style={this.style.borderSummary} className='chart-area' >
          <i className="fa fa-spin fa-spinner"></i>
          Loading...
        </div>
      );
    }

    return (
      <div className='row'>
        <div className='col-md-9'>
          {chartBox}
        </div>
        <div className='col-md-3'>
          <div className='row' style={this.style.borderSummary}>
            <MlborderEventBorderBoxSummary time={this.props.border_summary.time} title_map={this.props.title_map} data={this.props.border_summary.borders} />
          </div>
          <div className='row'>
            <div className='col-md-12'>
              <div id={this.props.legend_div_id} style={this.style.legendDiv}></div>
            </div>
          </div>
        </div>
      </div>
    );
  },
  componentDidMount : function() {
    this.loadBorder();
  },
  componentDidUpdate : function () {
    if(this.isBorderLoaded()) {
      window.createAmCharts(this.props.chart_div_id, this.props.legend_div_id, this.props.display_until, this.props.title_map, this.state.data);
    } else {
      this.loadBorder();
    }
  },
  style: {
    borderSummary: {
      marginTop: "1.5em"
    },
    legendDiv: {
      maxWidth: "240px"
    }
  },
  isBorderLoaded : function () {
    return (this.state.data.length > 0);
  },
  loadBorder : function () {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({data: data});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(status, err.toString());
      }.bind(this)
    });
  },
});

var MlborderEventBorderBoxSummary = React.createClass({
  render: function() {
    var recent = new Date(this.props.time);
    var adjustedDate = new Date(recent.getTime() - (recent.getTimezoneOffset() * 60000));
    var timeString = (
      adjustedDate.getUTCFullYear() + '/'
      + ('00' + String(adjustedDate.getUTCMonth() + 1)).substr(-2) + '/'
      + ('00' + String(adjustedDate.getUTCDate())).substr(-2) + ' '
      + ('00' + String(adjustedDate.getUTCHours())).substr(-2) + ':'
      + ('00' + String(adjustedDate.getUTCMinutes())).substr(-2)
    );

    var borderList = Object.keys(this.props.data).map(function(idx) {
      var title = this.props.title_map ? this.props.title_map[idx] : (idx + '位');
      return <MlborderEventBorderBoxSummaryData key={idx} title={title} point={this.props.data[idx]} />
    }, this);

    return (
      <div className='col-md-12'>
        <div className="panel panel-default">
          <div className="panel-heading">
            {timeString}時点
          </div>
          <table className='table'>
            <tbody>
              {borderList}
            </tbody>
          </table>
        </div>
      </div>
    );
  }
});

var MlborderEventBorderBoxSummaryData = React.createClass({
  render: function() {
    var pointWithDelimiter = this.props.point.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

    return (
      <tr>
        <th className='text-right'>{this.props.title}:</th>
        <td>{pointWithDelimiter}pt</td>
      </tr>
    );
  }
});
