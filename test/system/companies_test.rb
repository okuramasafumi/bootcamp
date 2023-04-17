# frozen_string_literal: true

require 'application_system_test_case'

class CompaniesTest < ApplicationSystemTestCase
  test 'GET /companies' do
    visit_with_auth '/companies', 'komagata'
    assert_equal '企業一覧　 | FBC', title
  end

  test 'display company total count with company list' do
    visit_with_auth '/companies', 'komagata'
    assert_selector 'h2.page-header__title', text: '企業一覧　(27)'
  end

  test 'show company information' do
    visit_with_auth "/companies/#{companies(:company1).id}", 'komagata'
    assert_equal 'Fjord Inc.の企業情報 | FBC', title
  end

  test 'show link to website if company has' do
    visit_with_auth "/companies/#{companies(:company1).id}", 'komagata'
    within '.company-links' do
      assert_link '企業ページ', href: 'https://fjord.jp'
    end
  end

  test 'show link to blog url if company has' do
    visit_with_auth "/companies/#{companies(:company1).id}", 'komagata'
    within '.company-links' do
      assert_link 'Techブログ', href: 'https://tech.sample.com'
    end
  end
end
