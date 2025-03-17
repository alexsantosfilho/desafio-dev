#!/usr/bin/env ruby

module Overcommit::Hook::PreCommit
  require 'reek'

  class CustomReek < Base
    def run
      ARGV.each do |filename|
        diff = `git diff -U0 HEAD #{filename}`
        changes = diff.scan(/^@@ -\d+,\d+ \+(\d+),(\d+) @@/).map { |start, length| (start.to_i...(start.to_i + length.to_i)).to_a }
        changes.flatten!

        next if changes.empty?

        examiner = Reek::Examiner.new(File.read(filename))
        examiner.smells.each do |smell|
          puts smell.message if changes.include?(smell.lines.first)
        end
      end
    end

    def description
      'Runs Reek on staged files'
    end
  end
end
