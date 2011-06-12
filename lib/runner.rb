require 'lib/git_changelog'

#module Perb
#  class Runner
module GitChangelog
  class Runner
    def initialize(argv)
      @log_dir = argv[0]
    end

    def run
      changes = GitChangelog::Changelog.new(@log_dir).truncate_changes
      #results = Perb::PerbTest.new(@test_yml).run
      #Perb::PerbBase.create!(results)
    end
  end
end
