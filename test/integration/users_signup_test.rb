require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar"}}
    end
    assert_template 'users/new'
    assert_select 'form[action="/users"]'
    assert_select 'div#error_explanation' do
      assert_select 'div.alert.alert-danger', {:count=>1,
                                               :text=> "The form contains 4 errors."}
      assert_select 'ul' do
        assert_select 'li', 4
        assert_select 'li', "Name can't be blank"
        assert_select 'li', "Email is invalid"
        assert_select 'li', "Password confirmation doesn't match Password"
        assert_select 'li', "Password is too short (minimum is 6 characters)"
      end
      assert_select 'ul li', {:count=>4}

    end
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password"} }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.nil?
    assert is_logged_in?
  end
end
