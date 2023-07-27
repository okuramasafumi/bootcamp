# frozen_string_literal: true

require 'test_helper'

class ProductUpdateNotifierTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @delivery_mode = AbstractNotifier.delivery_mode
    AbstractNotifier.delivery_mode = :normal
  end

  teardown do
    AbstractNotifier.delivery_mode = @delivery_mode
  end

  test '#call' do
    product = Product.new(
      body: 'test',
      user: users(:hajime),
      practice: practices(:practice1),
      checker_id: users(:komagata).id
    )
    product.save!

    assert_difference 'Notification.count', 1 do
      perform_enqueued_jobs do
        ProductUpdateNotifier.new.call({ product:, current_user: product.user })
      end
    end
    notification = Notification.last
    assert_equal product.user.id, notification.sender_id
    assert_equal product.checker_id, notification.user_id
    assert_equal "#{product.user.login_name}さんの提出物が更新されました", notification.message
  end
end
