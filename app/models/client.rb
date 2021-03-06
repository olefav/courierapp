class Client < ActiveRecord::Base
  
  include Filterable
  
  after_initialize :create_associated, :if => :new_record?
  after_destroy :destroy_address

  has_many :contacts, dependent: :destroy
  accepts_nested_attributes_for :contacts, :reject_if => :all_blank, allow_destroy: true

  belongs_to :address
  accepts_nested_attributes_for :address,  :reject_if => :all_blank, update_only: true
  
  has_many :sended_orders, :class_name => Order, :foreign_key => :sender_id
  has_many :received_orders, :class_name => Order, :foreign_key => :receiver_id
  
  validates :last_name, presence: true
  validates :first_name, :patronymic, presence: false, if: Proc.new { |client| !client.is_person }
  
  validates :address, presence: true
  
  scope :by_is_person,  -> isp   { where("is_person = ?", (isp == 0 ? false : true)) }
  scope :by_last_name,  -> lname { where("last_name LIKE ?", lname) }
  scope :by_first_name, -> fname { where("first_name LIKE ?", fname) }
  scope :by_patronymic, -> patr  { where("patronymic LIKE ?", patr) }
  scope :by_address_str, -> addr { includes(:address).where("addresses.city LIKE ? OR addresses.street LIKE ?", addr, addr) }

  def full_name
    last_name + ' ' + (first_name.nil? ? '' : first_name) + ' ' + (patronymic.nil? ? '' : patronymic)
  end


  def create_associated
    self.contacts.build if self.contacts.empty?
    self.build_address unless self.address
  end

  def destroy_address
    self.address.destroy if self.address
  end
end
