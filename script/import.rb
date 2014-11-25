require 'csv'

fragrance_option = Spree::OptionType.where(name: 'fragrance', presentation: 'Fragrance').first_or_create!
shipping_category = Spree::ShippingCategory.first || Spree::ShippingCategory.create!(name: 'Default')

CSV.open('products.csv', headers: true).each_with_index do |row, i|
  price = row[2]
  price = price == 'Out of Stock' ? 9.99 : price[1..10].to_f
  product = Spree::Product.where(name: row[0], shipping_category_id: shipping_category.id).first_or_create
  product.description = row[3]
  product.price = price
  product.available_on = 1.day.ago
  product.save!

  fragrance = row[1]
  image = open(row[4])

  if fragrance.present?
    fragrance_value = Spree::OptionValue.where(option_type_id: fragrance_option.id, name: fragrance, presentation: fragrance).first_or_create!
    product.option_types << fragrance_option

    if product.variants.none? {|v| v.option_values.include?(fragrance_value) }
      variant = product.variants.create!
      variant.option_values << fragrance_value
      variant.images.create!(attachment: image)
    end
  end

  product.images.create!(attachment: image) if product.images.empty?

  print '.'
end

puts 'done'
