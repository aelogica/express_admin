class DummyEngine::AgentDatatable < ExpressAdmin::AjaxDatatables::Base
  include ExpressAdmin::AjaxDatatables::Extensions::Kaminari
  def_delegators :@view,
                 :link_to,
                 :content_tag,
                 :admin_agent_path,
                 :edit_admin_agent_path

  def sortable_columns
    @sortable_columns ||= [
         'dummy_engine_agents.last_name',
         'dummy_engine_agents.first_name',
    ]
  end

  def searchable_columns
    @searchable_columns ||= [
         'dummy_engine/agents.last_name',
         'dummy_engine/agents.first_name',
    ]
  end

  private

    def data
      records.map do |record|
        [
      link_to(record.last_name, admin_agent_path(record.id), onClick: 'return false;', class: 'edit-link', 'data-model': 'agent') + add_quick_actions(record),
      record.first_name
           ]
      end
    end

    def get_raw_records
      DummyEngine::Agent.all
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
      content_tag(:nav, class: 'action-menu', id: "agent-#{record.id}") do
        content_tag(:ul, class: 'inline-list') do
          content_tag(:li, class: "delete-link") do
            link_to 'Delete', admin_agent_path(record.id), onClick: 'return false;', method: :delete, remote: true, data: { confirm: 'Delete this agent permanently?' }
          end
        end
      end
    end
end
