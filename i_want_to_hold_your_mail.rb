require 'mechanize'

# make sure dates are not on sundays (or presumably holidays)
start_date = '21-10-2008'
end_date   = '31-10-2008'

agent = WWW::Mechanize.new

# enter zipcode
page1 = agent.get('https://holdmail.usps.com/duns/HoldMail.jsp')
form = page1.forms.name('TheForm').first
form.fields.name('action').value = 'CustomerInfo'
form.ZIP = '37204'
page2 = form.submit

# enter personal info
form = page2.forms.name('TheForm').first
form.fields.name('action').value = 'CustomerVerify'
form.FirstName = 'Kevin'
form.MiddleName = 'R'
form.LastName = 'Barnes'
form.Street = '2311 Knowles Ave'
form.Phone = '6152920935'
page3 = form.submit

# verify info and continue
verify_info = page3.search('//table[@summary=For formatting Only]//td')
if verify_info[0].inner_html.match(/kevin.*r.*barnes/i) and
    verify_info[1].inner_html.match(/2311.*knowles.*ave/i) and
    verify_info[2].inner_html.match(/nashville.*tn.*37204/i) and
    verify_info[3].inner_html.match(/615.*292.*0935/i)
  #   puts 'verification complete'
end
form = page3.forms.name('TheForm').first
form.fields.name('action').value = 'HoldC'
page4 = form.submit

# select start date
form = page4.forms.name('TheForm').first
form.fields.name('StartDate').options.detect { |o| o.value == start_date}.tick
form.fields.name('action').value = 'HoldC'
page4b = form.submit

# select end date and submit
form = page4b.forms.name('TheForm').first
form.fields.name('EndDate').options.detect { |o| o.value == end_date}.tick
form.radiobuttons.name('DeliveryOption')[0].check
form.fields.name('action').value = 'HoldCV'
page5 = form.submit

# verify request
form = page5.forms.name('TheForm').first
form.fields.name('action').value = 'HoldCC'
page6 = form.submit

puts page6.search('table/tr/td/b').to_html
