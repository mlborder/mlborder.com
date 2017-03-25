module EventsHelper
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
    idol_text_list = prizes.map { |pz| "<span style='color: #{pz.idol.color}'><i class='fa fa-fw fa-square'></i></span>#{pz.idol.name.shorten}" }

    if prizes.count > 2
      "#{idol_text_list.first(2).join('／')}、他#{prizes.count - 2}名".html_safe
    elsif prizes.any?
      if prizes.count > 1
        idol_text_list.join('／').html_safe
      else
        "<span style='color: #{prizes.first.idol.color}'><i class='fa fa-fw fa-square'></i></span>#{prizes.first.idol.name}".html_safe
      end
    else
      '-'
    end
  end

  def ula_final_titles
    { 1 => 'A:レジェンドデイズ',
      2 => 'B:乙女ストーム',
      3 => 'C:クレシェンドブルー',
      4 => 'D:エターナルハーモニー',
      5 => 'E:リコッタ',
      6 => 'F:灼熱少女',
      7 => 'G:BIRTH',
      8 => 'H:ミックスナッツ',
      9 => 'I:ミルキーウェイ',
      10 => 'J:ARRIVE',
    }
  end
end
