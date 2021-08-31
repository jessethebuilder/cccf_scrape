class RosterScraper
  INDEX_URL = 'https://websrv23.clallam.net/NewWorld.InmateInquiry/WA0050000?Page='

  def initialize
    @ghost = Capybara::Session.new(:selenium_chrome_headless)
  end

  def scrape
    number = 1
    while scrape_index_page(number)
      number += 1
    end
  end

  def scrape_inmate(href)
    @ghost.visit href

    number = @ghost.find('.SubjectNumber span').text

    puts "Scraping Inmate #{number}"

    inmate = Inmate.find_or_initialize_by(number: number)

    inmate.update(
      name: @ghost.find('.Name span').text,
      age: @ghost.find('.Age span').text,
      gender: @ghost.find('.Gender span').text,
      url: href
    )

    # scrape_bond(inmate)
    scrape_bookings(inmate)
  end

  private

  def scrape_index_page(number)
    @ghost.visit index_page(number)
    return false if index_page_has_no_records?

    walk_index_page!

    return true
  end

  def walk_index_page!
    links = @ghost.find_all('.Name a').map{ |link| link['href'] }

    links.each do |link|
      scrape_inmate(link)
    end
  end

  def scrape_booking(element, inmate)
    number = element.find('.Booking h3 span').text

    booking = inmate.bookings.find_or_initialize_by(number: number)

    booking.update(
      number: number,
      date: parse_date_string(element.find('.BookingDate span').text),
      release_date: parse_date_string(element.find('.ReleaseDate span').text),
      scheduled_release_date: parse_date_string(element.find('.ScheduledReleaseDate span').text),
      facility: element.find('.HousingFacility span').text,
      origin: element.find('.BookingOrigin span').text,
      total_bond_amount: element.find('.TotalBondAmount span').text.gsub('$', '').gsub(',', ''),
      total_bail_amount: element.find('.TotalBailAmount span').text.gsub('$', '').gsub(',', '')
    )

    scrape_charges(element, booking)
  end

  def scrape_bookings(inmate)
    @ghost.find_all('.Booking').each{ |element| scrape_booking(element, inmate) }
  end

  def scrape_charge(element, booking)
    docket_number = element.find('.DocketNumber').text
    charge = Charge.new(docket_number: docket_number)

    bond = scrape_bond(element, charge)
    court = scrape_court(element, charge)

    charge.update(
      booking: booking,
      bond: bond,
      court: court,
      description: element.find('.ChargeDescription').text,
      offense_date: parse_date_string(element.find('.OffenseDate').text),
      disposition: element.find('.Disposition').text,
      disposition_date: element.find('.DispositionDate').text,
      arrested_by: element.find('.ArrestingAgencies').text,
      commit: element.find('.AttemptCommit').text
    )
  end

  def scrape_court(element, charge)
    number = element.find('.SeqNumber').text

    @ghost.find_all('.BookingCourtInfo tbody tr').each do |row|
      break if row.text == 'No data'
      next unless row.find('.Charges').text == number
      return row.find('.Court').text
    end

    return nil
  end

  def scrape_charges(element, booking)
    element.find_all('.BookingCharges tbody tr').each do |charge_element|
      scrape_charge(charge_element, booking)
    end
  end

  def scrape_bond(element, charge)
    bond_number = element.find('.ChargeBond').text

    return nil if bond_number.blank?

    @ghost.find_all('.BookingBonds tbody tr').each do |row|
      next unless row.find('.BondNumber').text == bond_number

      bond = Bond.find_or_initialize_by(number: bond_number)

      bond.update(
        bond_type: row.find('.BondType').text,
        amount: row.find('.BondAmount').text
      )

      return bond
    end

    return nil
  end

  def index_page_has_no_records?
    /Showing (\d+) to \d+ of (\d+)/ =~ @ghost.find('.ShowingRecordCount').text
    return $1.to_i > $2.to_i
  end

  def index_page(number)
    "#{INDEX_URL}#{number}"
  end

  def parse_date_string(date)
    return nil if date.blank?

    /(\d+)\/(\d+)\/(\d+) (.+)\z/ =~ date
    formatted_date = "#{$3}-#{$1}-#{$2} #{$4}"
    Time.parse(formatted_date).in_time_zone('Pacific Time (US & Canada)')
  end
end
