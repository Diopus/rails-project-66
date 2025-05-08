# frozen_string_literal: true

class OctokitClientStub
  Repo = Struct.new(:name, :id, :full_name, :language, :clone_url, :ssh_url, :parent, :owner, :fork)

  # Stub for list of repos
  def repos
    [
      Repo.new(name: 'repo1', id: 1, language: 'Ruby', fork: false),
      Repo.new(name: 'repo2', id: 2, language: 'JavaScript', fork: false),
      Repo.new(name: 'repo3', id: 3, language: 'Python', fork: false),
      Repo.new(name: 'repo4', id: 4, language: nil, fork: true)
    ]
  end

  Owner = Struct.new(:login)
  @owner = Owner.new('user')

  @parent = Repo.new(language: 'Ruby')

  # Stub for repo info
  def repository(_)
    RepoFull.new(
      name: 'test',
      id: 4,
      full_name: 'test/test',
      language: 'JavaScript',
      clone_url: 'https://github.com/test/test.js.git',
      ssh_url: 'git@github.com:test/test.js.git',
      parent:,
      owner:,
      fork: true
    )
  end
end
