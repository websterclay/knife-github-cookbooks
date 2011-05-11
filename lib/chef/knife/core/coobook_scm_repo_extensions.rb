class Chef
  class Knife
    class CookbookSCMRepoExtensions < CookbookSCMRepo

      def finalize_updates_from_github(cookbook_name, github_path, sha)
        if update_count = updated?(cookbook_name)
          ui.info "#{update_count} files updated, committing changes"
          git("add #{cookbook_name}")
          git("commit -m 'Import #{github_path} version #{sha}' -- #{cookbook_name}")
          ui.info("Creating tag cookbook-site-imported-#{cookbook_name}-#{sha}")
          git("tag -f cookbook-site-imported-#{cookbook_name}-#{sha}")
          true
        else
          ui.info("No changes made to #{cookbook_name}")
          false
        end
      end

      def last_log_message_from_cookbook(cookbook_name)
        git("log chef-vendor-#{cookbook_name} -n 1").stdout.split("\n").last.strip
      end

    end
  end
end