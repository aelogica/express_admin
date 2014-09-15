module ExpressAdmin
  module AjaxDatatables
    module Extensions
      module Kaminari

        private

        def paginate_records(records)
          records.page(page).per(per_page)
        end
      end
    end
  end
end
