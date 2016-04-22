module ApiDocumenter
  module_function
  def document title
    ret = []
    ret << "<html>"
    ret << "<head>"
    ret << "<title>#{title}</title>"
    ret << "</head>"
    ret << "<body>"
    body = yield
    ret << toc
    ret << "<div class='content'>"
    ret << body
    ret << "</div>"
    ret << "</body>"
    ret << "</html>"
    puts ret.join "\n"
  end
  def route verb: '', uri: ''
    @routes ||= []
    @routes << uri
    ret = []
    ret << "<div class='route'>"
    ret << "<p>"
    ret << "<span class='verb'>#{verb}</span>"
    ret << "<span class='uri'>#{uri}</span>"
    ret << "</p>"
    ret << yield
    ret << "</div>"
    ret.join "\n"
  end
  def request desc
    ret = []
    ret << "<div class='input'>"
    ret << "<p>#{desc}</p>"
    ret << yield
    ret << "</div>"
    ret.join "\n"
  end
  def spec rows
    ret = []
    ret << "<div class='spec'>"
    ret << "<table>"
    rows.each do |name, type, desc|
      ret << "<tr>"
      ret << "<td class='name'>"
      ret << "<span class='name'>#{name}</span>"
      ret << "<span class='type'>#{type}</span>"
      ret << "</td>"
      ret << "<td class='description'>#{desc}</td>"
      ret << "</tr>"
    end
    ret << "</table>"
    ret << example(yield) if block_given?
    ret.join "\n"
  end
  def example hash
    return unless hash      
    ret = []
    ret << "<pre>"
    ret << "{"
    hash.each do |k, v|
      ret << " \"#{k}\": \"#{v}\""
    end
    ret << "}"
    ret << "</pre>"
    ret.join "\n"
  end

  private
    def toc
      ret = []
      ret << "<div class='toc'>"
      @routes.each do |route|
        ret << "<p>#{route}</p>"
      end
      ret << "</div>"
      ret.join "\n"
    end
end
