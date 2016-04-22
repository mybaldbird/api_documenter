module ApiDocumenter
  class Document
    def initialize
      @routes = []
    end
    def title t
      @title = t
    end
    def t
      @title
    end
    def add_route
      route = Route.new
      @routes << route
      yield(route)
    end
    def routes
      retval = ''
      @routes.each do |route|
        retval << %Q{
<div class='route' id='#{route.id}'>
<p>
<span class='verb'>#{route.v}</span>
<span class='uri'>#{route.u}</span>
</p>
#{route.req}
</div>
}
      end
      retval
    end
    def toc
      ret = []
      ret << "<div class='toc'>"
      @routes.each do |route|
        ret << "<a href='\##{route.id}'>#{route.v} #{route.u}</a>"
      end
      ret << "</div>"
      ret.join "\n"
    end
  end

  class Route
    def verb v
      @verb = v
    end
    def v
      @verb
    end
    def uri u
      @uri = u
    end
    def u
      @uri
    end
    def id
      (@verb + @uri).tr('/', '-')
    end
    def request
      @request = Request.new
      yield(@request)
    end
    def req
      %Q{
<div class='input'>
<p>#{@request.d}</p>
#{@request.s}
</div>
}
    end
  end

  class Request
    def description d
      @description = d
    end
    def d
      @description
    end
    def spec
      @spec = Spec.new
      yield(@spec)
    end
    def s
      ret = %Q{
<div class='spec'>
<table>
}
    @spec.t.each do |name, type, desc|
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
#{@spec.e}
</div>
}
    ret
    end
  end

  class Spec
    def table t
      @table = t
    end
    def t
      @table
    end
    def example e
      @example = e
    end
    def e
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
    d = Document.new
    yield(d)
    puts %Q{
<!DOCTYPE html>
<html lang='en'>
<head>
<meta charset='UTF-8' />
<html>
<head>
<title>#{d.t}</title>
<link href='css/style.css' rel='stylesheet' type='text/css' />
</head>
<body>
#{d.toc}
<div class='content'>
#{d.routes}
</div>
</body>
</html>
}
  end
end
