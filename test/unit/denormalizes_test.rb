require File.dirname(__FILE__) + '/../test_helper'

class DenormalizesTest < ActiveSupport::TestCase
  def test_active_record_base_should_denormalize
    assert ActiveRecord::Base.respond_to?(:denormalizes)
  end

  def test_saving_observed_record_should_create_denormalized_record_when_observed_field_is_modified
    assert_difference 'UserScore.count' do
      create_valid_user! :score => 99
    end
  end

  def test_saving_observed_record_should_create_denormalized_record_when_observed_field_is_not_modified
    assert_difference 'UserScore.count', 0 do
      create_valid_user!
    end
  end

  def test_saving_observed_record_should_denormalize_value
    user = create_valid_user! :score => 99
    assert_equal 99, UserScore.for_user_id(user.id).find(:first).score
  end

  def test_saving_observed_record_with_unmodified_denormalized_field_should_not_update_observer
    assert_difference 'UserScore.count', 0 do
      user = create_valid_user!
      user.update_attributes(:username => 'theodore')
    end
  end

  def test_saving_observed_record_with_modified_denormalized_field_should_update_observer
    assert_difference 'UserScore.count' do
      user = create_valid_user!
      user.update_attributes :score => 99
    end
  end

  def test_saving_updates_to_attributes_observed_by_different_observers_should_update_observers
    assert_difference [ 'UserScore.count', 'UserZipCode.count' ] do
      user = create_valid_user! :score => 99, :zip_code => 97201
    end
  end

  def test_saving_update_to_attribute_observed_by_one_observer_should_not_update_the_other
    assert_difference 'UserScore.count', 0 do
      user = create_valid_user! :zip_code => 97201
    end
  end

  def test_denormalizes_requires_denormalization_target
    assert_raise Denormalizes::NoDenormalizationTargetSpecified do
      UserScore.denormalizes :score
    end
  end


  # Test helpers
  def create_valid_user! options = {}
    User.create! options.reverse_merge(:username => 'melchior')
  end

  # Test test helpers
  def test_should_create_valid
    assert create_valid_user!.valid?
  end

  def test_should_create_valid_with_attributes
    user = create_valid_user! :score => 99
    assert_equal 99, user.score
  end

end
