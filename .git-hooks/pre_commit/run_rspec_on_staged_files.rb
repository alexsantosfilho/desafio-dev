# .git-hooks/pre_commit/run_rspec_on_staged_files.rb

module Overcommit::Hook::PreCommit
  class RunRspecOnStagedFiles < Base
    def run
      test_files = applicable_files.select { |file| file.end_with?('_spec.rb') }
      puts "RSpec files that will be tested: #{test_files}"

      test_files.each do |file|
        result = execute(['bundle', 'exec', 'rspec', file])

        return :fail, result.stdout unless result.success?
      end

      :pass
    end

    def description
      'Runs RSpec on staged files'
    end
  end
end
