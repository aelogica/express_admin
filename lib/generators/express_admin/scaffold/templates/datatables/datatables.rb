class <%= @project_name %>::<%= singular_table_name.classify %>Datatable < ExpressAdmin::AjaxDatatables::Base
  include ExpressAdmin::AjaxDatatables::Extensions::Kaminari
  def_delegators :@view,
                 :link_to,
                 :content_tag,
                 :admin_<%= @project_path %>_<%= singular_table_name %>_path,
                 :edit_admin_<%= @project_path %>_<%= singular_table_name %>_path

  def sortable_columns
    @sortable_columns ||= [
<% for attribute in attributes -%>
         '<%= @project_path %>_<%= plural_table_name %>.<%= attribute.name %>',
<% end -%>
    ]
  end

  def searchable_columns
    @searchable_columns ||= [
<% for attribute in attributes -%>
         '<%= @project_path %>/<%= plural_table_name %>.<%= attribute.name %>',
<% end -%>
    ]
  end

  private

    def data
      records.map do |record|
        [
<% for attribute in attributes -%>
   <% if attribute == attributes.first -%>
   link_to(record.<%= attribute.name %>, admin_<%= @project_path %>_<%= singular_table_name %>_path(record.id), onClick: 'return false;', class: 'edit-link', 'data-model': '<%= singular_table_name %>') + add_quick_actions(record),
   <% else -%>
record.<%= attribute.name %><%= ',' unless attribute == attributes.last %>
   <% end -%>
<% end -%>
        ]
      end
    end

    def get_raw_records
      <%= @project_name %>::<%= singular_table_name.classify %>.all
    end

    def build_conditions_for(query)
      search = params[:search][:value].split(' ')
      if (search[0].eql? '[') && (search[2].eql? ':') && (search[search.count - 1].eql? ']')
        query = search[3] if search[3]
      end
      search_for = query.split(' ')
      criteria = search_for.inject([]) do |criteria, atom|
        criteria << searchable_columns.map { |col| search_condition(col, atom) }.reduce(:or)
      end.reduce(:and)
      criteria
    end

    def add_quick_actions(record)
      content_tag(:nav, class: 'action-menu', id: "<%= singular_table_name %>-#{record.id}") do
        content_tag(:ul, class: 'inline-list') do
          content_tag(:li, class: "delete-link") do
            link_to 'Delete', admin_<%= @project_path %>_<%= singular_table_name %>_path(record.id), onClick: 'return false;', method: :delete, remote: true, data: { confirm: 'Delete this <%= singular_name %> permanently?' }
          end
        end
      end
    end
end
