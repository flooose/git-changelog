require File.expand_path('../helper.rb', __FILE__)

class TestGitChangelog < Test::Unit::TestCase
  def test_truth
    assert true
  end

  def test_modules_and_classes_exist
    assert defined?(GitChangelog)
    assert defined?(GitChangelog::Changelog)
    assert defined?(VCLog::Adapters::Git)
    assert defined?(klass)
  end

  def test_instantiate_stuff
    assert_kind_of Changelog, klass.new('./')
    assert_kind_of Grit::Repo, Grit::Repo.new('./')
    assert_kind_of VCLog::Config, VCLog::Config.new(Dir.pwd)
    conf=VCLog::Config.new(Dir.pwd)
    assert_kind_of VCLog::Adapters::Git, VCLog::Adapters::Git.new(conf)
  end

  def test_existence_of_methods
    assert_respond_to @repo1, :changelog
    assert_respond_to @repo1, :epoch
    assert_respond_to @repo1, :truncate_changes
  end

  def test_changelog
    assert_kind_of Array, @repo1.changelog
    assert !@repo1.changelog.empty?
    assert_equal 11, @repo1.changelog.size
    assert VCLog::Change, @repo1.changelog.first
    assert_match(/.*9.*/, @repo1.changelog.first.message)
  end

  def test_epoch_returns_date_x_days_ago
    today = Date.parse(Time.now.to_s)
    days_ago = today-4
    assert_equal days_ago.to_s, @repo1.epoch(4).to_s
  end

  def test_truncate_changes_returns_no_changes_before_x_date
    assert_kind_of Array, @repo1.truncate_changes
    assert_kind_of VCLog::Change, @repo1.truncate_changes.first
  end

  def test_a_live_repo
    Dir.chdir(@cwd)

    path = File.expand_path('../../../adva-cms2', __FILE__)
    assert_equal '/home/chris/work/projects/adva-cms2', path

    Dir.chdir path do
      repo = Changelog.new()
      repo.truncate_changes.each { |c| puts "#{c.date}\n\t#{c.message}" }
    end
  end

  protected
    
    def klass
      GitChangelog::Changelog
    end
end
