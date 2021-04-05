title "Verify IAM Users"

control "01-iam-user" do
  impact 1.0
  title "Verify IAM Users Have Appropriate Access"

  describe aws_iam_user(user_name: 'inspec-demo-user') do
    it { should exist }
    it { should_not have_console_password }
    it { should have_mfa_enabled }
  end

  describe aws_iam_access_keys.where(username: 'inspec-demo-user') do
    it { should exist }
  end

end