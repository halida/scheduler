class Scheduler::Searcher

  EXECUTION_DISPLAY_AS = {
    'list' => "List",
    'day' => "One day",
  }

  class << self

    def applications(items, params)
      if params[:keyword].present?
        items = items.where("name like ?", "%#{params[:keyword]}%")
      end
      items.paginate(page: params[:page])
    end

    def plans(items, params)
      if params[:keyword].present?
        items = items.where("title like ?", "%#{params[:keyword]}%")
      end

      items.
        preload(:execution_method, :routines, :application).
        paginate(page: params[:page])
    end

    def execution_display_as(v)
      EXECUTION_DISPLAY_AS.keys.include?(v) ? v : 'list'
    end

    def executions(items, display_as, begin_date, finish_date, during, params)
      case display_as
      when 'list'
        items = items.during(begin_date, finish_date+1.day) if during
        items = items.paginate(page: params[:page])
      when 'day'
        items = items.during(begin_date, begin_date+1.day)
      end

      if params[:exclude]
        items = items.joins(:plan)
        params[:exclude].split(",").each do |e|
          items = items.where.not("plans.title like ?", "%#{e}%")
        end
      end

      if params[:keyword]
        items = items.joins(:plan).where("plans.title like ?", "%#{params[:keyword]}%")
      end

      if status = params[:status].presence and
        status = status.select(&:present?).presence
        items = items.where(status: status)
      end

      items.preload(:plan, :routine).order(scheduled_at: :asc)
    end

  end
end
