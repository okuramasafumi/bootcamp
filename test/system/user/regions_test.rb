# frozen_string_literal: true

require 'application_system_test_case'
require 'uri'

class User::RegionsTest < ApplicationSystemTestCase
  test 'show tokyo users without search params' do
    visit_with_auth '/users/regions', 'komagata'
    assert_equal '都道府県別ユーザー一覧 | FBC', title
    within "[data-testid='regions']" do
      assert_text '関東地方'
      assert_text '東京都'
      assert_selector "[data-login-name='kimura']"
    end
  end

  test 'show selected subdivision or country users by search params' do
    query = URI.encode_www_form(region: '九州・沖縄地方', subdivision_or_country: '長崎県')
    visit_with_auth "/users/regions?#{query}", 'komagata'
    within "[data-testid='regions']" do
      assert_text '長崎県'
      assert_selector "[data-login-name='advisernocolleguetrainee']"
    end
  end

  test 'show empty message when no users exist' do
    query = URI.encode_www_form(region: '関東地方', subdivision_or_country: '神奈川県')
    visit_with_auth "/users/regions?#{query}", 'komagata'
    within "[data-testid='regions']" do
      assert_text '都道府県別ユーザー一覧はありません'
    end
  end
end
