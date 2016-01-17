var MlborderEventRecordBox = React.createClass({
  getInitialState : function() {
    return {data: [], isLoading: true};
  },
  render: function() {
    return (
      <div style={{marginTop: '1.5em'}}>
        <MlborderEventRecordBoxNavigation quickRanks={[1, 301, 501, 1201]} loadRecords={this.loadEventRecords} />
        <div style={{marginTop: '1em'}}/>
        <MlborderEventRecordBoxTable data={this.state.data} recordsUrl={this.props.recordsUrl} isLoading={this.state.isLoading} />
        <p className='text-right'><a href={this.props.url}>もっと見る</a></p>
      </div>
    );
  },
  componentDidMount : function() {
    this.loadEventRecords();
  },
  isRecordsLoaded : function () {
    return (this.state.data.length > 0);
  },
  loadEventRecords : function (page_num) {
    get_params = { page: (page_num || 1) };
    $.ajax({
      url: this.props.url + '?' + $.param(get_params),
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({data: data, isLoading: false});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(status, err.toString());
      }.bind(this)
    });
  },
});

var MlborderEventRecordBoxNavigation = React.createClass({
  render : function() {
    var navLinks = this.props.quickRanks.map(function(rank) {
      return <div className='btn btn-default' key={rank} onClick={this.navigationButtonHandler(rank, this)}>{rank}位〜</div>;
    }, this);

    return (
      <div className="btn-group btn-group-justified" role="group">
        {navLinks}
      </div>
    );
  },
  navigationButtonHandler : function (rank, self) {
    return function (e) {
      e.preventDefault();
      self.props.loadRecords(self.calcPageNumFromRank(rank));
      return;
    };
  },
  calcPageNumFromRank : function (rank) {
    return Math.ceil(rank / 50);
  }
});

var MlborderEventRecordBoxPager = React.createClass({
  render : function() {
    return (
      <ul className="pager">
        <li className="previous">
          <span aria-hidden="true">&larr;</span> 前へ
        </li>
        <li className="next">
          次へ <span aria-hidden="true">&rarr;</span>
        </li>
      </ul>
    );
  }
});

var MlborderEventRecordBoxTable = React.createClass({
  render : function() {
    var tableRows;
    if(this.props.isLoading) {
      tableRows = (
        <tr className='text-center'>
          <td colSpan='3'>
            <i className="fa fa-spin fa-spinner"></i>Loading...
          </td>
        </tr>
      );
    } else {
      tableRows = this.props.data.map(function(record) {
        return (
          <MlborderEventRecordBoxTableRow
            key={record.id} rank={record.rank} point={record.point}
            recordsUrl={this.props.recordsUrl}
            playerName={record.name} playerId={record.player_id} />
        );
      }, this);
    }

    return (
      <table className='table table-striped table-bordered'>
        <thead>
          <tr>
            <th>順位</th>
            <th>プレイヤー</th>
            <th>ポイント</th>
          </tr>
        </thead>
        <tbody>
          {tableRows}
        </tbody>
      </table>
    );
  }
});
var MlborderEventRecordBoxTableRow = React.createClass({
  render : function() {
    var pointWithDelimiter = this.props.point.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

    return (
      <tr>
        <td>{this.props.rank} 位</td>
        <td>
          <a href={this.props.recordsUrl + '?player_id=' + this.props.playerId}>
            {this.props.playerName || '【不明】id:' + this.props.playerId }
          </a>
          <a href={'http://imas.gree-apps.net/app/index.php/mypage/user_profile/id/' + this.props.playerId} target='_blank'>
            <span className='glyphicon glyphicon-new-window'></span>
          </a>
        </td>
        <td>{pointWithDelimiter} pt</td>
      </tr>
    );
  }
});
