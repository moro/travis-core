require 'spec_helper'

describe Travis::Event::Handler::Campfire do
  let(:handler) { Travis::Event::Handler::Campfire.any_instance }
  let(:build)   { stub('build') }

  before do
    Travis::Event.stubs(:subscribers).returns [:campfire]
    handler.stubs(:handle => true, :handle? => true)
  end

  describe 'subscription' do
    it 'build:started does not notify' do
      handler.expects(:notify).never
      Travis::Event.dispatch('build:started', build)
    end

    it 'build:finish notifies' do
      handler.expects(:notify)
      Travis::Event.dispatch('build:finished', build)
    end
  end

  describe 'instrumentation' do
    it 'instruments with "notify.campfire.handler.event.travis"' do
      ActiveSupport::Notifications.expects(:instrument).with do |event, data|
        event == 'notify.campfire.handler.event.travis' && data[:target].is_a?(Travis::Event::Handler::Campfire)
      end
      Travis::Event.dispatch('build:finished', build)
    end

    it 'meters on "travis.event.handler.campfire.notify"' do
      Metriks.expects(:timer).with('travis.event.handler.campfire.notify').returns(stub('timer', :update => true))
      Travis::Event.dispatch('build:finished', build)
    end
  end
end
