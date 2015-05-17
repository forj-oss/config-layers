# encoding: UTF-8

# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

require 'rubygems'
require 'yaml'

module PRC
  # SectionConfig class layer based on BaseConfig.
  #
  # It supports a data_options :section for #[], #[]=, etc...
  #
  class SectionConfig < PRC::BaseConfig
    # Get the value of a specific key under a section.
    # You have to call #data_options(:section => 'MySection')
    #
    # * *Args*    :
    #   - +keys+  : keys to get values from a section set by data_options.
    #     If section is not set, it will use :default
    # * *Returns* :
    #   - key value.
    # * *Raises* :
    #   Nothing
    def [](*keys)
      return nil if keys.length == 0
      return p_get(:default, *keys) if @data_options[:section].nil?
      p_get(@data_options[:section], *keys)
    end

    # Set the value of a specific key under a section.
    # You have to call #data_options(:section => 'MySection')
    #
    # * *Args*    :
    #   - +keys+  : keys to get values from a section set by data_options.
    #     If section is not set, it will use :default
    # * *Returns* :
    #   - key value.
    # * *Raises* :
    #   Nothing
    def []=(*keys, value)
      return nil if keys.length == 0
      return p_set(:default, *keys, value) if @data_options[:section].nil?
      p_set(@data_options[:section], *keys, value)
    end

    # Check key existence under a section.
    # You have to call #data_options(:section => 'MySection')
    #
    # * *Args*    :
    #   - +keys+  : keys to get values from a section set by data_options.
    #     If section is not set, it will use :default
    # * *Returns* :
    #   - key value.
    # * *Raises* :
    #   Nothing
    def exist?(*keys)
      return nil if keys.length == 0
      return p_exist?(:default, *keys) if @data_options[:section].nil?
      p_exist?(@data_options[:section], *keys)
    end

    # remove the key under a section.
    # You have to call #data_options(:section => 'MySection')
    #
    # * *Args*    :
    #   - +keys+  : keys to get values from a section set by data_options.
    #     If section is not set, it will use :default
    # * *Returns* :
    #   - key value.
    # * *Raises* :
    #   Nothing
    def del(*keys)
      return nil if keys.length == 0
      return p_del(:default, *keys) if @data_options[:section].nil?
      p_del(@data_options[:section], *keys)
    end
  end

  # SectionsConfig class layer based on SectionConfig.
  #
  # It supports a data_options :sections/default for #[] and #exist? etc...
  #
  # The main difference with SectionConfig is :
  # - :sections options is replacing :section for [] and exist?.
  #   search in collection of ordered sections. First found, first returned.
  # - :section is still use like SectionConfig designed it.
  # - :default is the default section to use. if not set, it will be :default.
  #
  class SectionsConfig < PRC::SectionConfig
    # Get the value of a specific key under a section.
    # You have to call #data_options(:section => 'MySection')
    #
    # * *Args*    :
    #   - +keys+  : keys to get values from a sections/section set by
    #     data_options:
    #     - :sections: if not set, it will search only in what is set in
    #       :default_section.
    #     - :default_section : default section name to use.
    #       by default is ':default'
    # * *Returns* :
    #   - first found value or nil if not found.
    # * *Raises* :
    #   Nothing
    def [](*keys)
      return nil if keys.length == 0

      if @data_options[:default_section].nil?
        section = :default
      else
        section = @data_options[:default_section]
      end

      sections = @data_options[:sections]

      if sections.is_a?(Array)
        sections << section unless sections.include?(section)
      else
        sections = [section]
      end

      sections.each { |s| return p_get(s, *keys) if p_exist?(s, *keys) }

      nil
    end

    # Check key existence under a section.
    # You have to call #data_options(:section => 'MySection')
    #
    # * *Args*    :
    #   - +keys+  : keys to get values from a section set by data_options:
    #     - :sections: if not set, it will search only in what is set in
    #       :default_section.
    #     - :default_section : default section name to use.
    #       by default is ':default'
    #
    # * *Returns* :
    #   - true if first found.
    #
    # * *Raises*  :
    #   Nothing
    #
    # * *hint*    :
    #   - If you want to know where to find a value, use where?
    def exist?(*keys)
      return nil if keys.length == 0

      if @data_options[:default_section].nil?
        section = :default
      else
        section = @data_options[:default_section]
      end

      sections = @data_options[:sections]

      if sections.is_a?(Array)
        sections << section unless sections.include?(section)
      else
        sections = [section]
      end

      sections.each { |s| return true if p_exist?(s, *keys) }

      false
    end

    # where layer helper format Used by CoreConfig where?
    #
    # In the context of CoreConfig, this class is a layer with a name.
    # CoreConfig will query this function to get a layer name.
    # If the layer needs to add any other data, this function will need to
    # be redefined.
    #
    # * *Args*    :
    #   - name : name of this layer managed by CoreConfig
    #
    # * *Returns* :
    #   - name: Composed layer name return by the layer to CoreConfig
    #     return '<name>(<sections found sep by |>)'
    #
    def where?(keys, name)
      return name unless exist?(*keys)

      if @data_options[:default_section].nil?
        section = :default
      else
        section = @data_options[:default_section]
      end

      sections = @data_options[:sections]

      if sections.is_a?(Array)
        sections << section unless sections.include?(section)
      else
        sections = [section]
      end

      sections_found = []
      sections.each { |s| sections_found << s if p_exist?(s, *keys) }

      format('%s(%s)', name, sections_found.join('|'))
    end
  end
end
