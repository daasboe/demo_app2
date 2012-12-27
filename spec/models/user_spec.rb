# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

require 'spec_helper'

describe User do
  before {@user = User.new(name:"Test User", email:"testuser@test.com",
                          password:"foobar", password_confirmation:"foobar")}
  subject {@user}
  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:authenticate)}

  it {should be_valid}

  describe "with a password that's too short" do
    before {@user.password = @user.password_confirmation = "a"*5}
    it {should be_invalid}
  end

  describe "return value of authenticate method" do
    before {@user.save}
    let(:found_user) {User.find_by_email(@user.email)}
    describe "with valid password" do
      it {should == found_user.authenticate(@user.password)}
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) {found_user.authenticate("invalid")}
      it {should_not == user_for_invalid_password}
      specify {user_for_invalid_password.should be_false}
    end
  end

  describe "when password is not present" do
    before {@user.password = @user.password_confirmation = " "}
    it {should_not be_valid}
  end

  describe "when passwords do not match" do
    before {@user.password_confirmation = "mismatch"}
    it {should_not be_valid}
  end

  describe "when confirmation is nil" do
    before {@user.password_confirmation = nil}
    it {should_not be_valid}
  end

  describe "when name is not present" do
    before {@user.name = " "}
    it {should_not be_valid}
  end

  describe "when email is not present" do
    before {@user.email = " "}
    it {should_not be_valid}
  end

  describe "when name is too long" do
    before {@user.name = "a"*51}
    it {should_not be_valid}
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it {should_not be_valid}
  end
end
