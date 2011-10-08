require 'cached_forwardable.rb'

class KPIStatus
  extend CachedForwardable
  
  def initialize(kpistat_calc, targetkpi_calc)
    @kpistat_calc = kpistat_calc
    @targetkpi_calc = targetkpi_calc
  end
  
  def_delegator :@kpistat_calc, :kpi
  def_delegator :@kpistat_calc, :person
  
  def_delegator :@kpistat_calc, :consume_rate
  def_delegator :@kpistat_calc, :daily_data
  def_delegator :@kpistat_calc, :monthly_sum
  def_delegator :@kpistat_calc, :monthly_average
  def_delegator :@kpistat_calc, :daily_MoM
  def_delegator :@kpistat_calc, :monthly_MoM
  def_delegator :@kpistat_calc, :daily_YoY
  def_delegator :@kpistat_calc, :monthly_YoY
  def_delegator :@kpistat_calc, :weekly_sum
  def_delegator :@kpistat_calc, :weekly_average
  def_delegator :@kpistat_calc, :daily_WoW
  def_delegator :@kpistat_calc, :weekly_WoW
  def_delegator :@kpistat_calc, :monthly_average_diff
  def_delegator :@kpistat_calc, :monthly_remaining_days
  
  def_delegator :@targetkpi_calc, :daily_target
  def_delegator :@targetkpi_calc, :daily_ratio
  def_delegator :@targetkpi_calc, :monthly_target
  def_delegator :@targetkpi_calc, :monthly_ratio
  def_delegator :@targetkpi_calc, :weekly_target
  def_delegator :@targetkpi_calc, :weekly_ratio
  def_delegator :@targetkpi_calc, :monthly_BVA
  def_delegator :@targetkpi_calc, :weekly_BVA
  def_delegator :@targetkpi_calc, :daily_BVA
end