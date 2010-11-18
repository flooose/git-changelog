require 'test/unit/testcase'
require 'test/unit'
require 'pathname'
require 'rubygems'
require 'ruby-debug'

require File.dirname(__FILE__)+'/../lib/git_changelog'

class TestGitChangelog < Test::Unit::TestCase
  include GitChangelog

  def setup
    @cwd=Dir.pwd
    @path_to_repo1=File.dirname(__FILE__)+'/../tmp/repo1'
    @path_to_repo2=File.dirname(__FILE__)+'/../../adva-cms2'
    FileUtils.mkdir_p(@path_to_repo1)
    Dir.chdir(@path_to_repo1)
    git_init
    10.times { |t| git_commit(t) }
    @repo1=Changelog.new(@path_to_repo1)
    @changes=ten_changes
  end

  def teardown
    Dir.chdir(@cwd)
    FileUtils.rm_r('tmp')
  end

  protected

    def git_init
      `git init`
      `touch README`
      `git add ./`
      `git commit -am 'Automated initial commit'`
    end

    def git_commit(count)
      `ls -la >> README`
      `git add ./`
      `git commit -am 'Automated commit #{count}'`
    end

    def ten_changes
      changes=[]
      10.times do |x|
        changes<<VCLog::Change.new('abbe41bc65cb08915aec7140745f453558f17501',
                          "#{Date.today-x}",
                          'chris floess',
                          "commit #{x+42}",
                          nil,
                          0,
                          'General Enhancments')
      end
      changes
    end
end
