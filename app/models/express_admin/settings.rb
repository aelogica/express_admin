module ExpressAdmin
  class << self
    def settings_definitions
      @settings_definitions ||= {}
    end

    def settings_definitions=(definitions)
      @settings_definitions = definitions
    end
  end

  class Settings < ActiveRecord::Base
    #
    # The .detail model class is stored in the database (and cached) but emulates a hash
    # with simple bracket methods that allow you to get and set values like so:
    #
    #   ExpressAdmin.detail['setting.name'] = 'value'
    #   ExpressAdmin.detail['setting.name'] #=> "value"
    #
    # Settings entries can be used freely as general-purpose global variables unless a definition
    # has been given for that setting, in which case restrictions and defaults may apply. The restrictions
    # can take the form of validations, requirements, permissions or permitted options. They are
    # declared by calling ExpressAdmin::Settings#define:
    #
    #   # setting must be either 'foo', 'bar' or 'blank'
    #   define('admin.name', :select_from => ['foo', 'bar'])
    #
    #   # setting is (and must be) chosen from the names of currently available layouts
    #   define('shop.layout', :select_from => lambda { Layout.all.map{|l| [l.name,l.id]} }, :alow_blank => false)
    #
    #   # setting cannot be changed at runtime
    #   define('setting.important', :default => "something", :allow_change => false)
    #
    # Which almost always happens in a block like this:
    #
    #   ExpressAdmin.detail do |setting|
    #     setting.namespace('user', :allow_change => true) do |user|
    #       user.define 'allow_password_reset?', :default => true
    #     end
    #   end
    #
    # and usually in a settings/express_admin_settings.rb file either in express_admin itself, in the application directory
    # or in an extension. ExpressAdmin currently defines the following settings and makes them editable by
    # admin users on the site settings page:
    #
    # dev.host                  :: the 'dev' host which can be used to see draft pages
    #                              or content surrounded by <r:if_dev> tags
    # local.timezone            :: the time zone to be used for timestamps
    # defaults.locale           :: the default locale to be used for the backend
    # defaults.page.parts       :: a comma separated list of default page parts
    # defaults.page.status      :: a string representation of the default page status
    # defaults.page.filter      :: the default filter to use on new page parts
    # defaults.page.fields      :: a comma separated list of the default page fields
    # dev.host                  :: the hostname where draft pages are viewable
    # local.timezone            :: the timezone name (`rake -D time` for full list)
    #                              used to correct displayed times
    # site.title                :: the title to be returned by <r:site:title />
    # site.host                 :: the host to be returned by <r:site:host />
    # user.allow_password_reset?:: whether or not users can request a password reset
    #                           :: (not implemented yet)

    # The following settings are also defined by default, but are only editable through
    # the Rails console or in the database:
    #
    # admin.title                    :: the title of the admin system
    # admin.subtitle                 :: the subtitle of the admin system
    # admin.pagination.per_page      :: the default number of items to be shown per page
    # pagination.param_name          :: the pagination 'page' param name for
    #                                   <r:children:each paginated="true">...</r:children:each>
    # pagination.per_page_param_name :: the pagination 'per_page' param name for
    #                                   <r:children:each paginated="true">...</r:children:each>

    # Helper methods are defined in SettingsHelper that will display settings entry values
    # or edit fields:
    #
    #   # to display label and value, where label comes from looking up the settings setting in the active locale
    #   show_setting('admin.name')
    #
    #   # to display an appropriate checkbox, text field or select box with label as above:
    #   edit_setting('admin.name)
    #

    after_save  :update_cache
    attr_reader :definition

    class SettingsError < RuntimeError; end

    class << self
      def [](setting)
        if table_exists?
          unless ExpressAdmin::Settings.cache_file_exists?
            ExpressAdmin::Settings.ensure_cache_file
            ExpressAdmin::Settings.initialize_cache
          end
          ExpressAdmin::Settings.initialize_cache if ExpressAdmin::Settings.stale_cache?
          Rails.cache.read('ExpressAdmin::Settings')[setting]
        end
      end

      def []=(setting, value)
        if table_exists?
          setting = find_or_initialize_by(setting: setting)
          setting.value = value
        end
      end

      def to_hash
        Hash[ *all.map { |pair| [pair.setting, pair.value] }.flatten ]
      end

      def initialize_cache
        ExpressAdmin::Settings.ensure_cache_file
        Rails.cache.write('ExpressAdmin::Settings',ExpressAdmin::Settings.to_hash)
        Rails.cache.write('ExpressAdmin.cache_mtime', File.mtime(cache_file))
        Rails.cache.silence!
      end

      def cache_file_exists?
        File.file?(cache_file)
      end

      def stale_cache?
        return true unless ExpressAdmin::Settings.cache_file_exists?
        Rails.cache.read('ExpressAdmin.cache_mtime') != File.mtime(cache_file)
      end

      def ensure_cache_file
        FileUtils.mkpath(cache_path)
        FileUtils.touch(cache_file)
      end

      def cache_path
        "#{Rails.root}/tmp"
      end

      def cache_file
        cache_file = File.join(cache_path,'express_admin_settings_cache.txt')
      end

      # A convenient drying method for specifying a prefix and options common to several settings.
      #
      #   ExpressAdmin.detail do |setting|
      #     settings.namespace('secret', :allow_display => false) do |secret|
      #       secret.define('identity', :default => 'batman')      # defines 'secret.identity'
      #       secret.define('lair', :default => 'batcave')         # defines 'secret.lair'
      #       secret.define('longing', :default => 'vindication')  # defines 'secret.longing'
      #     end
      #   end
      #
      def namespace(prefix, options = {}, &block)
        prefix = [options[:prefix], prefix].join('.') if options[:prefix]
        with_options(options.merge(:prefix => prefix), &block)
      end

      # Declares a setting definition that will constrain and support the use of a particular settings entry.
      #
      #   define('setting.setting', options)
      #
      # Can take several options:
      # * :default is the value that will be placed in the database if none has been set already
      # * :type can be :string, :boolean or :integer. Note that all settings whose setting ends in ? are considered boolean.
      # * :select_from should be a list or hash suitable for passing to options_for_select, or a block that will return such a list at runtime
      # * :validate_with should be a block that will receive a value and return true or false. Validations are also implied by type or select_from.
      # * :allow_blank should be false if the settings item must not be blank or nil
      # * :allow_change should be false if the settings item can only be set, not changed. Add a default to specify an unchanging settings entry.
      # * :allow_display should be false if the settings item should not be showable in radius tags
      #
      # From the main express_admin settings/initializers/express_admin_settings.rb:
      #
      #   ExpressAdmin.detail do |setting|
      #     setting.define 'defaults.locale', :select_from => lambda { ExpressAdmin::AvailableLocales.locales }, :allow_blank => true
      #     setting.define 'defaults.page.parts', :default => "Body,Extended"
      #     ...
      #   end
      #
      # It's also possible to reuse a definition by passing it to define:
      #
      #   choose_layout = ExpressAdmin::Settings::Definition.new(:select_from => lambda {Layout.all.map{|l| [l.name, l.d]}})
      #   define "my.layout", choose_layout
      #   define "your.layout", choose_layout
      #
      # but at the moment that's only done in testing.
      #
      def define(setting, options={})
        called_from = caller.grep(/\/initializers\//).first
        if options.is_a? ExpressAdmin::Settings::Definition
          definition = options
        else
          setting = [options[:prefix], setting].join('.') if options[:prefix]
        end

        raise LoadError, %{
Settings definition error: '#{setting}' is defined twice:
1. #{called_from}
2. #{definitions[setting].definer}
        } unless definitions[setting].nil? || definitions[setting].empty?

        definition ||= ExpressAdmin::Settings::Definition.new(options.merge(:definer => called_from))
        definitions[setting] = definition

        if self[setting].nil? && !definition.default.nil?
          begin
            self[setting] = definition.default
          rescue ActiveRecord::RecordInvalid
            raise LoadError, "Default settings invalid: value '#{definition.default}' is not allowed for '#{setting}'"
          end
        end
      end

      def definitions
        ExpressAdmin.settings_definitions
      end

      def definition_for(setting)
        definitions[setting] ||= ExpressAdmin::Settings::Definition.new(:empty => true)
      end

      def clear_definitions!
        ExpressAdmin.settings_definitions = {}
      end

    end

    # The usual way to use a settings item:
    #
    #    ExpressAdmin.detail['setting'] = value
    #
    # is equivalent to this:
    #
    #   ExpressAdmin::Settings.find_or_create_by_setting('setting').value = value
    #
    # Calling value= also applies any validations and restrictions that are found in the associated definition.
    # so this will raise a SettingsError if you try to change a protected settings entry or a RecordInvalid if you
    # set a value that is not among those permitted.
    #
    def value=(param)
      newvalue = param.to_s
      if newvalue != self[:value]
        raise SettingsError, "#{self.setting} cannot be changed" unless settable? || self[:value].blank?
        if boolean?
          self[:value] = (newvalue == "1" || newvalue == "true") ? "true" : "false"
        else
          self[:value] = newvalue
        end
        self.save!
      end
      self[:value]
    end

    # Requesting a settings item:
    #
    #    setting = ExpressAdmin.detail['setting']
    #
    # is equivalent to this:
    #
    #   setting = ExpressAdmin::Settings.find_or_create_by_setting('setting').value
    #
    # If the settings item is boolean the response will be true or false. For items with :type => :integer it will be an integer,
    # for everything else a string.
    #
    def value
      if boolean?
        checked?
      else
        self[:value]
      end
    end

    # Returns the definition associated with this settings item. If none has been declared this will be an empty definition
    # that does not restrict use.
    #
    def definition
      @definition ||= self.class.definition_for(self.setting)
    end

    # Returns true if the item setting ends with '?' or the definition specifies :type => :boolean.
    #
    def boolean?
      definition.boolean? || self.setting.ends_with?("?")
    end

    # Returns true if the item is boolean and true.
    #
    def checked?
      return nil if self[:value].nil?
      boolean? && self[:value] == "true"
    end

    # Returns true if the item defintion includes a :select_from parameter that limits the range of permissible options.
    #
    def selector?
      definition.selector?
    end

    # Returns a name corresponding to the current setting value, if the setting definition includes a select_from parameter.
    #
    def selected_value
      definition.selected(value)
    end

    def update_cache
      ExpressAdmin::Settings.initialize_cache
    end

    delegate :default, :type, :allow_blank?, :hidden?, :visible?, :settable?, :selection, :notes, :units, :to => :definition

    def validate
      definition.validate(self)
    end

    class Definition

      attr_reader :empty, :default, :type, :notes, :validate_with, :select_from, :allow_blank, :allow_display, :allow_change, :units, :definer

      # Settings 'definitions' are metadata held in memory that add restriction and description to individual settings entries.
      #
      # By default express_admin's settings machinery is open and ad-hoc: settings items are just globally-accessible variables.
      # They're created when first mentioned and then available in all parts of the application. The definition mechanism is a way
      # to place limits on that behavior. It allows you to protect a settings entry, to specify the values it can take and to
      # validate it when it changes. In the next update it will also allow you to declare that
      # a settings item is global or site-specific.
      #
      # The actual defining is done by ExpressAdmin::Settings#define and usually in a block like this:
      #
      #   ExpressAdmin::Settings.prepare do |setting|
      #     setting.namespace('users', :allow_change => true) do |users|
      #       users.define 'allow_password_reset?', :label => 'Allow password reset?'
      #     end
      #   end
      #
      # See the method documentation in ExpressAdmin::Settings for options and conventions.
      #
      def initialize(options={})
        [:empty, :default, :type, :notes, :validate_with, :select_from, :allow_blank, :allow_change, :allow_display, :units, :definer].each do |attribute|
          instance_variable_set "@#{attribute}".to_sym, options[attribute]
        end
      end

      # Returns true if the definition included an :empty flag, which should only be the case for the blank, unrestricting
      # definitions created when an undefined settings item is set or got.
      #
      def empty?
        !!empty
      end

      # Returns true if the definition included a :type => :boolean parameter. Settings entries that end in '?' are automatically
      # considered boolean, whether a type is declared or not. settings.boolean? may therefore differ from settings.definition.boolean?
      #
      def boolean?
        type == :boolean
      end

      # Returns true if the definition included a :select_from parameter (either as list or proc).
      #
      def selector?
        !select_from.blank?
      end

      # Returns true if the definition included a :type => :integer parameter
      def integer?
        type == :integer
      end

      # Returns the list of possible values for this settings entry in a form suitable for passing to options_for_select.
      # if :select_from is a proc it is called first with no arguments and its return value passed through.
      #
      def selection
        if selector?
          choices = select_from
          choices = choices.call if choices.respond_to? :call
          choices = normalize_selection(choices)
          choices.unshift ["",""] if allow_blank?
          choices
        end
      end

      # in definitions we accept anything that options_for_select would normally take
      # here we standardises on an options array-of-arrays so that it's easier to validate input
      #
      def normalize_selection(choices)
        choices = choices.to_a if Hash === choices
        choices = choices.collect{|c| (c.is_a? Array) ? c : [c,c]}
      end

      # If the settings item is a selector and :select_from specifies [name, value] pairs (as hash or array),
      # this will return the name corresponding to the currently selected value.
      #
      def selected(value)
        if value && selector? && pair = selection.find{|s| s.last == value}
          pair.first
        end
      end

      # Checks the supplied value against the validation rules for this definition.
      # There are several ways in which validations might be defined or implied:
      # * if :validate_with specifies a block, the setting object is passed to the block
      # * if :type is :integer, we test that the supplied string resolves to a valid integer
      # * if the settings item is a selector we test that its value is one of the permitted options
      # * if :allow_blank has been set to false, we test that the value is not blank
      #
      def validate(setting)
        if allow_blank?
          return if setting.value.blank?
        else
          setting.errors.add :value, :blank if setting.value.blank?
        end
        if validate_with.is_a? Proc
          validate_with.call(setting)
        end
        if selector?
          setting.errors.add :value, :not_permitted unless selectable?(setting.value)
        end
        if integer?
          Integer(setting.value) rescue setting.errors.add :value, :not_a_number
        end
      end

      # Returns true if the value is one of the permitted selections. Not case-sensitive.
      def selectable?(value)
        return true unless selector?
        selection.map(&:last).map(&:downcase).include?(value.downcase)
      end

      # Returns true unless :allow_blank has been explicitly set to false. Defaults to true.
      # A settings item that does not allow_blank must be set or it will not be valid.
      def allow_blank?
        true unless allow_blank == false
      end

      # Returns true unless :allow_change has been explicitly set to false. Defaults to true.
      # A settings item that is not settable cannot be changed in the running application.
      def settable?
        true unless allow_change == false
      end

      # Returns true unless :allow_change has been explicitly set to false. Defaults to true.
      # A settings item that is not visible cannot be displayed in a radius tag.
      def visible?
        true unless allow_display == false
      end

      # Returns true if :allow_display has been explicitly set to false. Defaults to true.
      def hidden?
        true if allow_display == false
      end

    end
  end
end
