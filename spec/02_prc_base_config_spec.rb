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

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'config_layers.rb'

describe 'class: PRC::BaseConfig,' do
  context 'when creating a new instance' do
    it 'should be loaded' do
      config = PRC::BaseConfig.new
      expect(config).to be
    end

    it 'should be initialized with Hash data.' do
      config = PRC::BaseConfig.new(:test => :toto)
      expect(config.data).to eq(:test => :toto)
    end

    it 'should be initialized with latest_version.' do
      config = PRC::BaseConfig.new(nil, '0.1')
      expect(config.latest_version).to eq('0.1')
    end
  end

  context 'config[*keys] = value' do
    before(:all) do
      @config = PRC::BaseConfig.new
    end

    it 'should be able to create a key/value in the config object.' do
      @config[:test1] = 'value'
      expect(@config.data).to eq(:test1 => 'value')
    end

    it 'should be able to create a key tree/value in the config object.' do
      @config[:test1, :test2] = 'value'
      expect(@config.data).to eq(:test1 => { :test2 => 'value' })
    end

    it 'version = "0.1" can be set and get' do
      expect(@config.version).to equal(nil)
      @config.version = '0.1'
      expect(@config.version).to eq('0.1')
    end
  end

  context 'config.del(*keys)' do
    before(:all) do
      @config = PRC::BaseConfig.new(:test1 => 'value',
                                    :test2 => { :test2 => 'value' })
    end

    it 'should be able to delete a key/value in the config object.' do
      expect(@config.del(:test1)).to eq('value')
      expect(@config.data).to eq(:test2 => { :test2 => 'value' })
    end

    it 'should be able to delete a key/value in the config object.' do
      expect(@config.del(:test2)).to eq(:test2 => 'value')
      expect(@config.data).to eq({})
    end
  end

  context 'config[*keys]' do
    before(:all) do
      @config = PRC::BaseConfig.new(:test1 => { :test2 => 'value' })
    end

    it 'with no parameter should return nil' do
      expect(@config[]).to equal(nil)
    end

    it "with keys = [:test1], should return {:test2 =>'value'}." do
      expect(@config[:test1]).to eq(:test2 => 'value')
    end

    it "with keys = [:test1, :test2], should return {:test2 =>'value'}." do
      expect(@config[:test1, :test2]).to eq('value')
    end
  end

  context 'config.exist?(*keys)' do
    before(:all) do
      @config = PRC::BaseConfig.new(:test1 => { :test2 => 'value' })
    end

    it 'with no parameter should return nil' do
      expect(@config.exist?).to equal(nil)
    end

    it 'with keys = [test1], should return true.' do
      expect(@config.exist?(:test1)).to equal(true)
    end

    it 'with keys = [:test1, :test2], should return true.' do
      expect(@config.exist?(:test1, :test2)).to equal(true)
    end

    it 'with keys = [:test], should return false.' do
      expect(@config.exist?(:test)).to equal(false)
    end

    it 'with keys = [:test1, :test], should return false.' do
      expect(@config.exist?(:test1, :test)).to equal(false)
    end

    it 'with keys = [:test1, :test2, :test3], should return false.' do
      expect(@config.exist?(:test1, :test2, :test3)).to equal(false)
    end
  end

  context "config.erase on :test1 => { :test2 => 'value' }" do
    it 'with no parameter should return {} and cleanup internal data.' do
      config = PRC::BaseConfig.new({ :test1 => { :test2 => 'value' } }, '0.1')
      config.version = '0.0'

      expect(config.erase).to eq({})
      expect(config.data).to eq({})
      expect(config.version).to eq('0.1')
    end
  end

  context 'config.save and config.load' do
    before(:all) do
      @config = PRC::BaseConfig.new(:test1 => { :test2 => 'value' })
      @file1 = File.join('~', ".lorj_rspec_#{Process.pid}.yaml")
      @file2 = File.join('~', ".lorj_rspec2_#{Process.pid}.yaml")
    end

    it 'save with no parameter should fail' do
      expect { @config.save }.to raise_error RuntimeError
    end

    it 'save with filename set, save should true' do
      @config.filename = @file1
      filename = File.expand_path(@file1)

      expect(@config.filename).to eq(filename)
      expect(@config.save).to equal(true)

      File.delete(filename)
    end

    it 'save with filename given, returns true, and file saved.' do
      old_file = @config.filename
      filename = File.expand_path(@file2)
      @config.version = '1'
      expect(@config.save(@file2)).to equal(true)
      expect(@config.filename).not_to eq(old_file)
      expect(@config.filename).to eq(filename)
    end

    it 'load returns true and file is loaded.' do
      @config.erase
      expect(@config.load).to equal(true)
      expect(@config.data).to eq(:test1 => { :test2 => 'value' })
      expect(@config.version).to eq('1')
      expect(@config.latest_version).to eq(nil)
      File.delete(@config.filename)
    end

    it 'load raises if file given is not found.' do
      @config.erase
      File.delete(@file1) if File.exist?(@file1)
      expect { @config.load(@file1) }.to raise_error
      File.delete(@file1) if File.exist?(@file1)
    end

    it 'load return an empty Config if file is empty.' do
      @config.erase
      file = File.expand_path(@file1)
      File.open(file, 'w') { |thefile| thefile.write('') }

      expect(@config.load(file)).to equal(false)
      expect(@config.data).to eq({})
      File.delete(file)
    end
  end

  context 'new and save a config, with latest_version initialized' do
    before(:all) do
      @config = PRC::BaseConfig.new({ :test1 => { :test2 => 'value' } }, '1')
      @file1 = File.join('~', ".lorj_rspec_#{Process.pid}.yaml")
    end

    it 'save, file has version set' do
      @config.filename = @file1
      @config.save
      @config.erase
      expect(@config.data).to eq({})
      expect(@config.version).to eq('1')
      @config.load
      expect(@config.data).to eq(:test1 => { :test2 => 'value' })
      expect(@config.version).to eq('1')
    end
  end

  context 'load and upgrade an old config' do
    before(:all) do
      @config = PRC::BaseConfig.new
      @file1 = File.join('~', ".lorj_rspec_#{Process.pid}.yaml")
    end

    it 'load old config, version is not change without version update' do
      @config.filename = @file1
      @config.load
      old_version = @config.version
      old_data = @config.data
      @config.save
      @config.erase
      @config.load
      expect(@config.version).to eq(old_version)
      expect(@config.data).to eq(old_data)
    end

    it 'version upgrade and save, file has new version set' do
      @config.version = '2'
      old_data = @config.data
      @config.save
      @config.erase
      @config.load
      expect(@config.version).to eq('2')
      expect(@config.data).to eq(old_data)
      File.delete(@config.filename)
    end
  end

  context 'new and save a config, without latest_version initialized' do
    before(:all) do
      @config = PRC::BaseConfig.new(:test1 => { :test2 => 'value' })
      @file1 = File.join('~', ".lorj_rspec_#{Process.pid}.yaml")
    end

    it 'save, file has no version set' do
      @config.filename = @file1
      @config.save
      @config.erase
      @config.load
      expect(@config.latest_version).to eq(nil)
      expect(@config.version).to eq(nil)
      expect(@config.data).to eq(:test1 => { :test2 => 'value' })
      File.delete(@config.filename)
    end
  end

  context 'config.data_options(options)' do
    it 'with no parameter should return {} ie no options.' do
      config = PRC::BaseConfig.new
      expect(config.data_options).to eq({})
    end

    it 'with :readonly => true should return {} ie no options.' do
      config = PRC::BaseConfig.new
      expect(config.data_options(:readonly => true)).to eq(:readonly => true)
    end

    it 'with any unknown options like :section => "test" should return '\
       '{:section => "test"}.' do
      config = PRC::BaseConfig.new
      expect(config.data_options(:section => 'test')).to eq(:section => 'test')
    end

    it 'with any existing options set we replace it all.' do
      config = PRC::BaseConfig.new
      config.data_options(:section => 'test')
      expect(config.data_options(:toto => 'tata')).to eq(:toto => 'tata')
    end

    it 'with :data_readonly => true, we cannot set a data.' do
      config = PRC::BaseConfig.new(:test => 'toto')
      config.data_options(:data_readonly => true)
      config[:test] = 'titi'
      expect(config.data).to eq(:test => 'toto')
    end

    it 'with :file_readonly => true, we cannot save data to a file.' do
      config = PRC::BaseConfig.new(:test => 'toto')
      file = File.join('~', ".rspec_test_#{Process.pid}.yaml")
      file_path = File.expand_path(file)
      config.data_options(:file_readonly => true)
      File.delete(file_path) if File.exist?(file_path)
      expect(config.save(file)).to equal(false)
      expect(config.filename).to equal(nil)
      expect { config.load(file) }.to raise_error
      expect(config.filename).to eq(file_path)
      expect(config.data).to eq(:test => 'toto')
    end
  end
end
