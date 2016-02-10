require "test_helper"

class AdminItemsTest < ActionDispatch::IntegrationTest
  test "logged in admin sees items index" do
    create_admin
    item1 = create(:item)
    item2 = create(:item)

    visit admin_dashboard_index_path
    click_button "Edit Items"

    assert_equal admin_items_path, current_path

    assert page.has_content?("All Items")
    assert page.has_content?(item1.name)
    assert page.has_content?(item2.name)
  end

  test "user does not see admin categories index" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit admin_items_path

    refute page.has_content?("All Items")
    assert page.has_content?("Start New Game")
  end

  test "guest does not see admin categories index" do
    visit admin_items_path

    refute page.has_content?("All Items")
    assert page.has_content?("Login")
  end

  test "admin can edit item" do
    create_admin
    item1 = create(:item)
    item2 = create(:item)

    visit admin_items_path

    within("#item-#{item1.id}") do
      click_button "Edit"
    end

    assert_equal edit_admin_item_path(item1), current_path

    fill_in "Name", with: "EditedName"
    fill_in "Money", with: 2
    fill_in "Strength", with: 2
    fill_in "Dexterity", with: 2
    fill_in "Intelligence", with: 2
    fill_in "Health", with: 2
    fill_in "Speed", with: 2
    click_button "Update Item"

    assert_equal admin_items_path, current_path
    assert page.has_content? "EditedName"
  end

  test "admin can add item" do
    create_admin

    visit admin_dashboard_index_path

    click_button "Add New Item"

    fill_in "Name", with: "NewItem"
    fill_in "Money", with: 20
    fill_in "Strength", with: 2
    fill_in "Dexterity", with: 2
    fill_in "Intelligence", with: 2
    fill_in "Health", with: 2
    fill_in "Speed", with: 2
    click_button "Create Item"

    assert admin_dashboard_index_path, current_path

    visit admin_items_path

    assert page.has_content?("NewItem")
  end

  test "admin can delete item" do
    create_admin
    item1 = create(:item)
    item2 = create(:item)

    visit admin_items_path

    within("#item-#{item1.id}") do
      click_button "Delete"
    end

    assert admin_items_path, current_path

    refute page.has_content?(item1.name)
  end
end
