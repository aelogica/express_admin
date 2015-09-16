Kaminari::Helpers::Tag.class_eval do
  def page_url_for(page)
    route_set = @options[:route_set]
    (route_set || @template).url_for @params.merge(@param_name => (page <= 1 ? nil : page), :only_path => true)
  end
end
