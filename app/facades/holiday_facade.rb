class HolidayFacade

  def holidays
    service.get_holidays.map do |data|
      Holiday.new(data)
    end
  end

  def service
    @_service ||= HolidayService.new
  end

end
