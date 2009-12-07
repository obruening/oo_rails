require 'odf-report'

class OrdersController < ApplicationController
  include ActionView::Helpers::NumberHelper


  def generate_odt(order, template_filename, output_filename)
    report = ODFReport.new(template_filename) do |r|
      r.add_field "CUSTOMER", order.customer
      r.add_field "ORDER_DATE", order.order_date

      items = order.items.find(:all, :order => 'id asc')

      total_item = Item.new(:total_price => order.items.sum(:total_price))

      items << total_item

      r.add_table("Tabelle_Items", items) do |row, item|
        if total_item == item
          row["NAME"] = ''
          row["AMOUNT"] = ''
          row["UNIT_PRICE"] = 'Gesamt'
          row["TOTAL_PRICE"] = number_to_currency(item.total_price, :unit => '€')
        else
          row["NAME"] = item.name
          row["AMOUNT"] = item.amount
          row["UNIT_PRICE"] = number_to_currency(item.unit_price, :unit => '€')
          row["TOTAL_PRICE"] = number_to_currency(item.total_price, :unit => '€')
        end
      end
    end

    report.generate(output_filename)
  end


  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    template_filename = "./order.odt"
    output_filename = "./order_out.odt"

    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
      format.odt do
        puts "in odt"
        generate_odt(@order, template_filename, output_filename)
        send_file(output_filename, :disposition => 'inline', :type => :odt)
      end
      format.pdf do
        output_pdf_filename = "./order_out.pdf"
        generate_odt(@order, template_filename, output_filename)
        openoffice_converter = OpenofficeConverter.new
        openoffice_converter.odt_to_pdf(output_filename, output_pdf_filename)
        send_file(output_pdf_filename, :disposition => 'inline', :type => :pdf)
      end
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        flash[:notice] = 'Order was successfully created.'
        format.html { redirect_to(@order) }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        flash[:notice] = 'Order was successfully updated.'
        format.html { redirect_to(@order) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
end
