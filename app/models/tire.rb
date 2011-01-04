class Tire < ActiveRecord::Base
  attr_accessible :width, :sidewall, :diameter, :condition, :quantity, :price

  belongs_to :user

  # WIDTHS = [145,155,165,175,185,195,205,215,225,235,245,255,265,275,285,295,305,315,325,335,345,355,365,375,395]
  WIDTHS = [145,155,165,175,185,195,205,215,225,235,245,255,265,275,285,295]
  SIDEWALLS = [20,25,30,35,40,45,50,55,60,65,70,75,80,85]
  # DIAMETERS = [10,12,13,14,15,16,16.5,17,17.5,18,19,19.5,20,21,22,23,24,25,26,28,30]
  DIAMETERS = [10,12,13,14,15,16,16.5,17,17.5,18,19,19.5,20,21,22,23,24,25]
  # CONDITIONS = [100,90,80,70,60,50,40,30,20,10]
  CONDITIONS = [100,80,60,40,20,0]
  PRICES = [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100]

  validates :width, :presence => true, :inclusion => {:in => WIDTHS}
  validates :sidewall, :presence => true, :inclusion => {:in => SIDEWALLS}
  validates :diameter, :presence => true, :inclusion => {:in => DIAMETERS}
  validates :condition, :presence => true, :inclusion => {:in => CONDITIONS}
  validates :price, :presence => true, :inclusion => {:in => PRICES}

  # validates :quantity, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 1}
  # validates :quantity, :presence => false

  # default_scope :order => 'diameter DESC'

=begin
  def increment
    self.quantity += 1
    logger.debug self.inspect
  end

  def decrement
    self.quantity -= 1
  end
=end
end
