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

module PRC
  # Specific ALL Ruby functions, but incompatible with some other version.
  module SectionConfigRubySpec
    # Public functions
    module Public
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
      def []=(*prop)
        keys = prop.clone
        value = keys.pop

        return nil if keys.length == 0

        if @data_options[:section].nil?
          par = [:default]
        else
          par = [@data_options[:section]]
        end
        par += keys
        par << value
        p_set(*par)
      end
    end
  end
end
