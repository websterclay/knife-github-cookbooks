class Chef
  class Knife
    class CookbookSCMRepoExtensions < CookbookSCMRepo

      def finalize_updates_from_github(cookbook_name, git_uri, sha)
        if update_count = updated?(cookbook_name)
          ui.info "#{update_count} files updated, committing changes"
          git("add #{cookbook_name}")
          git("commit -m 'Import #{cookbook_name} version #{git_uri}@#{sha}' -- #{cookbook_name}")
          ui.info("Creating tag cookbook-site-imported-#{cookbook_name}-#{sha}")
          git("tag -f cookbook-site-imported-#{cookbook_name}-#{sha}")
          true
        else
          ui.info("No changes made to #{cookbook_name}")
          false
        end
      end

    end
  end
end