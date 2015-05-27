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
  module CoreConfigRubySpec
    # Public functions
    module Public
      # Set function
      #
      # * *Args*
      #   - +keys+ : Array of key path to found
      # * *Returns*
      #   - The value set or nil
      #
      # ex:
      # value = CoreConfig.New
      #
      # value[:level1, :level2] = 'value'
      # # => {:level1 => {:level2 => 'value'}}
      def []=(*prop)
        keys = prop.clone
        value = keys.pop
        p_set(:keys => keys, :value => value)
      end
    end
  end
end
