Given(/^the user visits unpairing page$/) do
  visit "/unpairing/index/#{@pairing.id}"
end

Given(/^the user successfully unpair device$/) do
  steps %{
    When the user click "Confirm" link

    Then the user will redirect to success page
    And the user should see success message
    And the record of pairing should be removed
  }
end

When(/^the user have not other devices$/) do
  # do nothing
end

When(/^the user have other devices$/) do
  @other_paired = TestingHelper.create_pairing(@user.id)
end

Then(/^the user should see confirm message on unpairing confirm page$/) do
  expect(page).to have_content I18n.t("warnings.settings.unpairing.instruction")
  expect(page).to have_link I18n.t("labels.confirm")
  expect(page).to have_link I18n.t("labels.cancel")
end

Then(/^the user should see success message$/) do
  expect(page).to have_content I18n.t("warnings.settings.unpairing.success")
end

Then(/^the user will redirect to success page$/) do
  expect(page.current_path).to eq "/unpairing/success/#{@pairing.device_id}"
end

Then(/^the user will redirect to My Devices page$/) do
  expect(page.current_path).to eq "/personal/index"
end

Then(/^the user will redirect to Search Device page$/) do
  expect(page.current_path).to eq "/discoverer/index"
end

Then(/^the record of pairing should be removed$/) do
  expect(Pairing.exists?(@pairing.id)).to be false
end