jackets = [
  {jacket_type: 'raincoat', location: 'bedroom closet'}
]

jackets.each do |u|
  Jacket.create(u)
end
