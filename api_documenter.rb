module ApiDocumenter
  class Document
    attr_accessor :title, :route, :routes
    def initialize
      @routes = []
    end
    def content
      retval = ''
      @routes.each do |r|
        retval << %Q{
<div class='route' id='#{r.id}'>
<p>
<span class='verb'>#{r.verb}</span>
<span class='uri'>#{r.uri}</span>
</p>
#{r.content}
</div>
}
      end
      retval
    end
    def toc
      retval = []
      retval << "<div class='toc'>"
      @routes.each do |r|
        retval << "<a href='\##{r.id}'>#{r.verb} #{r.uri}</a>"
      end
      retval << "</div>"
      retval.join "\n"
    end
  end

  class Route
    attr_accessor :verb, :uri, :context, :request
    def id
      (@verb + @uri).tr('/', '-')
    end
    def content
      %Q{
<div class='input'>
<p>#{@request.description}</p>
#{@request.content}
</div>
}
    end
  end

  class Request
    attr_accessor :description, :spec
    def content
      ret = %Q{
<div class='spec'>
<table>
}
    @spec.table.each do |name, type, desc|
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
#{@spec.content}
</div>
}
    ret
    end
  end

  class Spec
    attr_accessor :table, :example
    def content
      return unless @example      
      ret = []
      ret << "<div class='example'>"
      ret << "<p>Example</p>"
      ret << "<pre>{"
      pre = []
      @example.each do |k, v|
        case v
        when NilClass
          pre << %Q{  <span class='json-key'>"#{k}"</span>: <span class='json-token'>NULL</span>}
        when String
          pre << %Q{  <span class='json-key'>"#{k}"</span>: "#{v}"}
        else
          pre << %Q{  <span class='json-key'>"#{k}"</span>: <span class='json-token'>#{v}</span>}
        end
      end
      ret << pre.join(",\n")
      ret << "}</pre>"
      ret << "</div>"
      ret.join "\n"
    end
  end

  module_function
  def document
    @d = Document.new
    yield
    puts %Q{
<!DOCTYPE html>
<html lang='en'>
<head>
<meta charset='UTF-8' />
<html>
<head>
<title>#{@d.title}</title>
<link href='css/style.css' rel='stylesheet' type='text/css' />
</head>
<body>
#{@d.toc}
<div class='content'>
#{@d.content}
</div>
</body>
</html>
}
  end
  def title t
    @d.title = t
  end
  def add_route
    r = Route.new
    @d.route = r
    @d.routes << r
    yield
  end
  def verb v
    @d.route.verb = v
  end
  def uri u
    @d.route.uri = u
  end
  def request
    r = Request.new
    @d.route.request = r
    @d.route.context = r
    yield
  end
  def description d
    @d.route.context.description = d
  end
  def spec
    s = Spec.new
    @d.route.context.spec = s
    yield
  end
  def table t
    @d.route.context.spec.table = t
  end
  def example e
    @d.route.context.spec.example = e
  end
end
