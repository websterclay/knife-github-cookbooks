#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Jesse Newland (<jesse@websterclay.com>)
# Copyright:: Copyright (c) 2010 Opscode, Inc.
# Copyright:: Copyright (c) 2011 Webster Clay, LLC.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/knife'

class Chef
  class Knife

    class CookbookGithubCompare < Knife

      deps do
        require 'chef/mixin/shell_out'
        require 'chef/knife/core/cookbook_scm_repo'
        require File.join(File.dirname(__FILE__), 'core', 'coobook_scm_repo_extensions')
      end

      banner "knife cookbook github compare COOKBOOK [USER/BRANCH] (options)"
      category "cookbook"

      option :cookbook_path,
        :short => "-o PATH:PATH",
        :long => "--cookbook-path PATH:PATH",
        :description => "A colon-separated path to look for cookbooks in",
        :proc => lambda { |o| o.split(":") }

        attr_reader :cookbook_name
        attr_reader :github_path
        attr_reader :current_sha

      def run
        extend Chef::Mixin::ShellOut

        if config[:cookbook_path]
          Chef::Config[:cookbook_path] = config[:cookbook_path]
        else
          config[:cookbook_path] = Chef::Config[:cookbook_path]
        end

        @cookbook_name = parse_name_args!

        @install_path = config[:cookbook_path].first

        @repo = CookbookSCMRepoExtensions.new(@install_path, ui, config)

        match = @repo.last_log_message_from_cookbook(@cookbook_name).match("Import (.*) version (.*)")
        @github_path = match[1]
        @current_sha = match[2]
        visit_or_print(compare_uri)
      end

      def visit_or_print(url)
        STDOUT.puts url
        begin
          gem 'launchy'
          require 'launchy'
          Launchy::Browser.new.visit url
        rescue Gem::LoadError
          STDERR.puts "Install launchy to automatically open this in the future: `gem install launchy`"
        end
      end

      def parse_name_args!
        if name_args.empty?
          ui.error("please specify a cookbook to download and install")
          exit 1
        elsif name_args.size > 2
          ui.error("USAGE: knife cookbook github compare COOKBOOK [USER/BRANCH] (options)")
          exit 1
        else
          name_args.first
        end
      end

      def compare_uri
        "https://github.com/#{@github_path}/compare/#{@current_sha}...#{user_and_branch}"
      end

      def user_and_branch
        if name_args.size > 1
          user, branch = name_args.last.split(/[:\/]/)
          branch ||= 'master'
          "#{user}:#{branch}"
        else
          'master'
        end
      end

    end
  end
end