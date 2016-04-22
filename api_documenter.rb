module ApiDocumenter
  module_function
  def document title
    @route_ids = []
    @routes = []
    yield
    puts %Q{
<!DOCTYPE html>
<html lang='en'>
<head>
<meta charset='UTF-8' />
<html>
<head>
<title>#{title}</title>
<link href='css/style.css' rel='stylesheet' type='text/css' />
</head>
<body>
#{toc}
<div class='content'>
#{@routes.join}
</div>
</body>
</html>
}
  end
  def route verb: '', uri: ''
    id = {verb: verb, uri: uri}
    @route_ids << id
    @route_content = []
    yield
    @routes << %Q{
<div class='route' id='#{route_id(id)}'>
<p>
<span class='verb'>#{verb}</span>
<span class='uri'>#{uri}</span>
</p>
#{@route_content.join}
</div>
}
  end
  def request desc
    @route_content << %Q{
<div class='input'>
<p>#{desc}</p>
#{yield}
</div>
}
  end
  def spec rows
    ret = %Q{
<div class='spec'>
<table>
}
    rows.each do |name, type, desc|
      ret << %Q{
<tr>
<td class='name'>
<span class='name'>#{name}</span>
<span class='type'>#{type}</span>
</td>
<td class='description'>#{desc}</td>
</tr>
}
    end
    ret << %Q{
</table>
#{example(yield) if block_given?}
</div>
}
    ret
  end

  private
    def toc
      ret = []
      ret << "<div class='toc'>"
      @route_ids.each do |id|
        ret << "<a href='\##{route_id(id)}'>#{id[:verb]} #{id[:uri]}</a>"
      end
      ret << "</div>"
      ret.join "\n"
    end
    def route_id id
      "#{id[:verb] + id[:uri]}".tr('/', '-')
    end
    def example hash
      return unless hash      
      ret = []
      ret << "<div class='example'>"
      ret << "<p>Example</p>"
      ret << "<pre>{"
      hash.each do |k, v|
        ret << %Q{ <span class='json-key'>"#{k}"</span>: "#{v}"}
      end
      ret << "}</pre>"
      ret << "</div>"
      ret.join "\n"
    end
end
