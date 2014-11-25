require 'mechanize'
require 'csv'

BASE_URL = 'http://www.mrsmeyers.com'

CSV($stdout) do |csv|

  csv << %w(#Product Fragrance Price Description Image URL)

  agent = Mechanize.new

  agent.get("#{BASE_URL}/section/Product/2155.uts") do |page|
    cells = page.search(".ss_table td")

    cells.each do |cell|
      category_title = cell.search('.ss_lbl_title').text
      next unless category_title != ''

      category_description = cell.search('.ss_lbl_desc').text
      category_path = cell.at('.ss_lbl_action a').attributes['href']

      agent.get("#{BASE_URL}/#{category_path}") do |page|
        products = page.search('.catalog-entity-thumbnail .widget-root')

        products.each do |product|

          product_path = product.at('.display-text a').attributes['href']

          price = product.at('.display-price a')
          product_price = price ? price.text.strip : 'Out of stock'
          product_url = "#{BASE_URL}/#{product_path}"

          agent.get(product_url) do |page|
            product_image = page.at('.productImage img').attributes['src']
            product_title = page.at('.description-container .item-name').text
            product_fragrance = page.at('.description-container .fragranceName').text
            product_description = page.at('.description-container .richtext').text

            csv << [product_title, product_fragrance, product_price, product_description, product_image, product_url]
          end
        end
      end
    end
  end
end
