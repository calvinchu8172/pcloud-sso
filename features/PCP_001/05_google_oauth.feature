Feature: [PCP_001_05] Google oauth

	Background:
	  Given a user visits home page

	Scenario: [PCP_001_05_01]
	  Show error message when permissions error
	    And the user was not a Google member
	   When the user click sign in with Google link and not grant permission
	   Then the user should see oauth feature "Could not authenticate you" message

	Scenario: [PCP_001_05_02]
	  Redirect to Terms of Use page when omniauth user have not agree terms of use
	    And the user was not a Google member
	   When the user click sign in with Google link and grant permission
	   Then the user will redirect to Terms of Use page
	    And the user should see oauth feature "Terms of Use" message

	Scenario: [PCP_001_05_03]
	  Login and redirect to Welcome page
	    And the user was a Google member
	   When the user click sign in with Google link
	   Then the user should login
	   	And redirect to Welcome page

	Scenario: [PCP_001_05_04]
		Omniauth user can not change password
		  And the user was a Google member
		 When the user click sign in with Google link
		  And the user visits profile page
		 Then the omniauth user should not see change password link

	Scenario: [PCP_001_05_05]
	  Redirect to Terms of Use page when omniauth user have not agree terms of use, then check and click confirm
	   And the user was not a Google member
	  When the user click sign in with Google link and grant permission
	  Then the user will redirect to Terms of Use page
	   And the user should see oauth feature "Terms of Use" message
    When the user click Terms of Use page
    Then the user will redirect to editing password page
    # Then redirect to Welcome page

  Scenario:  [PCP_001_05_06]
	  If user doesn't check the box of user agreement terms, the user will see message
	   And the user was not a Google member
	  When the user click sign in with Google link and grant permission
	  Then the user will redirect to Terms of Use page
	   And the user should see oauth feature "Terms of Use" message
    When the user doesn't click Terms of Use page
    Then user will stay in Terms of Use page
    Then the user will see the warning message "Please accept the user agreement terms"
