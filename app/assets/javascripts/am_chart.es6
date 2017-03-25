$(document).on('ready', () => {
  const getCategory = function(category, dataItem, categoryAxis) {
    const period = new Date(category * 1000);
    const reward = dataItem.reward_rank;
    const options = { day: "numeric", hour: "2-digit", minute: "2-digit" };
    if (reward === undefined) {
      return period.toLocaleTimeString("ja-JP", options);
    } else {
      return period.toLocaleTimeString("ja-JP", options) + '(' + (reward || 1) + '枠)';
    }
  };
  const createAmCharts = function (chart_elm_id, legend_elm_id, display_until, title_map, color_map, data) {
    var chart = AmCharts.makeChart(
      chart_elm_id,
      { "type": "serial",
        "theme": "light",
        "pathToImages": "http://www.amcharts.com/lib/3/images/",
        "legend": {
        "divId": legend_elm_id,
        "useGraphSettings": true,
        "labelText": "[[title]]",
        "valueText": "",
        "valueAlign": "left"
      },
      "valueAxes": [
        { "id":"v1",
          "axisThickness": 2,
          "gridAlpha": 0,
          "axisAlpha": 1,
          "labelFunction": function(value, valueText, valueAxis) {
          if (value === 0) return 0;
          const s = ['', '万', '億'];
          const e = Math.floor(Math.log(value) / Math.log(10000));
          return parseFloat((value / Math.pow(10000, e)).toFixed(1)) + s[e];
        },
        "position": "left"
        }
      ],
      "chartScrollbar": {},
      "chartCursor": {
        "cursorPosition": "mouse"
      },
      "categoryField": "time",
      "categoryAxis": {
        "categoryFunction" : getCategory,
        "axisColor": "#DADADA",
        "minorGridEnabled": true,
        "labelRotation": 45
      },
      "responsive": {
        "enabled": true,
        "addDefaultRules": false,
        "rules": [
          { "minWidth": 200,
            "maxWidth": 800,
            "maxHeight": 800,
            "minHeight": 200,
            "overrides": {
            "legend": {
              "valueAlign": "right",
              "enabled": true
            }
          }
          }
        ]
      }
      }
    );
    let zoom_start = 0;
    let zoom_end = 1;
    chart.addListener("dataUpdated", function() {
      chart.zoomToIndexes(zoom_start, zoom_end);
    });
    chart.addListener("zoomed", function(e) {
      zoom_start = e.startIndex;
      zoom_end = e.endIndex;
    });
    if (data) updateAmCharts(chart, display_until, title_map, color_map, data);
    return chart;
  };
  const updateAmCharts = function(chart, display_until, title_map, color_map, data) {
    const graph_columns = jQuery.map(data[0], function(k, v) { return v; });
    const border_columns = jQuery.grep(graph_columns, function(c) {
      if (c.indexOf('border_') > -1) return true;
    });
    const graphs = jQuery.map(border_columns, function(border_column) {
      const idx = border_column.match(/\d+/)[0];
      const title = title_map ? title_map[idx] : `${idx}位`;

      const column_setting = {
        'valueAxis': 'v1',
        'bullet': 'round',
        'bulletBorderThickness': 1,
        'hideBulletsCount': 30,
        'title': title,
        'valueField': border_column,
        'balloonText': "[[title]]:[[value]]pt",
        'fillAlphas': 0,
        'hidden': (idx < display_until)
      };
      if (color_map) {
        column_setting.bulletColor = color_map[idx];
        column_setting.lineColor = color_map[idx];
      }

      return column_setting;
    });
    chart.dataProvider = data;
    chart.graphs = graphs;
    chart.zoomToIndexes(0, chart.dataProvider.length - 1);
    chart.validateData();
  };
  window.createAmCharts = createAmCharts;
});
