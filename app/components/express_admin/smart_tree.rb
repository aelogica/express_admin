module ExpressAdmin
  class SmartTree < ExpressTemplates::Components::Base
    # Create an html <tt>ol</tt> (ordered list) for
    # a model object representing a tree of similar objects.
    #
    # The objects must respond to <tt>:children</tt>.
    #
    # The block is passed a NodeBuilder which may accept field names.
    #
    # Example:
    #
    # ```ruby
    # smart_tree(:roles)
    # ```
    #
    # If the view has an @roles variable with a Role having children,
    # this will turn into markup such as the following:
    #
    #     <ul id="roles" class="roles tree">
    #       <li>SuperAdmin
    #         <ul>
    #           <li>Admin
    #             <ul>
    #               <li>Publisher
    #                 <ul>
    #                    <li>Author</li>
    #                 </ul>
    #               </li>
    #               <li>Auditor</li>
    #             </ul>
    #           </li>
    #         </ul>
    #       </li>
    #     </ul>
    #

    include ExpressTemplates::Components::Capabilities::Configurable
    include ExpressTemplates::Components::Capabilities::Resourceful
    # include ExpressTemplates::Components::Capabilities::Parenting
    # include ExpressTemplates::Components::Capabilities::AnonymouslyRecursing

    def compile
      # The problem here is that this is not any better than the tree_for
      # in ExpressTemplates::Components::TreeFor.  In fact, it is a rediscovery
      # of the same pattern whereby the recursive visitor function must be named
      # and passed in.

      # My next step is to see if this can be improved via some
      # Y/Z combinator.
      return %Q(
(func = -> (tree_item, indent, func) { %Q[
\#{'  '*indent}<ul id="#{resource_name}" class="#{collection_name} tree">]+
((-> {tree_item.children}.call).each_with_index.map do |tree_item, tree_item_index|
"
\#{'  '*(indent+1)}<li>{{tree_item.name}}"+(tree_item.children.any? ? func.call(tree_item, indent+2, func) : '')+"</li>"
end).join+"
\#{'  '*indent}</ul>
\#{('  '*(indent-1)) if indent > 1}" } ; func.call(tree_item, 0, func) )
)
    end

    def css_classes
      if @config[:child]
        nil
      else
        "#{collection_name} tree"
      end
    end

  end
end