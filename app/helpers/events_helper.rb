module EventsHelper
  def am_charts_hhp(dataset)
    border_meta = dataset.first.keys.select { |k| k.include? 'border_' }
    series = border_meta.map do |border|
      idol_id = border.match(/\d+/).to_s.to_i
      idol = Idol.find(idol_id)

      { 'valueAxis' => 'v1',
        'bullet' => 'round',
        'bulletBorderThickness' => 1,
        'bulletColor' => "#{idol.color}",
        'lineColor' => "#{idol.color}",
        'hideBulletsCount' => 30,
        'title' => "#{idol.name}",
        'valueField' => border,
        'balloonText' => "[[title]]:[[value]]pt",
        'fillAlphas' =>  0,
      }
    end
    idol_list = border_meta.map { |border| Idol.find(border.match(/\d+/).to_s.to_i) }

    graph=<<-EOJS
<select id="idol_change">
  #{idol_list.map { |idol| "<option value='border_#{idol.idol_id}'>#{idol.name}</option>" }.join('')}
</select>

<script>
  (function() {
  var chartData = #{raw dataset.to_json};
  var getCategoryLabel = function(category, dataItem, categoryAxis) {
    var period = new Date(category * 1000);
    var options = {
      day: "numeric", hour: "2-digit", minute: "2-digit"
    };

    var label = period.toLocaleTimeString("ja-JP", options);
    label += "(" + (dataItem.reward_rank || 1) + "枠)";
    return label;
  };

  var chart = AmCharts.makeChart("chartdiv", {
    "type": "serial",
    "theme": "light",
    "pathToImages": "http://www.amcharts.com/lib/3/images/",
    "legend": {
      "divId": "legenddiv",
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
  $('#idol_change').on('change', function(e) {
    option = e.target.selectedOptions[0];
    $.each(chart.graphs, function() {
      if (option.text == this.title) {
        chart.showGraph(this);
      } else {
        chart.hideGraph(this);
      }
    });
  });

  })();
</script>
  EOJS

  raw graph
  end

  def event_status_badge(event)
    cnf = \
      if event.ended?
        { name: 'finished', label_class: 'label-default' }
      elsif event.in_session?
        { name: 'ongoing', label_class: 'label-danger' }
      else
        { name: 'preparing', label_class: 'label-warning' }
      end

    raw "<span class='label #{cnf[:label_class]}'>#{t "event_status.#{cnf[:name]}"}</span>"
  end

  def event_type_badge(event)
    @event_type_config ||= YAML.load_file(Rails.root.join('config/event_type.yml').to_s)
    cnf = @event_type_config[event.event_type]

    raw "<span class='label #{cnf['label_class']}'>#{t "event_type.#{cnf['name']}"}</span>"
  end

  def prizes_text_for(prizes)
    idol_text_list = prizes.map { |pz| "<span style='border-bottom: 1px ridge #{pz.idol.color};'>#{pz.idol.name.split(' ').last}</span>" }

    if prizes.count > 3
      "#{idol_text_list.first(3).join('／')}／他#{prizes.count - 3}名".html_safe
    elsif prizes.any?
      if prizes.count > 1
        idol_text_list.join('／').html_safe
      else
        idol = prizes.first.idol
        "<span style='border-bottom: 1px ridge #{idol.color};'>#{idol.name}</span>".html_safe
      end
    else
      '-'
    end
  end
end
