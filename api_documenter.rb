module ApiDocumenter
  class Document
    attr_accessor :context, :title, :description, :children
    def initialize
      @context = self
      @children = []
    end
    def content
      retval = %Q{
<p class='title'>#{@title}</p>
<p class='description'>#{parse_text(@description)}</p>
}
      @children.each { |c| retval << c.content }
      retval
    end
    def toc
      retval = %Q{
<div class='toc'>
}
      @children.each { |c| retval << c.toc }
      retval << %Q{
</div>
}
    end
  end

  class Group
    attr_accessor :name, :description, :id, :children
    def initialize
      @children = []
    end
    def content
      retval = %Q{
<div class='group' id='#{@id}'>
<p class='name'>#{@name}</p>
<p class='description'>#{parse_text(@description)}</p>
}
      @children.each { |c| retval << c.content }
      retval << %Q{
</div>
}
    end
    def toc
      retval = %Q{
<div>
<a href='\##{@id}'>#{@name}:</a>
}
      @children.each { |c| retval << c.toc }
      retval << %Q{
</div>
}
    end
  end

  class Route
    attr_accessor :verb, :uri, :request, :id
    def content
      %Q{
<div class='route' id='#{@id}'>
<p>
<span class='verb'>#{@verb}</span>
<span class='uri'>#{parse_uri}</span>
</p>
#{@request&.content}
</div>
}
    end
    def toc
      %Q{
<div><a href='\##{@id}'>#{@verb} #{parse_uri}</a></div>
}
    end
    def parse_uri
      retval = @uri&.gsub(/`([^`]*)`/, '&lt;\1&gt;')
    end
  end

  class Request
    attr_accessor :description, :spec
    def content
      retval = %Q{
<div class='request'>
<p>#{parse_text(@description)}</p>
<div class='spec'>
<table>
}
    @spec.table.each do |name, type, desc|
      retval << %Q{
<tr>
<td class='name'>
<span class='name'>#{name}</span>
<span class='type'>#{type}</span>
</td>
<td class='description'>#{parse_text(desc)}</td>
</tr>
}
    end
    retval << %Q{
</table>
#{@spec&.content}
</div>
</div>
}
    end
  end

  class Spec
    attr_accessor :table, :example
    def content
      return unless @example      
      retval = %Q(
<div class='example'>
<p>Example</p>
<pre>{
)
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
      retval << pre.join(",\n") << %Q(
}</pre>
</div>
)
    end
  end

  module_function
  def document
    @d = Document.new
    wrap_context(@d) { yield }
    puts %Q{
<!DOCTYPE html>
<html lang='en'>
<head>
<meta charset='UTF-8' />
<html>
<head>
<title>#{@d.title}</title>
<link href='css/style.css' rel='stylesheet' type='text/css' charset='UTF-8' />
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
  def group
    g = Group.new
    @d.context.children << g
    wrap_context(g) { yield }
  end
  def route
    r = Route.new
    @d.context.children << r
    wrap_context(r) { yield }
  end
  def request
    r = Request.new
    @d.context.request = r
    wrap_context(r) { yield }
  end
  def spec
    s = Spec.new
    @d.context.spec = s
    wrap_context(s) { yield }
  end
  def method_missing method, *args
    # forward setter calls to the object whose block we are in (@d.context)
    # wrap_context() sets @d.context
    new_method = "#{method}=".to_sym
    super unless @d # endless loop protection
    super unless @d.context.respond_to?(new_method) # endless loop protection
    @d.context.send(new_method, *args)
  end
  def wrap_context new_context
    # set the context before diving into the block
    prev_context = @d.context
    @d.context = new_context
    yield
    # then set it back when we exit out
    @d.context = prev_context
  end
  def parse_text text
    text.gsub(/\[([^\]:]*):([^\]]*)\]/, "<a href='\#\\1' class='link'>\\2</a>")
  end
end
