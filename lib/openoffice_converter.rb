include Java

Dir['jars/jodconverter-2.2.2/lib/*.jar'].each do |r|
  require r
end


class OpenofficeConverter

  def odt_to_pdf(input_filename, output_filename)
    input_file = java.io.File.new(input_filename)
    output_file = java.io.File.new(output_filename)

    # connect to an OpenOffice.org instance running on port 8100
    connection = com.artofsolving.jodconverter.openoffice.connection.SocketOpenOfficeConnection.new('localhost', 8100)
    connection.connect()

    # convert
    converter = com.artofsolving.jodconverter.openoffice.converter.OpenOfficeDocumentConverter.new(connection)
    converter.convert(input_file, output_file)

    # close the connection
    connection.disconnect()
  end
  
end


