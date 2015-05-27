#--
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
#++

#
module PRC
  # Specific Ruby1.8 functions
  # Those files can be removed as soon as compatibility won't be required
  module BaseConfigRubySpec
    # Public functions
    module Public
      # Set function
      #
      # * *Args*
      #   - +*prop+ : from *prop, is a combination:
      #     - *keys : Keys where to set value.
      #     - value : value to set.
      #
      # * *Returns*
      #   - The value set or nil
      #
      # ex:
      #    value = CoreConfig.New
      #
      #    value[:level1, :level2] = 'value'
      #    # => {:level1 => {:level2 => 'value'}}
      def []=(*prop)
        p_set(*prop)
      end
    end

    # Private functions
    module Private
      #
      def p_set(*prop)
        keys = prop.clone
        value = keys.pop

        return nil if keys.length == 0
        return p_get(*keys) if @data_options[:data_readonly]

        @data.rh_set(value, keys)
      end
    end
  end
end
