#!/usr/bin/env ruby
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

# require 'byebug'

require 'rubygems'
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'config_layers.rb'

describe 'class: PRC::SectionConfig,' do
  context 'PRC::SectionConfig' do
    it '.new created a new instance' do
      config = PRC::SectionConfig.new
      expect(config).to be
    end

    it '.new(:default => {:test => :toto},'\
       ':section => {:key => :value}) set expected default data' do
      config = PRC::SectionConfig.new(:default => { :test => :toto },
                                      :section => { :key => :value })
      expect(config.data).to eq(:default => { :test => :toto },
                                :section => { :key => :value })
    end
  end

  context 'config = nil' do
    before(:all) do
      @config = PRC::SectionConfig.new
    end

    it 'config[:test1] = "value" set internal data to '\
       ':default=>{:test1=>"value"}' do
      @config[:test1] = 'value'
      expect(@config.data).to eq(:default => { :test1 => 'value' })
    end

    it 'config[:test1, :test2] = "value" set internal data to '\
       ':default=>{:test1 => { :test2 => "value"}}' do
      @config[:test1, :test2] = 'value'
      expect(@config.data).to eq(:default =>
                                 { :test1 => { :test2 => 'value' } })
    end
    context 'config.data_options(:section => :mysection)' do
      it 'return true' do
        expect(@config.data_options(:section => :mysection)).to eq(:section =>
                                                                   :mysection)
      end

      it 'config[:test1, :test2] = "value2" set '\
         'mysection=>{:test1 => { :test2 => "value2"}}' do
        @config[:test1, :test2] = 'value2'
        expect(@config.data[:mysection]).to eq(:test1 => { :test2 => 'value2' })
      end
      it 'config[:test1, :test2] returns "value2"' do
        expect(@config[:test1, :test2]).to eq('value2')
      end
      it 'config.data_options({})' do
        expect(@config.data_options({})).to eq({})
      end
      it 'config[:test1, :test2] returns "value"' do
        expect(@config[:test1, :test2]).to eq('value')
      end
    end
  end

  context 'SectionConfig.new {:default => {:test => :toto},'\
          ':section => {:key => :value} }' do
    before(:all) do
      @config = PRC::SectionConfig.new(:default => { :test => :toto },
                                       :section => { :key => :value })
    end

    it 'config.del(:test) return :toto' do
      expect(@config.del(:test)).to eq(:toto)
      expect(@config.data).to eq(:default => {},
                                 :section => { :key => :value })
    end

    it 'config.del(:key) returns nil' do
      expect(@config.del(:key)).to equal(nil)
      expect(@config.data).to eq(:default => {},
                                 :section => { :key => :value })
    end
  end

  context 'SectionConfig.new {:test1 => { :test2 => "value" }}' do
    before(:all) do
      @config = PRC::SectionConfig.new(:test1 => { :test2 => 'value' })
    end

    it 'config[] return nil' do
      expect(@config[]).to equal(nil)
    end

    it 'config[:test1] returns nil.' do
      expect(@config[:test1]).to equal(nil)
    end

    it 'config[:test1, :test2] returns nil.' do
      expect(@config[:test1, :test2]).to equal(nil)
    end

    it 'config[:test2] returns nil.' do
      expect(@config[:test2]).to equal(nil)
    end

    it 'config[:test2] returns nil.' do
      expect(@config[:test2]).to equal(nil)
    end

    it 'with config.data_options({:section => :test1})' do
      expect(@config.data_options(:section =>
                                  :test1)).to eq(:section => :test1)
    end

    it 'config[:test1] returns nil.' do
      expect(@config[:test1]).to equal(nil)
    end

    it 'config[:test1, :test2] returns nil.' do
      expect(@config[:test1, :test2]).to equal(nil)
    end

    it "config[:test2] returns NOW 'value'." do
      expect(@config[:test2]).to eq('value')
    end
  end

  context 'SectionConfig.new {:test1 => { :test2 => "value" }}' do
    before(:all) do
      @config = PRC::SectionConfig.new(:test1 => { :test2 => 'value' })
    end

    it 'config.exist? return nil' do
      expect(@config.exist?).to equal(nil)
    end

    it 'config.exist?(test1) return false.' do
      expect(@config.exist?(:test1)).to equal(false)
    end

    it 'config.exist?(:test1, :test2) return false.' do
      expect(@config.exist?(:test1, :test2)).to equal(false)
    end

    it 'config.exist?(:test) return false.' do
      expect(@config.exist?(:test)).to equal(false)
    end

    it 'config.exist?(:test1, :test) return false.' do
      expect(@config.exist?(:test1, :test)).to equal(false)
    end

    it 'config.exist?(:test1, :test2, :test3) return false.' do
      expect(@config.exist?(:test1, :test2, :test3)).to equal(false)
    end

    it 'with config.data_options({:section => :test1})' do
      expect(@config.data_options(:section =>
                                  :test1)).to eq(:section => :test1)
    end

    it 'config.exist? return nil' do
      expect(@config.exist?).to equal(nil)
    end

    it 'config.exist?(test1) return false.' do
      expect(@config.exist?(:test1)).to equal(false)
    end

    it 'config.exist?(:test1, :test2) return false.' do
      expect(@config.exist?(:test1, :test2)).to equal(false)
    end

    it 'config.exist?(:test2) return true.' do
      expect(@config.exist?(:test2)).to equal(true)
    end
  end

  context 'SectionsConfig.new {:sec1 => { :test1 => "value1" }, '\
          ':sec2 => { :test2 => "value2" }, '\
          ':default => { :test3 => "value3" }}' do
    before(:all) do
      @config = PRC::SectionsConfig.new(:sec1 => { :test1 => 'value1' },
                                        :sec2 => { :test2 => 'value2' },
                                        :default => { :test1 => 'value3' })
    end

    it 'config.exist? return nil' do
      expect(@config.exist?).to equal(nil)
    end

    it 'config.exist?(:sec1, :test1) return false.' do
      expect(@config.exist?(:sec1, :test1)).to equal(false)
    end

    it 'config.exist?(:sec2, :test2) return false.' do
      expect(@config.exist?(:sec2, :test2)).to equal(false)
    end

    it 'config.exist?(:default, :test1) return false.' do
      expect(@config.exist?(:default, :test1)).to equal(false)
    end

    it 'config.exist?(:test1) return true.' do
      expect(@config.exist?(:test1)).to equal(true)
    end

    it 'config.exist?(:test2) return false.' do
      expect(@config.exist?(:test1)).to equal(true)
    end

    it 'config.where?(:test1, "layer") return "layer(default)"' do
      expect(@config.where?(:test1, 'layer')).to eq('layer(default)')
    end

    it 'config.where?(:test2, "layer") return "layer"' do
      expect(@config.where?(:test2, 'layer')).to eq('layer')
    end

    it 'with option sections = [:sec1], config.where?(:test1, "layer") '\
       'return "layer(sec1|default)"' do
      @config.data_options(:sections => [:sec1])
      expect(@config.where?(:test1, 'layer')).to eq('layer(sec1|default)')
    end

    it 'with option sections = [:sec2], config.where?(:test2, "layer") '\
       'return "layer(sec2)"' do
      @config.data_options(:sections => [:sec2])
      expect(@config.where?(:test2, 'layer')).to eq('layer(sec2)')
    end

    it 'with option sections = [:sec2], config.exist?(:test2) return true' do
      @config.data_options(:sections => nil)
      expect(@config.exist?(:test2)).to eq(false)
      @config.data_options(:sections => [:sec2])
      expect(@config.exist?(:test2)).to eq(true)
    end

    it 'with option section = [:sec1] and default_section = :sec2, '\
       'config.where?(:test1, "layer") return "layer(sec1)"' do
      @config.data_options(:sections => [:sec1], :default_section => :sec2)
      expect(@config.where?(:test1, 'layer')).to eq('layer(sec1)')
    end

    it 'and config.where?(:test2, "layer") return "layer(sec2)"' do
      expect(@config.where?(:test2, 'layer')).to eq('layer(sec2)')
    end

    it 'and config[:test2] return "value2"' do
      expect(@config[:test2]).to eq('value2')
    end

    it 'with option sections = [:sec1], config[:test2] return "value1"' do
      @config.data_options :sections => [:sec1]
      expect(@config.where?(:test1, '')).to eq('(sec1|default)')
      expect(@config[:test1]).to eq('value1')
    end

    it 'with no options, config[:test2] return "value3"' do
      @config.data_options :sections => nil
      expect(@config.where?(:test1, '')).to eq('(default)')
      expect(@config[:test1]).to eq('value3')
      @config.data_options :sections => []
      expect(@config.where?(:test1, '')).to eq('(default)')
    end
  end
end
