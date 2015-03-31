module DummyEngine
  module Admin
    class AgentsController < DummyEngine::Admin::AdminController
      respond_to :json, :html

      def index
        @agent = DummyEngine::Agent.new
        respond_to do |format|
          format.html
          format.json { render json: AgentDatatable.new(view_context) }
        end
      end

      def create
        if @agent = DummyEngine::Agent.create(agent_params)
          render json: {agent: @agent, status: :created}
        else
          render json: {status: :unprocessable_entity}
        end
      end

      def show
        @agent = DummyEngine::Agent.find_by_id(params[:id])
        if @agent
          render json: {agent: @agent, status: :ok}
        else
          render json: {status: :not_found}
        end
      end

      def update
        @agent = DummyEngine::Agent.find_by_id(params[:id])
        if @agent.update_attributes(agent_params)
          render json: {status: :ok}
        else
          render json: {status: :unprocessable_entity}
        end
      end

      def destroy
        @agent = DummyEngine::Agent.find_by_id(params[:id])
        if @agent.destroy
          render json: {status: :no_content}
        else
          render json: {status: :unprocessable_entity}
        end
      end

      private

        def agent_params
          params.require(:agent).permit!
        end
    end
  end
end
