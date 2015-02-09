#
# Author:: Adam Edwards (<adamed@getchef.com>)
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe Chef::Resource::DscResource do
  let(:dsc_test_resource_name) { 'DSCTest' }
  let(:dsc_test_property_name) { :DSCTestProperty }
  let(:dsc_test_property_value) { 'DSCTestValue' }

  context 'when Powershell supports Dsc' do
    let(:dsc_test_run_context) {
      node = Chef::Node.new
      node.automatic[:languages][:powershell][:version] = '4.0'
      empty_events = Chef::EventDispatch::Dispatcher.new
      Chef::RunContext.new(node, {}, empty_events)
    }
    let(:dsc_test_resource) {
      Chef::Resource::DscResource.new(dsc_test_resource_name, dsc_test_run_context) 
    }

    it "has a default action of `:set`" do
      expect(dsc_test_resource.action).to eq(:set)
    end

    it "has an allowed_actions attribute with only the `:set` and `:nothing` attributes" do
      expect(dsc_test_resource.allowed_actions.to_set).to eq([:set,:nothing].to_set)
    end

    it "allows the resource attribute to be set" do
      dsc_test_resource.resource(dsc_test_resource_name)
      expect(dsc_test_resource.resource).to eq(dsc_test_resource_name)
    end

    context "when setting a dsc property" do
      it "allows setting a dsc property with a property name of type Symbol" do
        dsc_test_resource.property(dsc_test_property_name, dsc_test_property_value)
        expect(dsc_test_resource.property(dsc_test_property_name)).to eq(dsc_test_property_value)
        expect(dsc_test_resource.properties[dsc_test_property_name]).to eq(dsc_test_property_value)
      end

      it "raises a TypeError if property_name is not a symbol" do
        expect{
          dsc_test_resource.property('Foo', dsc_test_property_value)
        }.to raise_error(TypeError)
      end
    end
  end
end
