module ExtJS::Helpers
  module Component
    def extjs_component(params)
      ExtJS::Component.new(self, params)
    end
  end
end

class ExtJS::Component
  attr_accessor :config
  def initialize(controller, config)
    @controller = controller
    @config = config
    @config[:items] = [] if config[:items].nil?
    
    if container = @config.delete(:container)
	container.add(self)
    end
    @partial_config = nil
  end
  
  def apply(params)
    @config.merge!(params)
  end

  def add(*config)
    options = config.extract_options!
    if !options.keys.empty?
	if options[:partial]
	    # rendering a partial, cache the config until partial calls #add method.  @see else.
	    url = options.delete(:partial)
	    @partial_config = options
	    return @controller.render(:partial => url, :locals => {:container => self})
	else
	    options.merge!(@partial_config) unless @partial_config.nil?
	    @config[:items] << options
	end
    elsif !config.empty? && config.first.kind_of?(ExtJS::Component)
	cmp = config.first
	cmp.apply(@partial_config) unless @partial_config.nil?
	@config[:items] << cmp.config
    end
    @partial_config = nil
  end

  def render
    cmp = "Ext.ComponentMgr.create(#{@config.to_json});"
    "Ext.onReady(function() {#{cmp}});"
  end
end