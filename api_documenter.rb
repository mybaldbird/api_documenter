module ApiDocumenter
  class Document
    attr_accessor :context, :title, :description, :children
    def initialize
      @context = self
      @children = []
    end
    def content
      retval = <<~EOT
        <!DOCTYPE html>
        <html lang='en'>
          <head>
            <meta charset='UTF-8' />
            <title>#{@title}</title>
            <link href='css/style.css' rel='stylesheet' type='text/css' charset='UTF-8' />
          </head>
          <body>
        #{toc('    ')}
            <div class='content'>
              <p class='title'>#{@title}</p>
              <p class='description'>#{parse_text(@description)}</p>
      EOT
      @children.each { |c| retval << c.content('      ') }
      retval << <<~EOT
            </div>
          </body>
        </html>
      EOT
    end
    def toc i
      retval = <<~EOT
        #{i}<div class='toc'>
      EOT
      @children.each { |c| retval << c.toc(i + '  ') }
      retval << <<~EOT
        #{i}</div>
      EOT
    end
  end

  class Group
    attr_accessor :name, :description, :id, :children
    def initialize
      @children = []
    end
    def content i
      retval = <<~EOT
        #{i}<div class='group' id='#{@id}'>
          #{i}<p class='name'>#{@name}</p>
          #{i}<p class='description'>#{parse_text(@description)}</p>
      EOT
      @children.each { |c| retval << c.content(i + '  ') }
      retval << <<~EOT
        #{i}</div>
      EOT
    end
    def toc i
      retval = <<~EOT
        #{i}<div>
          #{i}<a href='\##{@id}'>#{@name}:</a>
      EOT
      @children.each { |c| retval << c.toc(i + '  ') }
      retval << <<~EOT
        #{i}</div>
      EOT
    end
  end

  class Route
    attr_accessor :verb, :uri, :id, :request, :responses
    def initialize
      @responses = []
    end
    def content i
      retval = <<~EOT
        #{i}<div class='route' id='#{@id}'>
          #{i}<p>
            #{i}<span class='verb'>#{@verb}</span>
            #{i}<span class='uri'>#{parse_uri}</span>
          #{i}</p>
        #{@request&.content(i + '  ')}
      EOT
      if @responses.size > 0
        retval << <<~EOT
          #{i}  <div class='responses'>
          #{i}    <p>Responses</p>
        EOT
        @responses.each { |r| retval << r.content(i + '    ') }
        retval << <<~EOT
          #{i}  </div>
        EOT
      end
      retval << <<~EOT
        #{i}</div>
      EOT
    end
    def toc i
      <<~EOT
        #{i}<div><a href='\##{@id}'>#{@verb} #{parse_uri}</a></div>
      EOT
    end
    def parse_uri
      retval = @uri&.gsub(/`([^`]*)`/, '&lt;\1&gt;')
    end
  end

  class Request
    attr_accessor :description, :spec
    def content i
      retval = <<~EOT
        #{i}<div class='request'>
          #{i}<p>#{parse_text(@description)}</p>
        #{@spec&.content(i + '  ')}
        #{i}</div>
      EOT
    end
  end

  class Response
    attr_accessor :title, :description, :spec
    def content i
      retval = <<~EOT
        #{i}<div class='response'>
          #{i}<p class='title'>#{@title}</p>
          #{i}<p>#{parse_text(@description)}</p>
        #{@spec&.content(i + '  ')}
        #{i}</div>
      EOT
    end
  end

  class Spec
    attr_accessor :rows, :example
    def initialize
      @rows = []
    end
    def content i
      retval = <<~EOT
        #{i}<div class='spec'>
          #{i}<table>
      EOT
      @rows.each do |name, type, desc|
        retval << <<~EOT
          #{i}    <tr>
            #{i}    <td class='name'>
              #{i}    <span class='name'>#{name}</span>
              #{i}    <span class='type'>#{type}</span>
            #{i}    </td>
            #{i}    <td class='description'>#{parse_text(desc)}</td>
          #{i}    </tr>
        EOT
      end
      retval << <<~EOT
          #{i}</table>
        #{@example&.content(i + '  ')}
        #{i}</div>
      EOT
    end
  end

  class Example
    attr_accessor :header, :json
    def content i
      retval = <<~EOT
        #{i}<div class='example'>
          #{i}<p>Example</p>
          #{i}<pre class='header'>#{@header}</pre>
        <pre>{
      EOT
      pre = []
      @json.each do |k, v|
        case v
        when NilClass
          pre << %Q{  <span class='json-key'>"#{k}"</span>: <span class='json-token'>NULL</span>}
        when String
          pre << %Q{  <span class='json-key'>"#{k}"</span>: "#{v}"}
        else
          pre << %Q{  <span class='json-key'>"#{k}"</span>: <span class='json-token'>#{v}</span>}
        end
      end
      retval << pre.join(",\n") << <<~EOT

        }</pre>
        #{i}</div>
      EOT
    end
  end

  module_function
  # blocks
  def document
    $DOC = Document.new
    wrap_context($DOC) { yield }
    puts $DOC.content
  end
  def group
    g = Group.new
    $DOC.context.children << g
    wrap_context(g) { yield }
  end
  def route
    r = Route.new
    $DOC.context.children << r
    wrap_context(r) { yield }
  end
  def request
    r = Request.new
    $DOC.context.request = r
    wrap_context(r) { yield }
  end
  def response
    r = Response.new
    $DOC.context.responses << r
    wrap_context(r) { yield }
  end
  def spec
    s = Spec.new
    $DOC.context.spec = s
    wrap_context(s) { yield }
  end
  def example
    e = Example.new
    $DOC.context.example = e
    wrap_context(e) { yield }
  end

  # setters
  def title t
    $DOC.context.title = t
  end
  def description d
    $DOC.context.description = d
  end
  def name n
    $DOC.context.name = n
  end
  def id i
    $DOC.context.id = i
  end
  def verb v
    $DOC.context.verb = v
  end
  def uri u
    $DOC.context.uri = u
  end
  def row arr
    $DOC.context.rows << arr
  end
  def header h
    $DOC.context.header = h
  end
  def json j
    $DOC.context.json = j
  end

  # helpers
  def wrap_context new_context
    # set the context before diving into the block
    prev_context = $DOC.context
    $DOC.context = new_context
    yield
    # then set it back when we exit out
    $DOC.context = prev_context
  end
  def parse_text text
    # [foo:bar] => <a href='#foo' class='link'>bar</a>
    text.gsub(/\[([^\]:]*):([^\]]*)\]/, "<a href='\#\\1' class='link'>\\2</a>")
  end
end
