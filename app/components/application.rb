class Application < Netzke::Basepack::Viewport

  js_configure do |c|
    c.layout = :fit
    c.mixin
  end

  def configure(c)
    super
    c.intro_html = "Click on a demo component in the navigation tree"
    c.items = [
      { layout: :border,
        items: [
          { region: :west, item_id: :navigation, width: 300, split: true, xtype: :treepanel, root: menu, root_visible: false, title: "Navigation" },
          { region: :center, layout: :border, border: false, items: [
            { item_id: :info_panel, region: :north, height: 35, body_padding: 5, split: true, html: initial_html },
            { item_id: :main_panel, region: :center, layout: :fit, border: false, items: [{body_padding: 5, html: "Components will be loaded in this area"}] } # items is only needed here for cosmetic reasons (initial border)
          ]}
        ]
      }
    ]
  end

  #
  # Components
  #

  component :customers_list
  
  component :customer_bills_list
  
  component :vehicle_types_list
  
  component :products_list
  
  component :product_prices
  
  component :customer_vehicles_list
  
  component :invoices_list

protected

  def header_html
    %Q{
      <div style="color:#333; font-family: Helvetica; font-size: 150%;">
        <a style="color:#B32D15;" href="http://netzke.org">Netzke</a> demo app v0.10
      </div>
    }
  end

  def initial_html
    %Q{
      <div style="color:#333; font-family: Helvetica;">
        Shree Ankanatheshwara Fuel Service Station
      </div>
    }
  end

  def leaf(text, component, icon = nil)
    { text: text,
      icon: icon && uri_to_icon(icon),
      cmp: component,
      leaf: true
    }
  end

  def menu
    out = { :text => "Navigation",
      :expanded => true,
      :children => [
                leaf("Cutomers", :customers_list, :users),
                leaf("Bills", :customer_bills_list, :bill),                
                leaf("Invoices", :invoices_list, :bill),                
                leaf("Product Rates", :product_prices, :rupee),
                leaf("Customer Vehicles", :customer_vehicles_list, :lorry),
                leaf("Products", :products_list, :bunk),
                leaf("Vehicles", :vehicle_types_list, :lorry)               
              ]
    }
    out
  end
end
