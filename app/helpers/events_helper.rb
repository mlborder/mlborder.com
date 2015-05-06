module EventsHelper
  def am_charts(progress)
    series = progress.first.keys.select { |k| k.include? 'border_' }.map do |border|
      { 'valueAxis' => 'v1',
        'bullet' => 'round',
        'bulletBorderThickness' => 1,
        'hideBulletsCount' => 30,
        'title' => "#{border.match(/(\d+)/)}位",
        'valueField' => border,
        'fillAlphas' =>  0
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
    console.log(category);
    console.log(dataItem);
    console.log(categoryAxis);
  };

  var chart = AmCharts.makeChart("chartdiv", {
    "type": "serial",
    "theme": "light",
    "pathToImages": "http://www.amcharts.com/lib/3/images/",
    "legend": {
      "useGraphSettings": true
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
      "minorGridEnabled": true
    },
    "export": {
      "enabled": true,
      "position": "bottom-right",
      "libs": {
        "path": "http://www.amcharts.com/lib/3/plugins/export/libs/"
      }
    }
  });

  var zoomChart = function() {
    chart.zoomToIndexes(chart.dataProvider.length - 20, chart.dataProvider.length - 1);
  };

  chart.addListener("dataUpdated", zoomChart);
  zoomChart();

  })();
</script>
  EOJS

  raw graph
  end
end
