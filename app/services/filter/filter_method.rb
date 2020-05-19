class Filter::FilterMethod
  def initialize(params ={})
    @array_list = params[:array_list]
    @filters = params[:filters]
  end

  def filtering
    if @filters.has_key?(:baby)
      @array_list = @array_list.where(baby_id: @filters[:baby])
    end

    if @filters.has_key?(:assistant)
      @array_list = @array_list.where(assistant_id: @filters[:assistant])
    end

    if @filters.has_key?(:status)
      if @filters[:status].eql?('in_progress')
        @array_list = @array_list.where(stop_time: nil)
      end

      if @filters[:status].eql?('finished')
        @array_list = @array_list.where.not(stop_time: nil)
      end
    end

    @array_list
  end
end