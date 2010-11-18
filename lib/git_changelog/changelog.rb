module GitChangelog
  class Changelog
    def initialize(repo_path=nil)
      conf=VCLog::Config.new(repo_path ? repo_path : Dir.pwd)
      @repo=VCLog::Adapters::Git.new(conf)
    end

    def changelog
      @repo.changes
    end

    def epoch(days=13) # default to 13 days because this seems to be a fence ±1 problem
      Date.today-days
    end

    def truncate_changes(days=13) # see not at #epoch about days=13
      truncate_until=epoch(days)
      changes_index=0
      
      @repo.changes.each do |c|
        if (Date.parse("#{c.date}") < (Date.today-days))
          break
        end
        changes_index+=1
      end

      @repo.changes[0..changes_index]
    end
  end
end

