module EventsHelper
  def am_charts(progress)
    series = progress.first.keys.select { |k| k.include? 'border_' }.map do |border|
      rank = border.match(/\d+/).to_s.to_i
      { 'valueAxis' => 'v1',
        'bullet' => 'round',
        'bulletBorderThickness' => 1,
        'hideBulletsCount' => 30,
        'title' => "#{rank}位",
        'valueField' => border,
        'balloonText' => "[[title]]:[[value]]pt",
        'fillAlphas' =>  0,
        'hidden' => (rank < 100)
      }
    end

    graph=<<-EOJS
<div id="chartdiv" style='width:100%; height: 500px;'></div>
<script>
  (function() {
  var chartData = #{raw progress.to_json};
  var parseTime = function(category, dataItem, categoryAxis) {
    var period = new Date(category * 1000);
    var options = {
      day: "numeric", hour: "2-digit", minute: "2-digit"
    };
    return period.toLocaleTimeString("ja-JP", options);
  };

  var chart = AmCharts.makeChart("chartdiv", {
    "type": "serial",
    "theme": "light",
    "pathToImages": "http://www.amcharts.com/lib/3/images/",
    "legend": {
      "useGraphSettings": true,
      "valueAlign": "left"
    },
    "dataProvider": chartData,
    "valueAxes": [{
      "id":"v1",
      "axisThickness": 2,
      "gridAlpha": 0,
      "axisAlpha": 1,
      "position": "left"
     }],
    "graphs": #{raw series.to_json},
    "chartScrollbar": {},
    "chartCursor": {
      "cursorPosition": "mouse"
    },
    "categoryField": "time",
    "categoryAxis": {
      "categoryFunction" : parseTime,
      "axisColor": "#DADADA",
      "minorGridEnabled": true,
      "labelRotation": 45
    },
    "export": {
      "enabled": true,
      "position": "bottom-right",
      "libs": {
        "path": "http://www.amcharts.com/lib/3/plugins/export/libs/"
      }
    }
  });

  var zoom_start = 0;
  var zoom_end = chart.dataProvider.length - 1;

  var zoomChart = function() {
    chart.zoomToIndexes(zoom_start, zoom_end);
  };

  var updateZoomIndex = function(e) {
    zoom_start = e.startIndex;
    zoom_end = e.endIndex;
  };

  chart.addListener("dataUpdated", zoomChart);
  chart.addListener("zoomed", updateZoomIndex);
  })();
</script>
  EOJS

  raw graph
  end

  def am_charts_hhp(dataset)
    series = dataset.first.keys.select { |k| k.include? 'border_' }.map do |border|
      idol_id = border.match(/\d+/).to_s.to_i
      { 'valueAxis' => 'v1',
        'bullet' => 'round',
        'bulletBorderThickness' => 1,
        'hideBulletsCount' => 30,
        'title' => "#{Pro765.send(Rubimas::Idol.names[idol_id - 1]).name}",
        'valueField' => border,
        'balloonText' => "[[title]]:[[value]]pt",
        'fillAlphas' =>  0,
      }
    end

    graph=<<-EOJS
<div id="chartdiv" style='width:100%; height: 500px;'></div>
<script>
  (function() {
  var chartData = #{raw dataset.to_json};
  var getCategoryLabel = function(category, dataItem, categoryAxis) {
    var period = new Date(category * 1000);
    var options = {
      day: "numeric", hour: "2-digit", minute: "2-digit"
    };

    var label = period.toLocaleTimeString("ja-JP", options);
    label += "(" + dataItem.reward_rank + "枠)";
    return label;
  };

  var chart = AmCharts.makeChart("chartdiv", {
    "type": "serial",
    "theme": "light",
    "pathToImages": "http://www.amcharts.com/lib/3/images/",
    "legend": {
      "useGraphSettings": true,
      "valueAlign": "left"
    },
    "dataProvider": chartData,
    "valueAxes": [{
      "id":"v1",
      "axisThickness": 2,
      "gridAlpha": 0,
      "axisAlpha": 1,
      "position": "left"
     }],
    "graphs": #{raw series.to_json},
    "chartScrollbar": {},
    "chartCursor": {
      "cursorPosition": "mouse"
    },
    "categoryField": "time",
    "categoryAxis": {
      "categoryFunction" : getCategoryLabel,
      "axisColor": "#DADADA",
      "minorGridEnabled": true,
      "labelRotation": 45
    },
    "export": {
      "enabled": true,
      "position": "bottom-right",
      "libs": {
        "path": "http://www.amcharts.com/lib/3/plugins/export/libs/"
      }
    }
  });

  var zoom_start = 0;
  var zoom_end = chart.dataProvider.length - 1;

  var zoomChart = function() {
    chart.zoomToIndexes(zoom_start, zoom_end);
  };

  var updateZoomIndex = function(e) {
    zoom_start = e.startIndex;
    zoom_end = e.endIndex;
  };

  chart.addListener("dataUpdated", zoomChart);
  chart.addListener("zoomed", updateZoomIndex);
  })();
</script>
  EOJS

  raw graph
  end
end
