$(document).on('turbolinks:load', () => {
  $('#js-misc-runners').each(() => {
    const urlFor = function(chartConfig) {
      const options = [];
      options.push('summarized=true');
      if (chartConfig.isDetail) options.push('detail=true');
      if (chartConfig.target) options.push(`target=${chartConfig.target}`);
      return `/misc/runners${chartConfig.format}?event=${chartConfig.event}&${options.join('&')}`;
    };
    const chartConfig = window.chartConfig;
    const chart = c3.generate({
      bindto: '#runners-chart',
      size: { height: 550 },
      point: { r: 0.5 },
      data: {
        url: urlFor(chartConfig),
        x: 'rank',
        colors: chartConfig.idolColors,
      },
      axis: {
        x: {
          label: 'rank',
          padding: {
            left: 0,
            right: 0
          },
          tick: {
            format: function (rank) {
              return rank + '位';
            }
          },
          min: (chartConfig.isDetail ? 200 : 1)
        },
        y: {
          label: 'point',
          padding: {
            top: 0,
            bottom: 0
          },
          tick: {
            format: function(value) {
              if (value == 0) return 0;
              const s = ['', '万', '億'];
              const e = Math.floor(Math.log(value) / Math.log(10000));
              return parseFloat((value / Math.pow(10000, e)).toFixed(1)) + s[e];
            },
            min: 0
          }
        }
      },
      zoom: {
        enabled: true,
        rescale: true
      },
      tooltip: {
        contents: function (dd, defaultTitleFormat, defaultValueFormat, color) {
          console.log(dd);
          const $$ = this;
          const config = $$.config;
          const titleFormat = config.tooltip_format_title || defaultTitleFormat;
          const nameFormat = config.tooltip_format_name || function (name) { return name; }
          const valueFormat = config.tooltip_format_value || defaultValueFormat;
          let text, i, title, value, name, bgcolor;
          const d = dd.sort(function (a, b) { return b.value - a.value; });
          for (i = 0; i < d.length; i++) {
            if (! (d[i] && (d[i].value || d[i].value === 0))) { continue; }
            if (! text) {
              title = titleFormat ? titleFormat(d[i].x) : d[i].x;
              text = "<table class='" + $$.CLASS.tooltip + "'>"
              text += (title || title === 0 ? "<tr><th colspan='6'>" + title + "</th></tr>" : "");
            }
            name = i + 1 + '. ' + nameFormat(d[i].name);
            value = valueFormat(d[i].value, d[i].ratio, d[i].id, d[i].index);
            bgcolor = $$.levelColor ? $$.levelColor(d[i].value) : color(d[i].id);
            if (i % 3 === 0) {
              text += "<tr class='" + $$.CLASS.tooltipName + "-" + d[i].id + "'>";
            }

            text += "<td class='name'><span style='background-color:" + bgcolor + "'></span>" + name + "</td>";
            text += "<td class='value'>" + value + "</td>";
            if (i % 3 === 2) text += "</tr>";
          }
          if (d.length % 3 != 0) {
            text += "<td class='name'></td><td class='value'></td><td class='name'></td><td class='value'></td></tr>";
          }
          return text + "</table>";
        }
      }
    });

    const idolNameDict = Object.keys(window.chartConfig.idolColors);
    const getIdolName = function (id) {
      return idolNameDict[id - 14];
    };

    document.getElementById('target-time').addEventListener('change', function(e) {
      chartConfig.target = e.target.selectedOptions[0].value;
      chart.load({
        url: urlFor(chartConfig)
      });
    });
    document.getElementById('specify-idol').addEventListener('change', function(e) {
      const idolId = e.target.selectedOptions[0].value;
      const idsForHide = [];
      for (let i = 0; i < e.target.options.length; i++) {
        const value = e.target.options.item(i).value;
        if (!value) continue;
        idsForHide.push(getIdolName(value));
      }
      chart.hide(idsForHide);
      chart.show([getIdolName(idolId)]);
    });
  });
});
