# copy_file_to_another_repo_action
This GitHub Action copies a file from the current repository to a location in another repository

# Example Workflow en Repo [bx_templates](https://github.com/Blue-Express/bx_templates/blob/blue/.github/workflows/tmpl-repo-sync-env.yml)

```bash
# File 1
      - name: Pushes test file
        uses: Blue-Express/bx-actions-copy-file-to-another-repo@master
        env:
          API_TOKEN_GITHUB: ${{ secrets.TOKEN_REPO_TEMPLATE }}
        with:
          source_file: 'sonar/break_build.sh'
          source_repo: 'Blue-Express/bx_templates'
          destination_repo: 'Blue-Express/${{ github.event.repository.name }}'
          destination_folder: './'
          destination_branch: 'development'
          user_email: 'arquitectura@bx.cl'
          user_name: 'bx-arquitectura'
          commit_message: 'A custom message for the commit'

# File 2
      - name: Pushes test file
        uses: Blue-Express/bx-actions-copy-file-to-another-repo@master
        env:
          API_TOKEN_GITHUB: ${{ secrets.TOKEN_REPO_TEMPLATE }}
        with:
          source_file: 'files/artifact-cleanup.yml'
          source_repo: 'Blue-Express/bx_templates'
          destination_repo: 'Blue-Express/${{ github.event.repository.name }}'
          destination_folder: '.github/workflows/'
          destination_branch: 'development'
          user_email: 'arquitectura@bx.cl'
          user_name: 'bx-arquitectura'
          commit_message: 'A custom message for the commit'
```

# Variables

The `API_TOKEN_GITHUB` needs to be set in the `Secrets` section of your repository options. You can retrieve the `API_TOKEN_GITHUB` [here](https://github.com/settings/tokens) (set the `repo` permissions).

* `source_file`: The file or directory to be moved. Uses the same syntax as the `cp` command. Incude the path for any files not in the repositories root directory.
* `source_repo`: The source repository.
* `destination_repo`: The repository to place the file or directory in.
* `destination_folder`: [optional] The folder in the destination repository to place the file in, if not the root directory.
* `user_email`: The GitHub user email associated with the API token secret.
* `user_name`: The GitHub username associated with the API token secret.
* `destination_branch`: [optional] The branch of the source repo to update, if not "main" branch is used.
* `destination_branch_create`: [optional] A branch to be created with this commit, defaults to commiting in `destination_branch`
* `commit_message`: [optional] A custom commit message for the commit. Defaults to `Update from https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}`

# Behavior Notes
The action will create any destination paths if they don't exist. It will also overwrite existing files if they already exist in the locations being copied to. It will not delete the entire destination repository.
